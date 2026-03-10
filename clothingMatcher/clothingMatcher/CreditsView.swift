//
//  CreditsView.swift
//  clothingMatcher
//
//  Created by Dylan Madden on 4/8/25.
//

import SwiftUI

//Showing credits to the supporters
struct CreditsView: View {
    @Environment(\.dismiss) var dismiss //used to dismiss the view (not always needed)

    var body: some View {
        ZStack {
            //background like always
            LinearGradient(
                gradient: Gradient(colors: [Color.gradientStart, Color.gradientEnd]),startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()

            VStack(spacing: 20) {
                //title for credits
                Text("Credits")
                    .font(.largeTitle)
                    .foregroundColor(.black)

                Text("Made by me. REDDIT, Apple, StackOverflow, Mr. Miller, entire software class, and my Mom \n (thanks for staying up and watching me present)")
                    .multilineTextAlignment(.center)
                    .padding()
                    .foregroundColor(.black)

                Spacer()
            }
            .padding()
        }
        .navigationTitle("Credits")
    }
}

