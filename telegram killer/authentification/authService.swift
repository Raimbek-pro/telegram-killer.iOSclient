//
//  authService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import Combine
class authService : ObservableObject {
    
    func sendEmail(_ email : String) async -> Bool  {
        
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return false}
        
        let endpoint = URL(string: "\(serv)/api/account/signup" )
        var request = URLRequest(url: endpoint!)
        let emailreq = emailreq(email:email )
        guard let body = try? JSONEncoder().encode(emailreq) else{ return false}

        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = "POST"
        
        request.httpBody = body
        
        do {
            let (data , response ) = try await URLSession.shared.data(for: request)
            
            let datares = try JSONDecoder().decode(signUpResp.self, from: data)
            
            
            return true
        }
        catch {
            print(error)
            return  false
        }
        
    }
}
