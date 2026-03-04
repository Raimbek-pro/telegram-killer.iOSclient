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
        
        navcontroller.pushViewController(UIHostingController(rootView: ConfirmationView(router: self)), animated: true)

        
    }
    
    func movetomainPage() {
 
        let   mainpage_Tab = UIHostingController(rootView: MainPage())
        
        let account_Tab = UIHostingController(rootView: LogOut(router: self))
        
        mainpage_Tab.tabBarItem = UITabBarItem(title: "Main page", image: UIImage(systemName: "chart.bar.doc.horizontal") , tag: 0)
        account_Tab.tabBarItem = UITabBarItem(title: "Log out", image: UIImage(systemName: "door.left.hand.open"), tag: 1)
        
        let tabbarview = UITabBarController()
        tabbarview.viewControllers = [mainpage_Tab, account_Tab]
    
        navcontroller.setViewControllers( [tabbarview ], animated: true)
 
    }
    
    
    func  movetoLogIn(){
        let authview = UIHostingController(rootView: AuthView(router: self) )
        navcontroller.setViewControllers([authview], animated: true)
    }
}
