//
//  authService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import Combine
class authService : ObservableObject {
    
    func sendEmail(_ email : String) async  throws {
        UserDefaults.standard.set("http://localhost:8080", forKey: "server")
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return }
        
        let endpoint = URL(string: "\(serv)/api/account/signup" )
        var request = URLRequest(url: endpoint!)
        let emailreq = emailreq(email:email )
        guard let body = try? JSONEncoder().encode(emailreq) else{ return }

        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = "POST"
        
        request.httpBody = body
        
        
            let (data , response ) = try await URLSession.shared.data(for: request)
            
            let _ = try JSONDecoder().decode(signUpResp.self, from: data)
             
            guard let response  = response as? HTTPURLResponse else {
                throw URLError(.badServerResponse)
                }
            
            if response.statusCode == 200 {
                print("good")
            }
            else{
                
                if response.statusCode == 409 {
                    throw NSError(domain: "httperror", code: 409)
                }
                else{
                    throw URLError(.badServerResponse)
                }
                
            }
            
            return
        
     
        
    }
    
    
    func sendConf( email : String  , confCode : String ) async throws {
        
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return }
        guard  let endpoint = URL(string: "\(serv)/api/account/email/confirm") else {return}
        
        var request = URLRequest(url: endpoint)
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod = "POST"
        let reqbody = confirmReq(email: email, confirmationCode: confCode)
        guard let body = try? JSONEncoder().encode(reqbody) else {return}
        
        request.httpBody = body
        
            let (data , response ) = try await URLSession.shared.data(for: request)
            
            
            guard let response =  response as? HTTPURLResponse else {return}
            if response.statusCode == 200{
                
                UserDefaults.standard.set(1, forKey: "isAuthorized")
                
                let tokenresp =  try JSONDecoder().decode(tokens.self, from: data)
                
                let queryrefresh  = [kSecValueData :tokenresp.refreshToken.data(using: .utf8) as Any,
                                   kSecAttrAccount : "refreshToken",
                                          kSecClass:kSecClassGenericPassword
                                     
                ]   as CFDictionary
                
                let statusref = SecItemAdd(queryrefresh , nil)
                
                print(statusref)
                
                //access token in keychain
                
                let queryaccess = [     kSecValueData :tokenresp.accessToken.data(using: .utf8) as Any,
                                      kSecAttrAccount : "accessToken",
                                             kSecClass:kSecClassGenericPassword
                                        
                                        
                ]   as CFDictionary
                
                let statusacc = SecItemAdd(queryaccess , nil)
                
                print(statusacc)
            }
            else{
                throw URLError(.badServerResponse)
            }
            
        

      
        
        
    }
}
