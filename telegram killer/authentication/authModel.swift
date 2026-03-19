//
//  authModel.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import Foundation

struct emailreq :Codable {
    let email: String
}

nonisolated
struct signUpResp : Codable {
  //  let userId : String
    let registeredAt : String?
    let message : String
}
