//
//  LogOut.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 04.03.2026.
//

import SwiftUI

struct LogOut: View {
    
    @StateObject var viewmodel : LogOutVM
    @State var textWarn = ""
    init(logOutVM : LogOutVM){
       
        self._viewmodel = StateObject(wrappedValue: logOutVM )
    }
    var body: some View {
        logout
       
        textWarnView
        
    }
    
    var logout : some View {
        Button("log out", action: {
            Task {
                
                 await viewmodel.sendLogout()
                
            }
                
                            
            
        })
    }
    
    var textWarnView : some View {
        Text(textWarn)
    }
}


