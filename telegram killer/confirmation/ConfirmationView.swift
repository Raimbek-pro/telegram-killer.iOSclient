//
//  ConfirmationView.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import SwiftUI

struct ConfirmationView: View {
    
    @State var confcode = ""
    var body: some View {
       
        textconf
        
        
    }
    
    var textconf : some View {
        TextField("confirmation code ", text: $confcode)
        
            .textFieldStyle(.roundedBorder)
        
            .border(.blue)
            .padding(.horizontal , 30)
    }
    
    var buttonconf : some View {
        Button(action: {
            
        }, label: {
            Text("confirm")
        })
        
        .buttonStyle(.glassProminent)
        
        .padding(20)
        
    }
}

#Preview {
    ConfirmationView()
}
