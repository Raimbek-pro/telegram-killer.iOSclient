//
//  PreviewChatPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//

import UIKit



extension ChatPageVM {
    
    static func preview() -> ChatPageVM {
        
        let messages = Messages(chatId: "1", messages: [MessageInfo(id: "1", chatId: "1", senderId: "1", content: "g", sentAt: "g")] , lastReadMessageId: "1") 
        let uschat = UsersChat(chatId: "1", participants: ["1", "1"], createdAt: "1")
        let vm = ChatPageVM(chatHub: chatHub(), router: router(navcontroller: UINavigationController(), dataSource: MockLocalDataSource()), messages: messages , usersChat: uschat, myId: "1", usersEmail: "chubby face", with: MockLocalDataSource()  )
        vm.messages = [Message(id: "1", message: "OMG I HAVE SMTH TO TELL", fromMe: true, sentAt: "2026-03-20T19:00:52.5943673+00:00"),
                       Message(id: "2", message:"what???????????" , fromMe:  false, sentAt: "2026-03-20T19:00:52.5943673+00:00"),
                       Message(id: "3", message: "I am pregnant!" , fromMe:  true, sentAt: "2026-03-20T19:00:52.5943673+00:00")]
        return vm

    }
}
