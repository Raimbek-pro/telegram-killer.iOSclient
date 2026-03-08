//
//  chathandlers.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//



import SignalRClient



class chatHub {
    
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
       
          
        await receiveMessage()
        
        
        
        try await connection.start()
        
        print("connected")
    }
    
    func sendMessage(to : String , message : String) async throws {
        try await connection.send(method: "SendMessage", arguments: to , message)
        print("sent")
        
    }
    
    func receiveMessage() async  {
        print("try catching")
        await connection.on("ReceiveMessage"){ (to : String ,  message : String ) in
            print("to \(to ) sending \(message)")
            
        }
        
    }
        
        

        
        
    }
    
    
   

