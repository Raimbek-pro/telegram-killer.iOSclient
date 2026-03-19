//
//  LocalDataSource.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 19.03.2026.
//



import Foundation

import SwiftData

@MainActor

protocol ChatDataSourceProtocol {
    func upsert(lastChat : DestinationChats)
    func fetchChats() -> [DestinationChats]
    func delete(lastChat : DestinationChats)
    func deleteAll()
}

class LocalDataSource : ChatDataSourceProtocol {
    private let container : ModelContainer?
    private let context : ModelContext?
    
    init(container: ModelContainer?, context: ModelContext?) {
        self.container = container
        self.context = context
    }
}


extension LocalDataSource {
    func upsert(lastChat : DestinationChats ) {
        if let existing = fetchChats().first(where: {$0.email == lastChat.email}) {
            existing.lastMessage = lastChat.lastMessage
            existing.sentAt = lastChat.sentAt
        }
        else {
            self.container?.mainContext.insert(lastChat)
        }
      
        
        try? self.container?.mainContext.save()
    }
    
    func fetchChats() -> [DestinationChats] {
        let fetchDescriptor = FetchDescriptor<DestinationChats>(sortBy: [SortDescriptor(\DestinationChats.sentAt, order: .forward)])
        let chats = try? self.container?.mainContext.fetch(fetchDescriptor)
        return chats ?? []
    }
    
    func delete( lastChat : DestinationChats) {
         self.container?.mainContext.delete(lastChat)
         try? self.container?.mainContext.save()
     }
    
    func deleteAll(){
        self.fetchChats().forEach{self.container?.mainContext.delete($0)}
        try? self.container?.mainContext.save()
    }
}

class MockLocalDataSource : ChatDataSourceProtocol {
    func delete(lastChat: DestinationChats) {
        mockChats.removeAll(where: {$0.email ==  lastChat.email} )
    }
    
    func deleteAll() {
        mockChats = []
    }
    
    
    var mockChats : [DestinationChats] = []
    func upsert(lastChat: DestinationChats) {
        mockChats.append(lastChat)
    }
    
    func fetchChats() -> [DestinationChats] {
        return mockChats
    }
    
    
}
