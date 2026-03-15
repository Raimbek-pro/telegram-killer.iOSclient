//
//  authService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import Combine



class authService : ObservableObject {
    
    
    func accountMe() async throws -> String {
        
        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/me" )!
        var accesstoken = keychainService.getAccessToken()
        let (data , responseCode ) =   try  await  endpointConf.confReq( endpoint: endpoint ,accessToken: accesstoken, httpMethod:  "GET")
        
        switch responseCode {
            
        case 200 :
            let decoded = try JSONDecoder().decode(UserId.self, from: data)
            return decoded.id
            
        default :
            throw codeError.unknown(responseCode)
        }
        
    }
    
   
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
            try keychainService.deleteId()
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
            
            
        case 401 :
            
            throw codeError.unauthorized
        default :
            
            throw codeError.unknown(responseCode)
        }
        
      
        
        
    }
}
