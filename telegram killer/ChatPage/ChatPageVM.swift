//
//  ChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//
import Foundation

import Combine

@MainActor
class ChatPageVM : ObservableObject {
    var usersChat : UsersChat
    var hub: chatHub
    var routerChat : router
    var authServ : authService = authService()
    var myId : String
    var usersEmail : String
    var chatId : String
  @Published  var lastRead : String?
 
   @Published var isLoaded = true
    @Published var messages: [Message] = []
    
    @Published var lastReadofPerson = ""
    
    @Published var initialScrollTarget: String? = nil
    
    private let dataSource : ChatDataSourceProtocol

    
    let chatServ : ChatService = ChatService()
    
    init(chatHub: chatHub,router : router, messages : Messages, usersChat : UsersChat , myId : String , usersEmail : String, with dataSource : ChatDataSourceProtocol) {
        self.hub = chatHub
        
        self.routerChat = router
        
        self.dataSource = dataSource
        
        self.usersChat = usersChat
        
        self.myId = myId
        
        self.usersEmail = usersEmail
        
        self.messages = messages.messages.map { message in
            Message(id:
                    message.id,
                    message: message.content,
                    fromMe: message.senderId == myId, sentAt: message.sentAt)
        }
        self.chatId = messages.chatId
        print("last read \(messages.lastReadMessageId)")
        if let las = messages.lastReadMessageId {
            self.lastRead = las
            print("lastRead from server: \(las)")
           
        }
        if let lasOther = messages.otherParticipantReadStates.first?.lastReadMessageId {
            self.lastReadofPerson = lasOther
        }
        
        
        
    }
    
    func saveChat(email : String , lastMessage : MessageInfo){
        let newChat = DestinationChats(email: email, lastMessage: lastMessage.content, sentAt: lastMessage.sentAt)
        dataSource.upsert(lastChat: newChat)
    }
    
    func startConnection() async   {

        try? await self.startConnectionMessage()

    }
    
    
    func startConnectionMessage() async throws {
        
       try? await RefreshService.withTokenRefresh({
            try await self.hub.startConnection()
           try await self.hub.joinChat(chatId: usersChat.chatId)
        }, router:routerChat)
      
        isLoaded = false
        
       
  
        Task{
            for await message in self.hub.readReceiptStream {
                print("received message \(message)")
                self.lastReadofPerson = message.messageId
            }
        }
        Task{
            for await message in self.hub.messageStream {
                // false represents that message is not mine
                self.messages.append(Message(id: message.id, message: message.content , fromMe: myId == message.senderId, sentAt: message.sentAt))
                self.saveChat(email: usersEmail, lastMessage: message )
                
            }
        }
      
        
        
    }
    
    
    func sendMessage(to: String, message: String) async  {
        
      try?  await RefreshService.withTokenRefresh({
            try await self.hub.sendMessage(chatId: usersChat.chatId , content: message)
        }, router:routerChat)
    }
    
    func markAsRead(messageId : String ) async {
        print("calling markAsRead with: \(messageId)") 
        try? await RefreshService.withTokenRefresh({
            try await self.hub.markAsReadRequest(chatId: chatId , messageId:  messageId)
        }, router: routerChat)
    }
    
}


enum ErrorChat  : Error {
    case NotFound
    case BadRequest
}



