//
//  ChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//
import Foundation

import Combine

class ChatPageVM : ObservableObject {
    
    var chatHub : chatHub
    var router : router
    var authServ : authService = authService()
    
    @Published var messages: [String] = []
    
    
    var id = ""
    
    let chatServ : ChatService = ChatService()
    
    init(chatHub: chatHub,router : router) {
        self.chatHub = chatHub
        self.router = router
    }
    
    func startConnection() async   {
        
        do{
        
            try await self.startConnectionMessage()
        }
        catch{
            print("❌ \(error)")
            do{
                
                
                try await authServ.sendRefreshToken()
                
                try await self.startConnectionMessage()
            }
            catch codeError.unauthorized {
                print("❌ retry failed: \(error)")
                try? keychainService.deleteTokens()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      router.movetoLogIn()
            }
            catch{
                
            }
            
            
        
            
        }
        
      
    }
    
    
    func startConnectionMessage() async throws {
        
        try await self.chatHub.startConnection()
        
        for await message in self.chatHub.messageStream {
            self.messages.append(message)
        }
    }
    
    
    func sendMessage(to: String, message: String) async  {
        
        do{
            try await  self.chatHub.sendMessage(to: id , message: message)
        } catch {
            do{
                try await authServ.sendRefreshToken()
                
                try await  self.chatHub.sendMessage(to: id, message: message)
            } catch {
                try? keychainService.deleteTokens()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      router.movetoLogIn()
            }
           
        }
     
    }
    
    func getId(to : String) async throws -> String {
        
        do{
           let id =  try await self.chatServ.accountId(email: to )
            return id
        } catch{
            throw ErrorChat.NotFound
        }
        

    }
    

    
    
}


enum ErrorChat  : Error {
    case NotFound
}
