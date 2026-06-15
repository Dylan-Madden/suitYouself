//
//  ContentView.swift
//  clothingMatcher
//
//  Created by Dylan Madden on 2/13/25.
//

import SwiftUI

//Initial view of the app that welcomes the user and offers naviatgation to either select styles or to see credits
struct ContentView: View {
    var body: some View {
        NavigationStack {
            ZStack {
                //Background
                LinearGradient(colors: [Color.gradientStart.opacity(0.7), Color.gradientEnd.opacity(0.7)],startPoint: .top,endPoint: .bottom).ignoresSafeArea()

               //title
                VStack(spacing: 30) {
                    Text("Welcome to Suit Yourself")
                        .font(.largeTitle)
                        .multilineTextAlignment(.center)
                        .padding()

                    Text("Welcome to the first ever AI powered clothing app.")
                        .font(.title2)
                        .multilineTextAlignment(.center)

                    Text("Always leave the house with correct color matching clothes.")
                        .font(.title3)
                        .multilineTextAlignment(.center)

                    Text("Get AI powered feedback based on your inputs!!!")

                    //button to start the outfit building
                    NavigationLink(destination: StyleSelectionView()) {
                        Text("Start")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.18, green: 0.25, blue: 0.50))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .navigationBarBackButtonHidden(true)
                    .padding(.horizontal)

                    //view credits
                    NavigationLink(destination: CreditsView()) {
                        Text("Credits")
                            .font(.title2)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color(red: 0.35, green: 0.35, blue: 0.40))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)

                    Spacer()
                }
            }
        }
    }
}
