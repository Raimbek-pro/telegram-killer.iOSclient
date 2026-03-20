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
    @State private var scrollPosition = ScrollPosition(idType: String.self)
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
            
          
                ZStack{
                    ScrollView{
                        LazyVStack{
                            chatScroll
                        }
                        .scrollTargetLayout()
                        .onChange(of: viewModel.messages ) {
                            if let me = viewModel.messages.last?.fromMe {
                                if me {
                                    withAnimation{
                                        scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                                    }
                                }
                                else {
                                    
                                

                                    if let dis = distanceFromBottom {
                                        print("dis \(dis)")
                                        if dis < 3 {
                                            withAnimation{
                                                scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                                            }

                                        }
                                        else {
                                            showScrollButton = true
                                        }

                                    }
                                    
                                    
                                    
                                }
                                
                            }
                        }.onChange(of: viewModel.isLoaded){
                            scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                        }
                    }.scrollPosition($scrollPosition)
                        .onChange(of: scrollPosition){ _ , newPos  in
                            let currentID = newPos.viewID(type: String.self)
                            
                            if currentID == viewModel.messages.last?.id{
                                showScrollButton = false
                            } else{
                                showScrollButton = true
                            }
                        }
                      
                    
                    VStack{
                        Spacer()
                        if showScrollButton {
                                scrollButton
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
                    self.message = ""
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
    var scrollButton : some View {
  
            
            Button(action: {
                
                scrollPosition.scrollTo(id: viewModel.messages.last?.id , anchor : .bottom)
                    showScrollButton = false
                
                

            }, label: {
                Image(systemName: "arrow.down")
                    .foregroundStyle(.gray)
                    .padding()
                    .glassEffect()
                    .clipShape(.circle)
            })
        
    }
    
    var distanceFromBottom : Int? {
        guard
        let currentID =  scrollPosition.viewID(type: String.self),
        let currentIndex = viewModel.messages.firstIndex(where: { $0.id == currentID}),
        let lastIndex = viewModel.messages.indices.last
            
        else {print("why")
            return nil }
        
        let rawDistance = lastIndex -  currentIndex
        let viewportSize = 10
        let adjusted = rawDistance - viewportSize
        return max(0,adjusted)
    }
    
   
 
}



#Preview {
    ChatPageView(ChatPageVM: ChatPageVM.preview())
}
