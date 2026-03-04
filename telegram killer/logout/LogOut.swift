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
    init(router : router){
       
        self._viewmodel = StateObject(wrappedValue: LogOutVM(router: router) )
    }
    var body: some View {
        logout
       
        textWarnView
        
    }
    
    var logout : some View {
        Button("log out", action: {
            Task{
                do {
                    try await viewmodel.sendLogout()
                    textWarn = ""
                    viewmodel.moveToLogIn()
                }
                catch{
                    textWarn = ("oops , \(error.localizedDescription)")
                }
                            }
            
        })
    }
    
    var textWarnView : some View {
        Text(textWarn)
    }
}


