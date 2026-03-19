//
//  MainPageView.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//


import SwiftUI

struct MainPageView : View {
    
    @StateObject var viewModel : MainPageVM
    
    @State var  isShaking  = false

    

    
    @State var email = ""
    init(viewModel : MainPageVM){
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        
        if viewModel.chats.isEmpty {
                    textSomeone
        } else {
            textSomeoneField
            ScrollView {
                LazyVStack {
             
                    ForEach(viewModel.chats) { chat in
                        VStack(alignment: .leading){
                       
                            HStack{
                                
                                Circle()
                                    .fill(.gray)
                                    .frame(width: 60, height: 60)
                                   
                                    .opacity(0.5)
                                VStack(alignment: .leading) {
                                    
                                    HStack{
                                       
                                            Text(chat.email)
                                                .bold()
                                                .frame(alignment: .leading)
                                           
                                        
                                      
                                       
                                    }
                                    .padding(.horizontal, 10)
                                    .padding(.vertical )
                                
                        
                                    HStack{
                                        Text(chat.lastMessage)
                                       
                                    }
                                    .padding(.horizontal, 10)

                            }
              
                     
                            }
                
                            
                    
                         
                            Divider()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                        
                            Task{
                                await goToChat(email: chat.email)
                            }
                        }
                      
                        
                      
                        
                    }
                }
             
            }
        }
        
    }
}

extension MainPageView {
    
    
    func goToChat(email : String ) async {
        do {
         
         try await   viewModel.createChat(email: email)
  
            self.email = ""
        } catch ErrorChat.BadRequest{
           
            
             
                withAnimation(.spring(response: 0.2, dampingFraction: 0.2).repeatCount(5,autoreverses: true)){
                    isShaking = true
                } completion: {
                    isShaking = false
                }
            
        } catch {
            print(error.localizedDescription)
        }
    }
    
    var findEmail : some View{
        
        Button(action: {
            Task {
                await goToChat(email: email)
            }
        }, label: {
            Text(Image(systemName: "magnifyingglass"))
                .padding()
                .glassEffect()
                .clipShape(.circle)
        })
    }
    
    var textSomeoneField : some View {
        
        HStack{
            TextField("Write email", text: $email)
                .frame(height: 50)
                .background(.white)
                .clipShape(.capsule)
                .offset(x: isShaking ? -10 : 0 )
               
                .padding()
            
            findEmail
                .padding()
        }

    }
    
    
    var textSomeone : some View {
        VStack{
            Text("Text someone")
                .font(.headline)
                .padding()
            
                textSomeoneField
        }
        .background(.gray.opacity(0.2))
        
        .cornerRadius(30)
        
        .frame(width: 300,height: 250)
    
    }
}




#Preview {
    
    let mock = MockLocalDataSource()
    
    mock.mockChats = [
        DestinationChats(email: "BOB", lastMessage: "HELLO", sentAt: "11-08"),
        DestinationChats(email: "BOBA", lastMessage: "Bye", sentAt: "128")
    ]
    return MainPageView(viewModel: MainPageVM(routerChat: router(navcontroller: UINavigationController(), dataSource: mock),  with:  mock))
}
