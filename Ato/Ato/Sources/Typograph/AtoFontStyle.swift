//
//  AtoFontStyle.swift
//  Ato
//
//  Created by hawon on 5/31/26.
//
import SwiftUI

enum AtoFontWeight: String {
    case regular = "Paperlogy-4Regular"
    case medium = "Paperlogy-5Medium"
    case semiBold = "Paperlogy-6SemiBold"
    case bold = "Paperlogy-7Bold"
}

extension Font {
    static func ato(
        _ weight: AtoFontWeight,
        _ size: CGFloat
    ) -> Font {
        .custom(weight.rawValue, size: size)
    }
}
