//
//  keychainService.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 05.03.2026.
//

import Foundation

enum keychainService {
    
   static func deleteTokens() throws {
        
        let querydel = [
            kSecAttrAccount : "refreshToken",
            kSecClass:kSecClassGenericPassword,
        
            
        ] as CFDictionary
        
        
        let statusdel = SecItemDelete(querydel)
       
       if statusdel != errSecSuccess {
           throw keychainError.Failed(statusdel)
       }
        print(statusdel)
        let querydelacc = [
            kSecAttrAccount : "accessToken",
            kSecClass:kSecClassGenericPassword,
        
            
        ] as CFDictionary
        
        let statusdelacc = SecItemDelete(querydelacc)
        print(statusdelacc)
        
       if statusdelacc != errSecSuccess {
           throw keychainError.Failed(statusdelacc)
       }
        
    }
    
    
    static func updateTokens(tokens : tokens ) throws {
        
        let queryrefresh  = [kSecValueData :tokens.refreshToken.data(using: .utf8) as Any,
                           kSecAttrAccount : "refreshToken",
                                  kSecClass:kSecClassGenericPassword
                             
        ]   as CFDictionary
        
        let atrributesrefresh = [ kSecValueData : tokens.refreshToken.data(using: .utf8) ] as CFDictionary
        
        let statusref = SecItemUpdate(queryrefresh, atrributesrefresh)
        
        print(statusref)
        
        
        if statusref != errSecSuccess {
            throw keychainError.Failed(statusref)
        }
        
        
        //access token in keychain
        
        let queryaccess = [     kSecValueData :tokens.accessToken.data(using: .utf8) as Any,
                              kSecAttrAccount : "accessToken",
                                     kSecClass:kSecClassGenericPassword
                                
                                
        ]   as CFDictionary
        
        let atrributesaccess = [ kSecValueData : tokens.accessToken.data(using: .utf8) ] as CFDictionary
        let statusacc = SecItemUpdate(queryaccess , atrributesaccess)
        
        print(statusacc)
        
        if statusacc  != errSecSuccess {
            throw keychainError.Failed(statusacc)
        }
        
    }
    
    
    static func writeTokens(tokens : tokens ) throws {
        let queryrefresh  = [kSecValueData :tokens.refreshToken.data(using: .utf8) as Any,
                           kSecAttrAccount : "refreshToken",
                                  kSecClass:kSecClassGenericPassword
                             
        ]   as CFDictionary
        
        let statusref = SecItemAdd(queryrefresh , nil)
        
        print(statusref)
        
        if statusref != errSecSuccess {
            throw keychainError.Failed(statusref)
        }
        
        //access token in keychain
        
        let queryaccess = [     kSecValueData :tokens.accessToken.data(using: .utf8) as Any,
                              kSecAttrAccount : "accessToken",
                                     kSecClass:kSecClassGenericPassword
                                
                                
        ]   as CFDictionary
        
        let statusacc = SecItemAdd(queryaccess , nil)
        
        
        
        print(statusacc)
        
        if statusacc  != errSecSuccess {
            throw keychainError.Failed(statusacc)
        }
        
        
        
    }
    
    
    static  func getRefreshToken() -> String{
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
        
        return reftoken
    }
    
    static func getAccessToken() -> String {
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
        
        
        return accesstoken
    }
    
    
    static func writeId(id : String) throws {
        
        let id  = [kSecValueData : id.data(using: .utf8)!,
                           kSecAttrAccount : "myId",
                                  kSecClass:kSecClassGenericPassword
                             
        ]   as CFDictionary
        
        
        let statusref = SecItemAdd(id , nil)
        
        print(statusref)
    }
    
    static func  deleteId()  throws {
        let querydel = [
            kSecAttrAccount : "myId",
            kSecClass:kSecClassGenericPassword,
        
            
        ] as CFDictionary
        
        
        let statusdel = SecItemDelete(querydel)
       
       if statusdel != errSecSuccess {
           throw keychainError.Failed(statusdel)
       }

    }
    
    static func getMyId() -> String {
        let queryacc = [
            kSecAttrAccount : "myId",
            kSecClass:kSecClassGenericPassword,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
            
        ] as CFDictionary
        
        
        var itemacc: CFTypeRef?
        let statusacc = SecItemCopyMatching(queryacc , &itemacc)
        
        
        var myId = ""
        
        
        if statusacc == errSecSuccess , let passwordData = itemacc as? Data {
            let acc = String(decoding : passwordData , as :  UTF8.self)
                myId = acc
            print(myId)
        }
        
        
        return myId
    }
    
}




    


enum keychainError : Error {
    
    case Failed(OSStatus)
    
    
}

