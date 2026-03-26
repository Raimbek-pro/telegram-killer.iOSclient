//
//  colors.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 26.03.2026.
//

import SwiftUI


extension Color {
    static func appBackground(_ scheme: ColorScheme) -> Color {
        if scheme == .dark {
            return Color(red: 15/255, green: 15/255, blue: 100/255)
                .opacity(0.9)
        } else {
            return Color(.systemGray6)
        }
    }
}

