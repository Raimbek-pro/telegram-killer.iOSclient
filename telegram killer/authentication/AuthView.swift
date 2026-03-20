//
//  auth.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import SwiftUI

struct AuthView: View {
    
    @StateObject var viewModel : authVM
    @State var isLost  = false
    @State var isLoading = false
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
                isLoading = true
                defer { isLoading = false }
                print("sending email")
                do{
                   
                    try await viewModel.sendemail(email: email)
                    UserDefaults().set(email, forKey: "email")
                    textWarn = ""
                    
                    viewModel.navigate()
                }
                catch codeError.conflict{
                 
                    UserDefaults().set(email, forKey: "email")
                    
                    try? await viewModel.sendLogEmail(email:  email)
                    textWarn = ""
                    viewModel.navigate()
                    
                } catch codeError.internalServer {
               
                    textWarn = "Problems with server"
                } catch codeError.badRequest {
                    textWarn = "Wrong input"
                } catch {
                    print("catch error: \(error)")
                    isLost = true
                }
                
                
            }
        
                
            

            
           
        }, label: {
            if !isLoading{
                Text("Get verification code")
            }
            else {
                    ProgressView()
            }
            
        })
        .disabled(isLoading)
        .buttonStyle(.glassProminent)
        
        .padding(20)
        .alert("Error", isPresented: $isLost) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Could not connect to the server")
            }
    }
    
    var textWarnView : some View {
        
        
        Text(textWarn)
            .padding(10)
    }
    
  
}

