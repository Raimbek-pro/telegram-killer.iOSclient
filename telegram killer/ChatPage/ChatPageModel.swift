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


struct Message : Hashable {
    
    let message : String
    let fromMe : Bool 
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
    let messages : [MessageInfo]
}

struct MessageInfo : Codable {
    let id : String
    let chatId : String
    let senderId : String
    let content : String
    let sentAt  : String
}
