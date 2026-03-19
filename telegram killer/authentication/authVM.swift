//
//  authVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import Foundation
import Combine

class authVM : ObservableObject {
    var router : router
    var authServ : authService = authService()
    init(router: router) {
        self.router = router
    }
    
    func sendemail(email : String) async   throws {
        
          try  await authServ.sendEmail(email)

     
           }
    
    func navigate(){
        self.router.movetoconf()
    }
    
    
    func sendLogEmail(email : String ) async throws {
        try await authServ.sendLogEmail(email)
    }
}
