//
//  MainPageVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//



import Combine

import Foundation
import SwiftData

class MainPageVM : ObservableObject {
    
    let chatServ : ChatService = ChatService()
    
    var routerChat : router
    

    
    private let dataSource : ChatDataSourceProtocol
    
    @Published var chats : [DestinationChats] = []
    
    init(routerChat: router , with dataSource : ChatDataSourceProtocol) {
        self.routerChat = routerChat
  
        self.dataSource = dataSource
        
        self.chats  = dataSource.fetchChats()
    }
    

    
    func fetchChats()  {
        self.chats  = dataSource.fetchChats()
    }
    
    func createChat(email : String) async throws  {
        
      let id =   try  await getId(to: email )
    
    
      guard  let usersChat =  try await  RefreshService.withTokenRefresh( {
         try await chatServ.createChat(id: id)
      }, router: routerChat ) else {return}
        
        let messages = try await loadMessages(chatId: usersChat.chatId)
      
       
        
        let myId = keychainService.getMyId()
            DispatchQueue.main.async{
                self.routerChat.movetoChat(messages: messages, usersChat: usersChat, myId: myId , email : email)
            }
        
       
        print("created chat")
  
        

        
       
    }
    
    
    func getId(to : String) async throws -> String {
        
        do{
            guard  let id =  try await  RefreshService.withTokenRefresh( {
               try await  self.chatServ.accountId(email: to )
            }, router: routerChat ) else {return "No"}
                //  let id =  try await self.chatServ.accountId(email: to )
            return id
        } catch ErrorChat.BadRequest{
            print("Something please")
            throw ErrorChat.BadRequest
        }
        

    }
    
    func loadMessages(chatId : String ) async throws -> Messages {
        
     let messages =  try await  chatServ.getMessages(chatId: chatId)
        return messages
    }
    
}
