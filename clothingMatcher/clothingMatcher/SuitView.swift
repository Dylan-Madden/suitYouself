import SwiftUI
import UIKit

//main view that is the bulk of the project. allows the user to customize a suit by chosing colors for each part of the sut
struct SuitView: View {
    @State private var selectedType: ClothingType? = nil     // currently tapped clothing type
    @State private var colors: [ClothingType: Color] = [:]   // stores selected colors by clothing type
    @State private var feedbackText: String = ""             // feedback returned by openAI
    @State private var showFeedbackView = false              // whether to display feedback overlay whcih can toggle



    var body: some View {
        ZStack {
            //simplier background which is more boring
            LinearGradient(colors: [Color.suitViewStart.opacity(0.7), Color.suitViewEnd.opacity(0.7)],startPoint: .top,endPoint: .bottom).ignoresSafeArea()
            //instructions and header
            Text("Build your outfit")
                .padding(.bottom, 740)
                .font(.title)
                .frame(maxWidth: .infinity)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            Text("Build your outfit by tapping on parts of the suit. Then choose the color of each clothing item. When you are satisfied with your choices, tap \"Submit Outfit\" to get color matching advice.")
            
                
                .font(.headline)
                .padding(.bottom, 600)
                .foregroundStyle(.black)
                .multilineTextAlignment(.center)
            
            //suit layer images that are ech individually mutable
            //all images start clear although the user can still pick an item to be the same color as the background
            //should i have the default color be something different?
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
            
            
            
            //transparent clickable zones for user interaction
            // in the future i want to make it so that the image is clickable but i don't really know how to and the feedback online is harder to understand
            //using speicifc coordinates causes for slight clicking errors on smaller phones
            tapZone(for: .blazer, x: 200, y: 280, width: 220, height: 260)
            tapZone(for: .shirt, x: 200, y: 250, width: 70, height: 200)
            tapZone(for: .tie, x: 200, y: 250, width: 30, height: 130)
            tapZone(for: .pants, x: 200, y: 505, width: 160, height: 190)
            tapZone(for: .belt, x: 200, y: 345, width: 60, height: 20)
            tapZone(for: .shoes, x: 200, y: 620, width: 220, height: 50)
            
            //the submit button to get the AI feedback
            Button("Submit Outfit") {
                let description = generateOutfitDescription(from: colors)
                print("outfit description:\n\(description)")
                
                getOutfitFeedback(from: description) { feedback in
                    DispatchQueue.main.async {
                        if let feedback = feedback {
                            self.feedbackText = feedback
                            print(feedback)
                            self.showFeedbackView = true
                        } else {
                            self.feedbackText = "Sorry, couldn’t get feedback right now."
                            self.showFeedbackView = true
                        }
                    }
                }
            }
        
            
            
            .multilineTextAlignment(.center)
            .padding()
            .frame(maxWidth: 200)
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)
            .padding(.top, 720)
            .font(.title)
        
        
            //what will pop up as a view when the show feedback is turned on. I originally had it as a seperate view but I wanted the suit to slighlty peek in the background of the feedback
            if showFeedbackView {
                ZStack {
                    //gradient backgorund with 95% opacity to allow the user to slightly see the suit
                    LinearGradient(colors: [Color.gradientStart.opacity(0.95),Color.gradientEnd.opacity(0.95)],startPoint: .top,endPoint: .bottom).ignoresSafeArea()

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
        //sheet for the selected clothing item that brings the color picker
        .sheet(item: $selectedType) { type in
            ColorSelectionView(
                type: type,
                startingColor: colors[type] ?? .gray
            ) { selectedColor in
                colors[type] = selectedColor
                selectedType = nil
            }
        }
    }
    

    //this is the individual tapzone for each button that is clickable.
    private func tapZone(for type: ClothingType, x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat) -> some View {
        Button {
            selectedType = type
            print("Tapped: \(type.rawValue)")
        } label: {
            Rectangle()
                .fill(Color.clear) //color.red.opacity(0.3) for debugging
                .frame(width: width, height: height)
        }
        .position(x: x, y: y)
    }
    
    //generated a text of the current outfit that is easier for the AI to read.
    func generateOutfitDescription(from colors: [ClothingType: Color]) -> String {
        let orderedTypes: [ClothingType] = [.shirt, .blazer, .tie, .pants, .belt, .shoes]
        var result = ""

        for type in orderedTypes {
            if let color = colors[type], let hex = color.toHex() {
                let typeName = type.rawValue.capitalized
                result += "\(typeName): \(hex)\n"
            } else {
                let typeName = type.rawValue.capitalized
                result += "\(typeName): Not selected\n"
            }
        }

        return result
    }
    
}

//converts the swiftui color into a hex code that makes open ai input a lot smoother. open ai kept on glitching when i didn't convert it to a hex.
//converting to hex was a function that was heaily based on mutiple reddit posts and stackover threads.
extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else { return nil }

        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)

        return String(format: "#%02X%02X%02X", r, g, b)
    }
}

#Preview {
    SuitView()
}


