import SwiftUI
import UIKit

struct SuitView: View {
    @State private var selectedType: ClothingType? = nil
    @State private var colors: [ClothingType: Color] = [:]
    @State private var feedbackText: String = ""
    @State private var showFeedbackView = false

    var body: some View {
        ZStack {
            LinearGradient(colors: [Color.suitViewStart.opacity(0.7), Color.suitViewEnd.opacity(0.7)], startPoint: .top, endPoint: .bottom).ignoresSafeArea()

            VStack(spacing: 0) {
                VStack(spacing: 8) {
                    Text("Build your outfit")
                        .font(.title)
                        .foregroundStyle(.black)

                    Text("Tap parts of the suit to choose colors. When you're happy with your choices, tap \"Submit Outfit\" for AI color matching advice.")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                .padding(.top)
                .padding(.bottom, 8)

                GeometryReader { geometry in
                    ZStack {
                        Image("blazerTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.blazer] ?? .clear)

                        Image("shirtTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.shirt] ?? .clear)

                        Image("pantsTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.pants] ?? .clear)

                        Image("tieTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.tie] ?? .clear)

                        Image("shoesTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.shoes] ?? .clear)

                        Image("beltTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(colors[.belt] ?? .clear)

                        Image("outlineTake5")
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
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
                .frame(maxWidth: .infinity, maxHeight: .infinity)

                Button("Submit Outfit") {
                    let description = generateOutfitDescription(from: colors)
                    print("outfit description:\n\(description)")

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

    private func hitTest(at tapPoint: CGPoint, in frameSize: CGSize) -> ClothingType? {
        guard let referenceImage = UIImage(named: "outlineTake5") else { return nil }
        let imageSize = referenceImage.size

        let scale = min(frameSize.width / imageSize.width, frameSize.height / imageSize.height)
        let offsetX = (frameSize.width - imageSize.width * scale) / 2
        let offsetY = (frameSize.height - imageSize.height * scale) / 2
        let imagePoint = CGPoint(
            x: (tapPoint.x - offsetX) / scale,
            y: (tapPoint.y - offsetY) / scale
        )

        let priority: [(ClothingType, String)] = [
            (.belt,   "beltTake5"),
            (.tie,    "tieTake5"),
            (.shoes,  "shoesTake5"),
            (.shirt,  "shirtTake5"),
            (.pants,  "pantsTake5"),
            (.blazer, "blazerTake5"),
        ]

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

    func generateOutfitDescription(from colors: [ClothingType: Color]) -> String {
        let orderedTypes: [ClothingType] = [.shirt, .blazer, .tie, .pants, .belt, .shoes]
        return orderedTypes.map { type in
            let name = type.rawValue.capitalized
            if let hex = colors[type]?.toHex() { return "\(name): \(hex)" }
            return "\(name): Not selected"
        }.joined(separator: "\n")
    }
}

extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }
        return String(format: "#%02X%02X%02X", Int(red * 255), Int(green * 255), Int(blue * 255))
    }
}

#Preview {
    SuitView()
}
