//
//  router.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 01.03.2026.
//

import Foundation

import SwiftUI
import SwiftData

final class router {
    
     let navcontroller : UINavigationController
    let dataSource : ChatDataSourceProtocol
    init(navcontroller: UINavigationController ,dataSource : ChatDataSourceProtocol) {
        self.navcontroller = navcontroller
        self.dataSource = dataSource
        
        
    }
    
    func movetoconf() {
        
        navcontroller.pushViewController(UIHostingController(rootView: ConfirmationView(viewmodel: ConfirmationVM(routerConf: self, authserv: authService()))), animated: true)

        
    }
    
    func movetomainPage() {
        let vm = MainPageVM(routerChat: self,  with: dataSource)
        let   mainpage_Tab = MainPageHostingController(rootView: MainPageView(viewModel: vm ))
        mainpage_Tab.onAppear  = {
            vm.fetchChats()
        }
        
        let account_Tab = UIHostingController(rootView: LogOut(logOutVM: LogOutVM(router: self, dataSource: dataSource)))
        
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
    
    func movetoChat(messages : Messages , usersChat : UsersChat , myId : String ,email : String ) {
        let vm = ChatPageVM(chatHub: chatHub(), router: self, messages: messages , usersChat: usersChat, myId: myId, usersEmail: email, with: dataSource )
        navcontroller.pushViewController(UIHostingController(rootView: ChatPage(ChatPageVM : vm )), animated: true)
    }
}
