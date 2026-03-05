//
//  authService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import Combine

enum servConf : String {
    
    case server = "http://localhost:8080"
    
    
    static var baseURL  : String{
        servConf.server.rawValue
    }
    
}


enum codeError : Error {
    
    case conflict
    case internalServer
    case badRequest
    case notFound
    case unknown(Int)
}

enum  endpointConf {
    
    static func confReq(codable : Codable? , endpoint : URL , accessToken : String? = nil )  async   throws -> (Data, Int) {
        
        var request = URLRequest(url: endpoint)
        if let codable = codable {
            guard let body = try? JSONEncoder().encode(codable) else{ throw   codeError.badRequest}
            request.httpBody = body
        }
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = "POST"
    
        if let accessToken = accessToken {
            request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        
        let (data , response ) = try await URLSession.shared.data(for: request)
    

    
    guard let response  = response as? HTTPURLResponse else {
        throw URLError(.badServerResponse)
        }
        
        return (data, response.statusCode)
    }
}


class authService : ObservableObject {
    
   
    func sendLogEmail(_ email : String) async throws {
      
        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/signin" )
        let emailreq = emailreq(email:email )
        let (data , responseCode ) = try await endpointConf.confReq(codable: emailreq, endpoint: endpoint!)
    

        
        switch responseCode {
            
        case 200 :
            let _ = try JSONDecoder().decode(signUpResp.self, from: data)
            
        case 409 :
            throw codeError.conflict
            
        case 500 :
            throw codeError.internalServer
            
        case 400 :
            throw codeError.badRequest
            
        default :
            throw  codeError.unknown(responseCode)
        }
             
           
            
    
            
           
        
     
    }
    func sendEmail(_ email : String) async  throws {
 
        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/signup" )
        let emailreq = emailreq(email:email )
      let ( data , responseCode ) = try await  endpointConf.confReq(codable: emailreq, endpoint: endpoint!)
            
             
        switch responseCode {
            
        case 200 :
            let _ = try JSONDecoder().decode(signUpResp.self, from: data)
            
        case 409 :
            throw codeError.conflict
            
        case 500 :
            throw codeError.internalServer
            
        case 400 :
            throw codeError.badRequest
            
        default :
            throw  codeError.unknown(responseCode)
        }
        
        }
            
         
        
     
        
    
    
    
    func sendConf( email : String  , confCode : String ) async throws {
        
     
        guard  let endpoint = URL(string: "\(servConf.baseURL)/api/account/email/confirm") else {return}
        let reqbody = confirmReq(email: email, confirmationCode: confCode)
        
       let (data , responseCode ) =  try await endpointConf.confReq(codable: reqbody, endpoint: endpoint)
        
        switch responseCode {
        case 200 :
            UserDefaults.standard.set(1, forKey: "isAuthorized")
            
            let tokenresp =  try JSONDecoder().decode(tokens.self, from: data)
            
           try keychainService.writeTokens(tokens: tokenresp)
        case 400 :
            throw codeError.badRequest
        case 500 :
            throw codeError.internalServer
            
        case 404 :
            throw codeError.notFound
        default :
            throw codeError.unknown(responseCode)
            
        }
            
        

      
        
        
    }
    
    
    func sendLogOut() async throws {

        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/logout" )
        
        
      
        var request = URLRequest(url: endpoint!)
        
        var reftoken = keychainService.getRefreshToken()
        var accesstoken = keychainService.getAccessToken()
        
        let tokenCodable = refsend(refreshToken: reftoken)
        
        let (data , responseCode) =  try await endpointConf.confReq(codable: tokenCodable, endpoint: endpoint! , accessToken: accesstoken)
        
        switch responseCode {
            
        case 204 :
            try   keychainService.deleteTokens()
            UserDefaults().removeObject(forKey: "isAuthorized")
        default :
            throw codeError.unknown(responseCode)
            
            
        }
            
       
        
        
    }
    
    
    func sendRefreshToken() async throws{
  
        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/tokens/refresh" )
        
     
        
        var reftoken =  keychainService.getRefreshToken()
        
        
        
        let tokenCodable = refsend(refreshToken: reftoken)
        
        
        let (data , responseCode) = try await endpointConf.confReq(codable: tokenCodable, endpoint: endpoint!)
        
        switch responseCode {
            
        case 200 :
            let tokenresp =  try JSONDecoder().decode(tokens.self, from: data)
            try keychainService.updateTokens(tokens: tokenresp)
            
        default :
            
            throw codeError.unknown(responseCode)
        }
        
      
        
        
    }
}
