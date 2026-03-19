//
//  ChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//
import Foundation

import Combine

class ChatPageVM : ObservableObject {
    var usersChat : UsersChat
    var hub: chatHub
    var routerChat : router
    var authServ : authService = authService()
    var myId : String
    var usersEmail : String
   @Published var isLoaded = false
    @Published var messages: [Message ] = []
    
    private let dataSource : ChatDataSourceProtocol

    
    let chatServ : ChatService = ChatService()
    
    init(chatHub: chatHub,router : router, messages : Messages, usersChat : UsersChat , myId : String , usersEmail : String, with dataSource : ChatDataSourceProtocol) {
        self.hub = chatHub
        
        self.routerChat = router
        
        self.dataSource = dataSource
        
        self.usersChat = usersChat
        
        self.myId = myId
        
        self.usersEmail = usersEmail
        
        self.messages = messages.map { message in
            Message(id:
                    message.id,
                    message: message.content,
                    fromMe: message.senderId == myId)
        }
    }
    
    
    func saveChat(email : String , lastMessage : MessageInfo){
        let newChat = DestinationChats(email: email, lastMessage: lastMessage.content, sentAt: lastMessage.sentAt)
        dataSource.upsert(lastChat: newChat)
    }
    
    func startConnection() async   {
        
        
     try?   await  RefreshService.withTokenRefresh( {
            try await self.startConnectionMessage()
        }, router: routerChat )
                                                
   
      
    }
    
    
    func startConnectionMessage() async throws {
        
       try? await RefreshService.withTokenRefresh({
            try await self.hub.startConnection()
           try await self.hub.joinChat(chatId: usersChat.chatId)
        }, router:routerChat)
       
        isLoaded = true
        
        for await message in self.hub.messageStream {
            // false represents that message is not mine
            self.messages.append(Message(id: message.id, message: message.content , fromMe: myId == message.senderId))
            self.saveChat(email: usersEmail, lastMessage: message )
            
        }
        
        
    }
    
    
    func sendMessage(to: String, message: String) async  {
        
      try?  await RefreshService.withTokenRefresh({
            try await self.hub.sendMessage(chatId: usersChat.chatId , content: message)
        }, router:routerChat)
        
  
     
     
    }
    
//    func getId(to : String) async throws -> String {
//        
//        do{
//           let id =  try await self.chatServ.accountId(email: to )
//            return id
//        } catch{
//            throw ErrorChat.NotFound
//        }
//        
//
//    }
    

    
    
}


enum ErrorChat  : Error {
    case NotFound
    case BadRequest
}



