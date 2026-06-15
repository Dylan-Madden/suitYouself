//
//  ClothingItem.swift
//  clothingMatcher
//
//  Created by Dylan Madden on 4/10/25.
//

import Foundation

struct ClothingItem: Identifiable {
    let id = UUID()
    var type: ClothingType
    // var color: Color - for the future
}

/// all clothing types used in the app (will expand)
enum ClothingType: String, CaseIterable {
    case shirt, pants, blazer, tie, shoes, belt
}

extension ClothingType: Identifiable {
    var id: String { rawValue }
}

enum CasualClothingType: String, CaseIterable, Identifiable {
    case tshirt, pants, shoes, belt, glasses, hat, hair
    var id: String { rawValue }
}
