//
//  router.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import SwiftUI

final class router {
    
     let navcontroller : UINavigationController
    
    init(navcontroller: UINavigationController) {
        self.navcontroller = navcontroller
    }
    
    func movetoconf() {
        
        navcontroller.pushViewController(UIHostingController(rootView: ConfirmationView()), animated: true)

        
    }
    
    func movetomainPage() {
        navcontroller.pushViewController(UIHostingController(rootView: MainPage()), animated: true)
    }
    
}
