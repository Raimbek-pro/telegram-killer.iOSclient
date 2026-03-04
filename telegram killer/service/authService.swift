//
//  authService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import Combine
class authService : ObservableObject {
    
    
    func sendLogEmail(_ email : String) async throws {
        UserDefaults.standard.set("http://localhost:8080", forKey: "server")
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return }
        
        let endpoint = URL(string: "\(serv)/api/account/signin" )
        var request = URLRequest(url: endpoint!)
        let emailreq = emailreq(email:email )
        guard let body = try? JSONEncoder().encode(emailreq) else{ return }

        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = "POST"
        
        request.httpBody = body
        
      
            let (data , response ) = try await URLSession.shared.data(for: request)
        

        
        guard let response  = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
            
             
           
            
            if response.statusCode == 200 {
                let _ = try JSONDecoder().decode(signUpResp.self, from: data)
               
            }
            else{
                
                if response.statusCode == 409 {
                    throw NSError(domain: "httperror", code: 409, userInfo: [NSLocalizedDescriptionKey: "409"] )
                }
                else if response.statusCode == 500 {
                    throw  NSError(domain: "internalError", code: 500 , userInfo: [NSLocalizedDescriptionKey: "Problems with server"])
                }
                else if response.statusCode == 400{
                    throw NSError(domain: "badReques", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad request. Please check your input."])
                }
                
            }
            
            return
        
     
    }
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
        

        
        guard let response  = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
            
             
           
            
            if response.statusCode == 200 {
                let _ = try JSONDecoder().decode(signUpResp.self, from: data)
               
            }
            else{
                
                if response.statusCode == 409 {
                    throw NSError(domain: "httperror", code: 409, userInfo: [NSLocalizedDescriptionKey: "409"] )
                }
                else if response.statusCode == 500 {
                    throw  NSError(domain: "internalError", code: 500 , userInfo: [NSLocalizedDescriptionKey: "Problems with server"])
                }
                else if response.statusCode == 400{
                    throw NSError(domain: "badReques", code: 400, userInfo: [NSLocalizedDescriptionKey: "Bad request. Please check your input."])
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
                //refresh
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
                if response.statusCode == 400 {
                    throw NSError(domain: "httperror", code: 409, userInfo: [NSLocalizedDescriptionKey: "you messed up it is not that code"] )
                }
                else if response.statusCode == 500 {
                    throw  NSError(domain: "internalError", code: 500 , userInfo: [NSLocalizedDescriptionKey: "Problems with server"])
                }
                else if response.statusCode == 404 {
                    throw  NSError(domain: "notFound", code: 404 , userInfo: [NSLocalizedDescriptionKey: "something strange happened"])
                }
               
            }
            
        

      
        
        
    }
    
    
    func sendLogOut() async throws {
        UserDefaults.standard.set("http://localhost:8080", forKey: "server")
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return }
        
        let endpoint = URL(string: "\(serv)/api/account/logout" )
        
        var request = URLRequest(url: endpoint!)
        
        
        let queryref = [
            kSecAttrAccount : "refreshToken",
            kSecClass:kSecClassGenericPassword,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
            
        ] as CFDictionary
        
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(queryref , &item)
        
        
        
        var reftoken = ""
        
        if status == errSecSuccess , let passwordData = item as? Data {
            let ref = String(decoding : passwordData , as :  UTF8.self)
            reftoken = ref
            print(reftoken)
        }
        
        let tokenCodable = refsend(refreshToken: reftoken)
        
        
        guard let body = try? JSONEncoder().encode(tokenCodable) else{ return }
        
        let queryacc = [
            kSecAttrAccount : "accessToken",
            kSecClass:kSecClassGenericPassword,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
            
        ] as CFDictionary
        
        
        var itemacc: CFTypeRef?
        let statusacc = SecItemCopyMatching(queryacc , &itemacc)
        
        
        var accesstoken = ""
        
        
        if statusacc == errSecSuccess , let passwordData = itemacc as? Data {
            let acc = String(decoding : passwordData , as :  UTF8.self)
            accesstoken = acc
            print(accesstoken)
        }
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = "POST"
        
        request.httpBody = body
        
               request.setValue("Bearer \(accesstoken)", forHTTPHeaderField: "Authorization")
        print("---- REQUEST ----")
        print("URL:", request.url?.absoluteString ?? "")
        print("Method:", request.httpMethod ?? "")
        print("Headers:", request.allHTTPHeaderFields ?? [:])

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8) {
            print("Body:", bodyString)
        }
        print("-----------------")
        
        let (_ , response ) = try await URLSession.shared.data(for: request)
        
        
        guard let response  = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse)
            }
            
        if response.statusCode == 204 {
            
            let querydel = [
                kSecAttrAccount : "refreshToken",
                kSecClass:kSecClassGenericPassword,
            
                
            ] as CFDictionary
            
            
            let statusdel = SecItemDelete(querydel)
            print(statusdel)
            let querydelacc = [
                kSecAttrAccount : "accessToken",
                kSecClass:kSecClassGenericPassword,
            
                
            ] as CFDictionary
            
            let statusdelacc = SecItemDelete(querydelacc)
            print(statusdelacc)
            
            UserDefaults().removeObject(forKey: "isAuthorized")
        
            
            
            
        }
        else{
            if response.statusCode == 400{
                throw NSError(domain: "400", code: 400)
            }
            else{
                throw NSError(domain: "403", code: 403)
            }
        }
        
        
    }
}
