//
//  authVM.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 02.03.2026.
//

import Foundation
import Combine

class authVM : ObservableObject {
    
    func sendemail(email : String) async  -> Bool {
      return await authService().sendEmail(email)
    }
}
