//
//  ConfirmationVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import Combine
import Foundation

class ConfirmationVM : ObservableObject {
    var router : router
    
    init(routerConf: router) {
        self.router = routerConf
    }
    
    func sendCode(email : String , confCode : String ) async throws {
        
            try await authService().sendConf(email: email, confCode: confCode)
        

        
         
    }
    func navigateMain(){
        router.movetomainPage()
    }
}
