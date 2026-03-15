//
//  chatService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 08.03.2026.
//

import Combine
import Foundation
class ChatService : ObservableObject {
    

    
    
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
        case 201:
            print("f")
            do {
                let decoded = try JSONDecoder().decode(UsersChat.self, from: data)
            }
            catch{
                print("fff")
                print(error.localizedDescription)
            }
            let decoded = try JSONDecoder().decode(UsersChat.self, from: data)
            print("g")
            return decoded
        default :
            throw codeError.unknown(responseCode)
        
        }
    }
    
    
    func getMessages( chatId :String) async throws -> Messages {
        
        print("enter")
        let endpoint = URL(string: "\(servConf.baseURL)/api/chat/\(chatId)/messages" )!
        let accessToken = keychainService.getAccessToken()
        let (data , responseCode ) =   try  await  endpointConf.confReq( endpoint: endpoint ,accessToken:  accessToken , httpMethod:  "GET" )
        
        switch responseCode {
            
        case 200 :

            let decoded = try JSONDecoder().decode(Messages.self, from: data)
            return decoded
            
        case 401 :
            throw codeError.unauthorized
        case 404 :
            throw codeError.notFound
        default :
            throw codeError.unknown(responseCode)
        }
        
    }

    
    
}
