import SwiftUI

//view of user picking the color of an item
struct ColorSelectionView: View {
    var type: ClothingType //clothing type
    var startingColor: Color //always starts blank
    var onColorPicked: (Color) -> Void

    @Environment(\.dismiss) var dismiss //to dismiss the view
    @State private var selectedColor: Color //picked color

    //initializes all the vars (completion handler)
    init(type: ClothingType, startingColor: Color, onColorPicked: @escaping (Color) -> Void) {
        self.type = type
        self.startingColor = startingColor
        self.onColorPicked = onColorPicked
        _selectedColor = State(initialValue: startingColor)
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Choose a color for your \(type.rawValue.capitalized)")
                .font(.title)
                .padding(.top)

            //color pciker
            ColorPicker("Select color", selection: $selectedColor, supportsOpacity: false)
                .labelsHidden()
                .scaleEffect(1.5)
                .padding()

            //save button that triggers the callback and dismisses the whole view and brings user back to the suit
            Button("Save Color") {
                onColorPicked(selectedColor)
                dismiss()
            }
            .padding()
            //.frame(maxWidth: .infinity)
            .background(Color(red: 0.18, green: 0.25, blue: 0.50))
            .foregroundColor(.white)
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(
            LinearGradient(
                colors: [Color.gradientStart, Color.gradientEnd],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }
}
