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
        vm.messages = ["Hello", "How are you?", "Test message"]
        return vm

    }
}
