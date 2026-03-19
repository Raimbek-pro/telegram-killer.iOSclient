//
//  SwiftDataContextManager.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 18.03.2026.
//

import SwiftData


class SwiftDataContextManager {
    static let shared = SwiftDataContextManager()
    
    var container: ModelContainer?
     var context : ModelContext?
    
    private init() {
        do {
            container = try ModelContainer(for: DestinationChats.self)
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }
}
