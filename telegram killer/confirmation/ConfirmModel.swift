//
//  ConfirmModel.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//


struct confirmReq : Codable{
    let email : String
    let confirmationCode : String
}

nonisolated
struct tokens : Codable {
    let accessToken : String
    let refreshToken : String
}
