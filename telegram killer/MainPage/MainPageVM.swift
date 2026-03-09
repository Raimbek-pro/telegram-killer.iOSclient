//
//  MainPageVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//



import Combine

import Foundation

class MainPageVM : ObservableObject {
    
    let chatServ : ChatService = ChatService()
    
    var routerChat : router
    
    init(routerChat: router) {
        self.routerChat = routerChat
    }
    
    func createChat(email : String) async throws  {
        
      let id =   try  await getId(to: email )
        
        let usersChat = try await chatServ.createChat(id: id)
        
        let messages = try await loadMessages(chatId: usersChat.chatId)
        
        routerChat.movetoChat(messages: messages, usersChat: usersChat)
        
       
    }
    
    
    func getId(to : String) async throws -> String {
        
        do{
           let id =  try await self.chatServ.accountId(email: to )
            return id
        } catch{
            throw ErrorChat.NotFound
        }
        

    }
    
    func loadMessages(chatId : String ) async throws -> Messages {
        
     let messages =  try await  chatServ.getMessages(chatId: chatId)
        return messages
    }
    
}
