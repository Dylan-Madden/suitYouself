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
                                StyleSelectorButton(title: "Fancy", imageName: "person.fill", color: .purple)
                            }
                            Text("Fancy is used for suits and other clothing used for formal events.")
                        }
                        //casual view (not finished)
                        
                        HStack {
                            NavigationLink(destination: CasualView()) {
                                StyleSelectorButton(title: "Casual", imageName: "tshirt.fill", color: .green)
                            }
                            Text("This is used for casual clothing and something you might wear for a nice dinner out. \n BETA")
                        }
                        
                        //lounge view (not finished)
                        HStack {
                            NavigationLink(destination: LoungeView()) {
                                StyleSelectorButton(title: "Lounge", imageName: "bed.double.fill", color: .orange)
                            }
                            Text("If you're deciding what to wear on a rainy day or at the movie theater, this is for you. \n BETA")
                        }
                        //navigagtion link to content view
                        
                        NavigationLink(destination: ContentView()) {
                            HStack(spacing: 10) {
                                Image(systemName: "arrowshape.backward")
                                    .foregroundColor(.white)
                                    .imageScale(.medium)
                                
                                Text("Back")
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .frame(width: 200)
                            .background(Color.red)
                            .cornerRadius(10)
                        }
                    }
                    .padding(.horizontal)
                    .navigationTitle("Choose Your Style")
                    .navigationBarBackButtonHidden(true)
                }
                //hides naviagtion bar so the user doesn't get 2 backbuttons (saves animation(sort of))
                
                Spacer()
                
            }
            .navigationTitle("Choose Your Style")
            .navigationBarBackButtonHidden(true)
        }
    }
    
}

#Preview {
    StyleSelectionView()
}
