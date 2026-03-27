//
//  ChatPageModel.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 08.03.2026.
//


struct UserId : Codable {
    
    let id : String 
    
    let email : String
}


struct Message : Identifiable, Hashable {
    let id : String
    let message : String
    let fromMe : Bool
    let sentAt : String
}


struct otherUserId : Codable {
    let otherUserId : String
}


struct UsersChat : Codable {
    
    let chatId : String
    
    let participants : [String]
    
    let createdAt : String
    
}





struct Messages : Codable {
    let chatId : String
    let messages : [MessageInfo]
    let lastReadMessageId : String?
    let otherParticipantReadStates : [OtherParticapantReadStates]
}

struct MessageInfo : Codable , Identifiable{
    let id : String
    let chatId : String?
    let senderId : String
    let content : String
    let sentAt  : String
}



struct MessageRead  : Codable {
    let chatId : String
    let messageId : String
    let userId : String
    let readAt : String
    
}


struct OtherParticapantReadStates : Codable {
    let userId : String
    let lastReadMessageId : String?
}
