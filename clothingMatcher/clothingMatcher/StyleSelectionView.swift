import SwiftUI

//view to choose the style of outifts they want to build (fancy, casual or lounge wear??)
struct StyleSelectionView: View {
    var body: some View {
        ZStack {
            //background (very nice)
            LinearGradient(colors: [Color.gradientStart.opacity(0.7), Color.gradientEnd.opacity(0.7)],startPoint: .top,endPoint: .bottom).ignoresSafeArea()
            VStack(spacing: 40) {
                //all the buttons in a Vstack
                HStack {
                    VStack(spacing: 20) {
                        //the fancy button (only one that is fully active)
                        HStack {
                            NavigationLink(destination: SuitView()) {
                                StyleSelectorButton(title: "Fancy", imageName: "person.fill", color: Color(red: 0.20, green: 0.20, blue: 0.25))
                            }
                            Text("Fancy is used for suits and other clothing used for formal events.")
                        }
                        //casual view (not finished)

                        HStack {
                            NavigationLink(destination: CasualView()) {
                                StyleSelectorButton(title: "Casual", imageName: "tshirt.fill", color: Color(red: 0.08, green: 0.42, blue: 0.50))
                            }
                            Text("This is used for casual clothing and something you might wear for a nice dinner out. \n BETA")
                        }

                        //lounge view (not finished)
                        HStack {
                            NavigationLink(destination: LoungeView()) {
                                StyleSelectorButton(title: "Lounge", imageName: "bed.double.fill", color: Color(red: 0.50, green: 0.25, blue: 0.10))
                            }
                            Text("If you're deciding what to wear on a rainy day or at the movie theater, this is for you. \n BETA")
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Choose Your Style")
                }

                Spacer()

            }
            .navigationTitle("Choose Your Style")
        }
    }
    
}

#Preview {
    StyleSelectionView()
}
