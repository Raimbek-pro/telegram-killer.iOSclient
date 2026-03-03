//
//  auth.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import SwiftUI

struct Auth: View {
    
    @StateObject var viewModel : authVM
    
    init(router :  router ){
        self._viewModel = StateObject(wrappedValue: authVM(router: router))
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

            Task{
                print("sending email")
                do{
                   try await viewModel.sendemail(email: email)
                    UserDefaults().set(email, forKey: "email")
                    viewModel.navigate()
                }
                catch{
                    print("error")
                }
             
                
            }

            
           
        }, label: {
            Text("Get verification code")
        })
        
        .buttonStyle(.glassProminent)
        
        .padding(20)
    }
}

