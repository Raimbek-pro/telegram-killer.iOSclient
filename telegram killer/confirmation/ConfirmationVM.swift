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
    var authserv  : authService
    init(routerConf: router , authserv : authService) {
        self.router = routerConf
        self.authserv = authserv
    }
    
    func sendCode(email : String , confCode : String ) async throws {
        
            try await authserv.sendConf(email: email, confCode: confCode)
        

        
         
    }
    
    func writeId() async throws{
      let id =  try await authserv.accountMe()
        
        try keychainService.writeId(id: id)
        
    }
    func navigateMain(){
        router.movetomainPage()
    }
}
