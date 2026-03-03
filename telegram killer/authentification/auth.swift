//
//  auth.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import SwiftUI

struct Auth: View {
    
   @StateObject var viewModel = authVM()
    
    init(uinav : UINavigationController){
    
    }
   @State var email = ""
    var body: some View {
       textfield
        
        buttonSend
        
        
    }
    
    var textfield : some View {
        TextField("Email", text: $email)
            
            .textFieldStyle(.roundedBorder)
        
            .border(.blue)
            .padding(.horizontal , 30)
    }
    
    var buttonSend : some View {
        
        Button(action: {
            var conf = false
            Task{
                conf =   await viewModel.sendemail(email: email)
                
                
            }
            if conf{
               // router().movetoconf()
//                router(navcontroller: self.navigatio)
            }
            
            
           
        }, label: {
            Text("Get verification code")
        })
        
        .buttonStyle(.glassProminent)
        
        .padding(20)
    }
}

#Preview {
    Auth()
}
