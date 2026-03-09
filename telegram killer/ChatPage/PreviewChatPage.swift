//
//  PreviewChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//

import UIKit



extension ChatPageVM {
    
    static func preview() -> ChatPageVM {
        
        let vm = ChatPageVM(chatHub: chatHub(), router: router(navcontroller: UINavigationController()) )
        vm.messages = [Message(message: "OMG I HAVE SMTH TO TELL", fromMe: true),
                       Message(message:"what" , fromMe:  false),
                       Message(message: "I am pregnant!" , fromMe:  true)]
        return vm

    }
}
