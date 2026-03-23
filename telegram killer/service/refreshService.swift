//
//  refreshService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 15.03.2026.
//

import Foundation


final class RefreshService   {
    
    private static let dataSource : ChatDataSourceProtocol = LocalDataSource(container: SwiftDataContextManager.shared.container, context: SwiftDataContextManager.shared.context)

    private init() {
        
    }
    
    private static let refreshActor = TokenRefreshActor()
    
     static    func sendRefreshToken() async throws{
         
         
         let endpoint = URL(string: "\(servConf.baseURL)/api/account/tokens/refresh" )
         
      
         
         let reftoken =  keychainService.getRefreshToken()
         
         
         
         let tokenCodable = refsend(refreshToken: reftoken)
         
         
         let (data , responseCode) = try await endpointConf.confReq(codable: tokenCodable, endpoint: endpoint!)
         
         switch responseCode {
             
         case 200 :
             let tokenresp =  try JSONDecoder().decode(tokens.self, from: data)
             try keychainService.updateTokens(tokens: tokenresp)
             
             
         case 401 :
             
             throw codeError.unauthorized
             
         case 400 :
             throw ErrorChat.BadRequest
         default :
             
             throw codeError.unknown(responseCode)
         }
         
       
         
         
     }
    
    static func withTokenRefresh<T>(_ operation : () async throws -> T , router : router) async throws -> T? {
        
        
        do{
         return   try await  operation()
        } catch  ErrorChat.BadRequest{
            print("Something please pz")
            throw  ErrorChat.BadRequest
        }catch {
            do{
                try await refreshActor.refresh()
                
              return  try await  operation()
            } catch codeError.unauthorized {
                try? keychainService.deleteTokens()
                try? keychainService.deleteId()
                      UserDefaults().removeObject(forKey: "isAuthorized")
                self.dataSource.deleteAll()
                      router.movetoLogIn()
                        return nil
            } catch {
                print("no internet")
                return nil
            }
           
        }

    }
    
}

actor TokenRefreshActor {
    private var refreshTask: Task<Void, Error>?
    
    func refresh() async throws {
        if let existing = refreshTask {
            try await existing.value
            return
        }
        let task = Task {
            try await RefreshService.sendRefreshToken()
        }
        refreshTask = task
        defer { refreshTask = nil }
        try await task.value
    }
}
