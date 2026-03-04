//
//  auth.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel : authVM
    
    @State var textWarn = ""
    init(router :  router ){
        self._viewModel = StateObject(wrappedValue: authVM(router: router))
    }
   @State var email = ""
    var body: some View {
       textfield
        
       buttonSend
        
       textWarnView
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
                    textWarn = ""
                    viewModel.navigate()
                }
                catch{
                    print(error)
                    if error.localizedDescription == "409"{
                        UserDefaults().set(email, forKey: "email")
                    
                        try? await viewModel.sendLogEmail(email:  email)
                        textWarn = ""
                        viewModel.navigate()
                    }
                    else{
                        textWarn = "OOOOPS BRO/SIS \(error.localizedDescription)"
                    }
                   
                }
             
                
            }

            
           
        }, label: {
            Text("Get verification code")
        })
        
        .buttonStyle(.glassProminent)
        
        .padding(20)
    }
    
    var textWarnView : some View {
        
        
        Text(textWarn)
            .padding(10)
    }
}

