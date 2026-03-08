//
//  ChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 07.03.2026.
//
import Foundation

import Combine

class ChatPageVM : ObservableObject {
    
    let chatHub : chatHub
    var router : router
    var authServ : authService = authService()
    
    init(chatHub: chatHub,router : router) {
        self.chatHub = chatHub
        self.router = router
    }
    
    func startConnection() async   {
        
        do{
        
            try await self.chatHub.startConnection()
        }
        catch{
            print("❌ \(error)")
            do{
                
                
                try await authServ.sendRefreshToken()
                
                try await self.chatHub.startConnection()
            }
            catch{
                print("❌ retry failed: \(error)")
                try? keychainService.deleteTokens()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      router.movetoLogIn()
            }
        
            
        }
        
      
    }
    
    func sendMessage(to: String, message: String) async  {
        
        do{
            try await  self.chatHub.sendMessage(to: to, message: message)
        } catch {
            do{
                try await authServ.sendRefreshToken()
                
                try await  self.chatHub.sendMessage(to: to, message: message)
            } catch {
                try? keychainService.deleteTokens()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      router.movetoLogIn()
            }
           
        }
     
    }
    

    
    
}
