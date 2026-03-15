//
//  LogOutVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 04.03.2026.
//

import Foundation
import Combine

class LogOutVM : ObservableObject {
    
    var router : router
    
    var authServ : authService = authService()
    init(router: router) {
        self.router = router
    }
    
    func sendLogout() async  {
        do{
            try await authServ.sendLogOut()
            self.moveToLogIn()
        }
        catch{
            do {
                try await authServ.sendRefreshToken()
                
                try await authServ.sendLogOut()
                self.moveToLogIn()
            } catch{
                try? keychainService.deleteTokens()
                try? keychainService.deleteId()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      self.moveToLogIn()
            }
    
            
        }
      
    }
    
    func moveToLogIn() {
        router.movetoLogIn()
    }
}
