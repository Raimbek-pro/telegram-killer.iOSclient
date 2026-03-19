//
//  MainPageModel.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//



import SwiftData

@Model
class DestinationChats {
    var email : String
    var lastMessage : String
    var sentAt : String
    init(email: String , lastMessage: String  , sentAt : String ) {
        self.email = email
        self.lastMessage = lastMessage
        self.sentAt = sentAt
    }
}
