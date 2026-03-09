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
    var messagesHistory : Messages
    var hub: chatHub
    var routerChat : router
    var authServ : authService = authService()
    
    @Published var messages: [Message ] = []
    
    
    var id = ""
    
    let chatServ : ChatService = ChatService()
    
    init(chatHub: chatHub,router : router, messages : Messages, usersChat : UsersChat) {
        self.hub = chatHub
        
        self.routerChat = router
        
        self.messagesHistory = messages
        
        self.usersChat = usersChat
        
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
                      routerChat.movetoLogIn()
            }
            catch{
                print("no internet")
            }
            
            
        
            
        }
        
      
    }
    
    
    func startConnectionMessage() async throws {
        
        try await self.hub.startConnection()
        
        for await message in self.hub.messageStream {
            // false represents that message is not mine
            self.messages.append(Message(message: message, fromMe: false))
        }
    }
    
    
    func sendMessage(to: String, message: String) async  {
        
        do{
            try await  self.hub.sendMessage(to: id , message: message)
        } catch {
            do{
                try await authServ.sendRefreshToken()
                
                try await  self.hub.sendMessage(to: id, message: message)
            } catch codeError.unauthorized {
                try? keychainService.deleteTokens()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      routerChat.movetoLogIn()
            } catch {
                print("no internet")
            }
           
        }
     
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
}



