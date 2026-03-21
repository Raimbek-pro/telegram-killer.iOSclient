//
//  FormatDate.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 21.03.2026.
//

import Foundation


enum FormatDate {
    static func  formatDate(date : String) -> Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
         let newDate = formatter.date(from: date)
        
        return newDate
        
    }
}
