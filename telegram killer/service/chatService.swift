//
//  chatService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 08.03.2026.
//

import Combine
import Foundation
class ChatService : ObservableObject {
    
    func accountMe() async throws -> String {
        
        
        let endpoint = URL(string: "\(servConf.baseURL)/api/account/me" )!
        
        let (data , responseCode ) =   try  await  endpointConf.confReq( endpoint: endpoint , httpMethod:  "GET")
        
        switch responseCode {
            
        case 200 :
            let decoded = try JSONDecoder().decode(UserId.self, from: data)
            return decoded.id
            
        default :
            throw codeError.unknown(responseCode)
        }
        
    }
    
    
    func accountId(email :String) async throws -> String {
        
        let encoded = email.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? email
        let endpoint = URL(string: "\(servConf.baseURL)/api/account?email=\(encoded)" )!
        let accessToken = keychainService.getAccessToken()
        let (data , responseCode ) =   try  await  endpointConf.confReq( endpoint: endpoint ,accessToken:  accessToken , httpMethod:  "GET" )
        
        switch responseCode {
            
        case 200 :
            let decoded = try JSONDecoder().decode(UserId.self, from: data)
            return decoded.id
            
        default :
            throw codeError.unknown(responseCode)
        }
        
    }
    
    
    func createChat(id : String ) async throws -> UsersChat {
        let endpoint = URL(string : "\(servConf.baseURL)/api/chat")!
        let accessToken = keychainService.getAccessToken()
        let codable = otherUserId(otherUserId: id )
        let (data , responseCode ) =   try  await  endpointConf.confReq( codable: codable ,endpoint: endpoint ,accessToken:  accessToken  )
        
        switch responseCode {
        case 200:
            let decoded = try JSONDecoder().decode(UsersChat.self, from: data)
            return decoded
        
        default :
            throw codeError.unknown(responseCode)
        
        }
    }
    
    
    func getMessages( chatId :String) async throws -> Messages {
        

        let endpoint = URL(string: "\(servConf.baseURL)/api/chat?chatId=\(chatId)" )!
        let accessToken = keychainService.getAccessToken()
        let (data , responseCode ) =   try  await  endpointConf.confReq( endpoint: endpoint ,accessToken:  accessToken , httpMethod:  "GET" )
        
        switch responseCode {
            
        case 200 :
            let decoded = try JSONDecoder().decode(Messages.self, from: data)
            return decoded
            
        default :
            throw codeError.unknown(responseCode)
        }
        
    }

    
    
}
