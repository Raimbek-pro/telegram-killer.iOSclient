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


    init(ChatPageVM : ChatPageVM ){
        self._viewModel = StateObject(wrappedValue: ChatPageVM)
    }
    
    var body: some View {
        
        
        VStack{
            VStack{
                
                HStack{
                    Text(viewModel.usersEmail)
                        .clipShape(.capsule)
                        .glassEffect()
                }
            }
            
         
            ScrollView{
                LazyVStack{
                    ForEach(viewModel.messages ){ mes in
                        if mes.fromMe {
                            HStack{
                                Spacer()
                                Text(mes.message)
                                    .frame(minWidth: 20,  alignment: .leading)
                                
                                    .padding()
                                    .background(.cyan)
                                    .clipShape(.capsule)
                                
                            }
                         
                        }
                        else {
                            HStack{
                                Text(mes.message)
                                    .frame(minWidth: 20, alignment: .leading)
                                    .padding(20)
                                    .background(.green)
                                    .clipShape(.capsule)
                                Spacer()
                            }
                            
                                
                        }
                            
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
                    
                    await  viewModel.sendMessage(to: viewModel.usersChat.chatId, message: message)
                    
//                    viewModel.messages.append(Message(id: UUID().uuidString, message: message, fromMe: true))
                    
              
                }

            
          
        }, label: {
             Image(systemName: "paperplane")
            

                .foregroundStyle(.white)
                .padding()
                .background(.blue )
                .glassEffect()
                .clipShape(.circle)
               
                
            
        })
        
        
        
        
        
      
    }
}

#Preview {
    ChatPage(ChatPageVM: ChatPageVM.preview())
}
