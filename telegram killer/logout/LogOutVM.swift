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
    
    func sendLogout() async throws {
       try await authServ.sendLogOut()
    }
    
    func moveToLogIn() {
        router.movetoLogIn()
    }
}
