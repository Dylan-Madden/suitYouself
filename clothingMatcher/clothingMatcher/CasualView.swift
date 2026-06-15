import SwiftUI
import UIKit

struct CasualView: View {
    @State private var selectedType: CasualClothingType? = nil
    @State private var colors: [CasualClothingType: Color] = [:]
    @State private var showBelt = false
    @State private var showGlasses = false
    @State private var wearingHat = false
    @State private var feedbackText = ""
    @State private var showFeedbackView = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.suitViewStart.opacity(0.7), Color.suitViewEnd.opacity(0.7)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Build your outfit")
                        .font(.title)
                        .foregroundStyle(.black)

                    Text("Tap parts of the figure to choose colors. Use the toggles to add a belt, glasses, or switch between a hat and hair.")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 8)

                ZStack {
                    GeometryReader { geometry in
                        ZStack {
                            templateImage("casualTshirt", color: colors[.tshirt] ?? .white)
                            templateImage("casualPants",  color: colors[.pants]  ?? .white)
                            templateImage("casualShoes",  color: colors[.shoes]  ?? .white)

                            if showBelt    { templateImage("casualBelt",    color: colors[.belt]    ?? .white) }
                            if showGlasses { templateImage("casualGlasses", color: colors[.glasses] ?? .white) }

                            if wearingHat {
                                templateImage("casualHat",  color: colors[.hat]  ?? .white)
                            } else {
                                templateImage("casualHair", color: colors[.hair] ?? .white)
                            }

                            templateImage("casualOutline", color: .black)
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .contentShape(Rectangle())
                        .onTapGesture { location in
                            if let type = hitTest(at: location, in: geometry.size) {
                                selectedType = type
                                print("Tapped: \(type.rawValue)")
                            }
                        }
                    }

                    HStack {
                        Spacer()
                        VStack(spacing: 20) {
                            toggleControl(label: showBelt ? "Belt" : "No Belt", isOn: $showBelt)
                            toggleControl(label: showGlasses ? "Glasses" : "No Glasses", isOn: $showGlasses)
                            toggleControl(label: wearingHat ? "Hat" : "Hair", isOn: $wearingHat)
                        }
                        .padding()
                        .background(.ultraThinMaterial)
                        .cornerRadius(12)
                        .padding(.trailing, 12)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Button("Submit Outfit") {
                    let description = generateOutfitDescription()
                    print("casual outfit description:\n\(description)")

                    getOutfitFeedback(from: description) { feedback in
                        DispatchQueue.main.async {
                            self.feedbackText = feedback ?? "Sorry, couldn't get feedback right now."
                            self.showFeedbackView = true
                        }
                    }
                }
                .font(.title2)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color(red: 0.18, green: 0.25, blue: 0.50))
                .foregroundColor(.white)
                .cornerRadius(12)
                .padding(.horizontal, 40)
                .padding(.vertical, 12)
            }

            if showFeedbackView {
                ZStack {
                    LinearGradient(colors: [Color.gradientStart.opacity(0.95), Color.gradientEnd.opacity(0.95)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()

                    VStack(spacing: 30) {
                        ScrollView {
                            Text(feedbackText)
                                .padding()
                                .font(.title3)
                                .foregroundColor(.black)
                        }

                        Button("Back") {
                            showFeedbackView = false
                        }
                        .padding()
                        .background(Color.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .padding()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .navigationTitle("Casual")
        .sheet(item: $selectedType) { type in
            ColorSelectionView(
                label: type.rawValue.capitalized,
                startingColor: colors[type] ?? .gray
            ) { selectedColor in
                colors[type] = selectedColor
                selectedType = nil
            }
        }
    }

    @ViewBuilder
    private func templateImage(_ name: String, color: Color) -> some View {
        if UIImage(named: name) != nil {
            Image(name)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .foregroundColor(color)
        }
    }

    private func toggleControl(label: String, isOn: Binding<Bool>) -> some View {
        VStack(spacing: 4) {
            Toggle("", isOn: isOn).labelsHidden()
            Text(label).font(.caption)
        }
    }

    private func hitTest(at tapPoint: CGPoint, in frameSize: CGSize) -> CasualClothingType? {
        let candidateNames = ["casualOutline", "casualTshirt", "casualPants", "casualShoes", "casualHair", "casualHat"]
        guard let referenceImage = candidateNames.lazy.compactMap({ UIImage(named: $0) }).first else { return nil }
        let imageSize = referenceImage.size

        let scale = min(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let offsetX = (frameSize.width - imageSize.width * scale) / 2
        let offsetY = (frameSize.height - imageSize.height * scale) / 2
        let imagePoint = CGPoint(
            x: (tapPoint.x - offsetX) / scale,
            y: (tapPoint.y - offsetY) / scale
        )

        var priority: [(CasualClothingType, String)] = []
        if showGlasses { priority.append((.glasses, "casualGlasses")) }
        priority.append(wearingHat ? (.hat, "casualHat") : (.hair, "casualHair"))
        priority.append((.tshirt, "casualTshirt"))
        if showBelt    { priority.append((.belt, "casualBelt")) }
        priority.append((.pants, "casualPants"))
        priority.append((.shoes, "casualShoes"))

        for (type, imageName) in priority {
            if isPixelOpaque(imageName: imageName, at: imagePoint) {
                return type
            }
        }
        return nil
    }

    private func isPixelOpaque(imageName: String, at point: CGPoint) -> Bool {
        guard let uiImage = UIImage(named: imageName) else { return false }
        let size = uiImage.size
        guard point.x >= 0, point.y >= 0, point.x < size.width, point.y < size.height else { return false }

        var pixel = [UInt8](repeating: 0, count: 4)
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        guard let context = CGContext(
            data: &pixel,
            width: 1, height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else { return false }

        // CG y-axis is flipped relative to UIImage: translate so target pixel lands at context (0.5, 0.5).
        context.translateBy(x: -point.x, y: point.y - size.height + 1)
        if let cgImage = uiImage.cgImage {
            context.draw(cgImage, in: CGRect(origin: .zero, size: size))
        }
        return pixel[3] > 0
    }

    private func generateOutfitDescription() -> String {
        var visibleTypes: [CasualClothingType] = [.tshirt, .pants, .shoes]
        if showBelt    { visibleTypes.append(.belt) }
        if showGlasses { visibleTypes.append(.glasses) }
        visibleTypes.append(wearingHat ? .hat : .hair)

        return visibleTypes.map { type in
            let name = type.rawValue.capitalized
            if let hex = colors[type]?.toHex() { return "\(name): \(hex)" }
            return "\(name): Not selected"
        }.joined(separator: "\n")
    }
}

#Preview {
    CasualView()
}
