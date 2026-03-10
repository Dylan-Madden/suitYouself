import SwiftUI

struct StyleSelectorButton: View {
    var title: String
    var imageName: String
    var color: Color
    // Remove the action parameter since NavigationLink will handle navigation
    
    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.white)
            
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
        }
        .frame(width: 150, height: 150)
        .background(color)
        .cornerRadius(15)
        .shadow(radius: 5)
    }
}
