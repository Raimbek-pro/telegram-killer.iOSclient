//
//  chathandlers.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//



import SignalRClient



import Foundation

class chatHub   {
    

    var connection : HubConnection

    
    init() {
        
        var  options = HttpConnectionOptions()
        
        options.accessTokenFactory = {
            return await keychainService.getAccessToken()
        }
        
        self.connection = HubConnectionBuilder()
            .withUrl(url: "\(servConf.baseURL)/hub/chat" , options:  options)
            .build()
        
     
    }
    
    func startConnection() async  throws{
        
        await connection.stop()
        
        
        
        
        
        
        try await connection.start()
        
        print("connected")
    }
    
    func markAsReadRequest(chatId : String , messageId : String ) async throws {
        try await connection.send(method: "MarkAsRead", arguments: chatId  , messageId )
        print("read")
        
    }
    
    func joinChat(chatId : String ) async throws {
        try await connection.send(method: "joinChat", arguments: chatId )
        print("joined")
        
    }
    
    func leaveChat(chatId : String ) async throws {
        try await connection.send(method: "leaveChat", arguments: chatId )
        print("left")
        
    }

    
    
    func sendMessage(chatId : String , content : String) async throws {
        try await connection.send(method: "SendMessage", arguments: chatId , content)
        print("sent")
        
    }
    
    
    
    
    private(set) lazy  var messageStream : AsyncStream<MessageInfo> = {
        AsyncStream { continuation in
            
            Task {
                await connection.on("ReceiveMessage"){ (  message : MessageInfo ) in
                    print("to \(message.id ) sending \(message.content) at \(message.sentAt)")
                    continuation.yield(message)
                }
                
            }
        }
    }()
    
    private(set) lazy   var readReceiptStream : AsyncStream<MessageRead> =  {
        AsyncStream { continuation in
            
            Task {
                await connection.on("MessageRead"){ (message : MessageRead) in
                 print("received")
                    continuation.yield(message)
                }

            }
            
        }
    }()
    
}
    
   

