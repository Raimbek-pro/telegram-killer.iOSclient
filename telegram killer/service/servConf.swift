//
//  servConf.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 08.03.2026.
//


import Foundation

enum servConf : String {
    
    case server = "http://localhost:8080"
    
    
    static var baseURL  : String{
        servConf.server.rawValue
    }
    
}


enum codeError : Error {
    
    case conflict
    case internalServer
    case unauthorized
    case badRequest
    case notFound
    case unknown(Int)
}

enum  endpointConf {
    
    static func confReq(codable : Codable?  = nil , endpoint : URL , accessToken : String? = nil , httpMethod : String? = "POST" )  async   throws -> (Data, Int) {
        
        var request = URLRequest(url: endpoint)
        if let codable = codable {
            guard let body = try? JSONEncoder().encode(codable) else{ throw   codeError.badRequest}
            request.httpBody = body
        }
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
       
        request.httpMethod = httpMethod
    
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
