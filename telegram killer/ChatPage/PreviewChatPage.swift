//
//  PreviewChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//

import UIKit



extension ChatPageVM {
    
    static func preview() -> ChatPageVM {
        
        let messages = Messages(messages: [MessageInfo(id: "1", chatId: "1", senderId: "1", content: "g", sentAt: "g")])
        let uschat = UsersChat(chatId: "1", participants: ["1", "1"], createdAt: "1")
        let vm = ChatPageVM(chatHub: chatHub(), router: router(navcontroller: UINavigationController()), messages: messages , usersChat: uschat  )
        vm.messages = [Message(message: "OMG I HAVE SMTH TO TELL", fromMe: true),
                       Message(message:"what" , fromMe:  false),
                       Message(message: "I am pregnant!" , fromMe:  true)]
        return vm

    }
}
