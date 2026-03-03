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
   
    init(router : router){
        self._viewmodel = StateObject(wrappedValue:
        ConfirmationVM(routerConf: router)
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
                    viewmodel.navigateMain()
                }
                catch{
                    print("not able ")
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
