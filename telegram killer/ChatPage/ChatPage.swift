//
//  MainPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import SwiftUI

struct ChatPage: View {
    
    
    @StateObject var  viewModel : ChatPageVM
    @State var email = ""
    @State var message = ""
    
    init(router :  router , chathub : chatHub ){
        self._viewModel = StateObject(wrappedValue: ChatPageVM(chatHub:  chathub , router: router))
    }
    
    var body: some View {
        
        
        VStack{
            HStack{
                TextField("Send to email", text: $email)
            }
            .padding(30)
            ScrollView{
                LazyVStack{
                    ForEach(1...100, id : \.self){ num in
                        Text(String(num))
                    }
                }
            }
            HStack{
                
              TextField("send message", text: $message)
                    .frame(height: 40)
                    .glassEffect()
                    .padding(20)
                   
                sendMessage
                    
            }
            
            
            
        }
        .task {
        
                 await viewModel.startConnection()
        }

    }
    
    

        
}


extension ChatPage {
    
    var sendMessage : some View {
        
        Button(action: {
            Task{
                    await  viewModel.sendMessage(to: email, message: message)
            
                
            }
          
        }, label: {
            Text(Image(systemName: "paperplane"))
                .padding()
                .glassEffect()
                .clipShape(.circle)
               
                
            
        })
        
        
        
        
        
      
    }
}
