import SwiftUI

struct ColorSelectionView: View {
    var label: String
    var startingColor: Color
    var onColorPicked: (Color) -> Void

    @Environment(\.dismiss) var dismiss
    @State private var selectedColor: Color

    init(label: String, startingColor: Color, onColorPicked: @escaping (Color) -> Void) {
        self.label = label
        self.startingColor = startingColor
        self.onColorPicked = onColorPicked
        _selectedColor = State(initialValue: startingColor)
    }

    var body: some View {
        VStack(spacing: 30) {
            Text("Choose a color for your \(label)")
                .font(.title)
                .padding(.top)

            ColorPicker("Select color", selection: $selectedColor, supportsOpacity: false)
                .labelsHidden()
                .scaleEffect(1.5)
                .padding()

            Button("Save Color") {
                onColorPicked(selectedColor)
                dismiss()
            }
            .padding()
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
