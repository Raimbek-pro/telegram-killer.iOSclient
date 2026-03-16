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
            .withUrl(url: "ws://localhost:8080/hub/chat" , options:  options)
            .build()
    }
    
    func startConnection() async  throws{
        
        await connection.stop()
        
        
        
        
        
        
        try await connection.start()
        
        print("connected")
    }
    
    
    
    func joinChat(chatId : String ) async throws {
        try await connection.send(method: "joinChat", arguments: chatId )
        print("joined")
        
    }
    
    
    func sendMessage(chatId : String , content : String) async throws {
        try await connection.send(method: "SendMessage", arguments: chatId , content)
        print("sent")
        
    }
    
    
    
    
    var messageStream : AsyncStream<MessageInfo> {
        AsyncStream { continuation in
            
            Task {
                await connection.on("ReceiveMessage"){ (  message : MessageInfo ) in
                    print("to \(message.id ) sending \(message.content) at \(message.sentAt)")
                    continuation.yield(message)
                }
                
            }
        }
        
        
        
        
    }
}
    
   

