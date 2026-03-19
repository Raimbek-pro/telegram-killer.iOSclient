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
    private let dataSource : ChatDataSourceProtocol
    
    init(router: router, dataSource : ChatDataSourceProtocol) {
        self.router = router
        self.dataSource = dataSource
    }
    
    func sendLogout() async  {
        do{
            try await authServ.sendLogOut()
            dataSource.deleteAll()
            self.moveToLogIn()
        }
        catch{
            do {
                try await authServ.sendRefreshToken()
                
                try await authServ.sendLogOut()
                dataSource.deleteAll()
                self.moveToLogIn()
            } catch{
                try? keychainService.deleteTokens()
                try? keychainService.deleteId()
                dataSource.deleteAll()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                      self.moveToLogIn()
            }
    
            
        }
      
    }
    
    func moveToLogIn() {
        router.movetoLogIn()
    }
}
