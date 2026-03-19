//
//  MainPageVC.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 19.03.2026.
//

import SwiftUI

class MainPageHostingController : UIHostingController<MainPageView> {
    var onAppear :(() -> Void)?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        onAppear?()
    }
}
