//
//  ConfirmationView.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import SwiftUI

struct ConfirmationView: View {
    @StateObject var viewmodel : ConfirmationVM
    @State var confcode = ""
   
    @State var textWarn = ""
    
    init(viewmodel : ConfirmationVM ){
        self._viewmodel = StateObject(wrappedValue:
       viewmodel
        )
    }
    var body: some View {
       
        textconf
        
        buttonconf
        
    }
    
    var textconf : some View {
        TextField("confirmation code ", text: $confcode)
        
            .textFieldStyle(.roundedBorder)
        
            .border(.blue)
            .padding(.horizontal , 30)
    }
    
    var buttonconf : some View {
        Button(action: {
            Task{
                guard let email = UserDefaults().string(forKey: "email") else {return}
                do{
                 try    await viewmodel.sendCode(email: email  , confCode: confcode)
                    try await viewmodel.writeId()
                    viewmodel.navigateMain()
                }
                catch{
                    print(error)
                    textWarn = ("whoah whoah \(error.localizedDescription)")
                }
               
            }
            
        }, label: {
            Text("confirm")
        })
        
        .buttonStyle(.glassProminent)
        
        .padding(20)
        
    }
}

//#Preview {
//    ConfirmationView()
//}
