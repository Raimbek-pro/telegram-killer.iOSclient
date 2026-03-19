//
//  MainPage.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import SwiftUI

struct ChatPageView: View {
    
  
    @StateObject var  viewModel : ChatPageVM
    @State var email = ""
    @State var message = ""
    @State var showScrollButton = false
    
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
            
            ScrollViewReader { scrollview in
                ZStack{
                    ScrollView{
                        LazyVStack{
                            chatScroll
                        }.onChange(of: viewModel.messages ) {
                            if let me = viewModel.messages.last?.fromMe {
                                if me {
                                    withAnimation{
                                        scrollview.scrollTo(viewModel.messages.last?.id , anchor : .bottom)
                                    }
                                }
                                else {
                                    
                                    showScrollButton = true
                                    
                                }
                                
                            }
                        }.onChange(of: viewModel.isLoaded){
                            scrollview.scrollTo(viewModel.messages.last?.id , anchor : .bottom)
                        }
                    }
                    
                    VStack{
                        Spacer()
                        if showScrollButton {
                            scrollButton(scrollview)
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


extension ChatPageView {
    

    var sendMessage : some View {
        
        Button(action: {
                Task{
                    await  viewModel.sendMessage(to: viewModel.usersChat.chatId, message: message)
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
  @ViewBuilder
    var chatScroll : some View {
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
                .id(mes.id)
                
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
                .id(mes.id)
                
                
            }
            
        }
    }
    func scrollButton(_ scrollViewProxy : ScrollViewProxy) -> some View {
  
            
            Button(action: {
                
                    scrollViewProxy.scrollTo(viewModel.messages.last?.id , anchor : .bottom)
                    showScrollButton = false
                
                

            }, label: {
                Image(systemName: "arrow.down")
                    .foregroundStyle(.gray)
                    .padding()
                    .glassEffect()
                    .clipShape(.circle)
            })
        
    }
 
}



#Preview {
    ChatPageView(ChatPageVM: ChatPageVM.preview())
}
