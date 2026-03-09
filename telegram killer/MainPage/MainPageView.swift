//
//  MainPageView.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.03.2026.
//


import SwiftUI

struct MainPageView : View {
    
    @StateObject var viewModel : MainPageVM
    
    
    @State var doesHaveChats : Bool = false
    
    @State var warn = ""
    
    @State var email = ""
    init(viewModel : MainPageVM){
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    var body: some View {
        
        if !doesHaveChats {
            
            VStack{
                Text("Text someone")
                    .font(.headline)
                    .padding()
                
                HStack{
                    TextField("Write email", text: $email)
                        .frame(height: 50)
                        .background(.white)
                       
                        .clipShape(.capsule)
                       
                        .padding()
                    
                    findEmail
                        .padding()
                }
               
            }
         
            
        
            
         
           
            .background(.gray.opacity(0.2))
            
            .cornerRadius(30)
            
            .frame(width: 300,height: 250)
        
      
           
            
            
        }
        
    }
}

extension MainPageView {
    
    var findEmail : some View{
        
        Button(action: {
            Task {
                do {
                 try await   viewModel.createChat(email: email)
                 
                    warn = ""
                } catch ErrorChat.NotFound{
              
                    warn = "Email not found "
                   
                }
                
            }
        }, label: {
            Text(Image(systemName: "magnifyingglass"))
                .padding()
                .glassEffect()
                .clipShape(.circle)
        })
    }
}

#Preview {
    MainPageView(viewModel: MainPageVM(routerChat: router(navcontroller: UINavigationController())))
}
