//
//  ConfirmationViewController.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 09.02.2026.
//

import UIKit

class ConfirmationViewController: UIViewController {
    var email:String
    
    let ConfirmationField = UITextField()
    
    let ConfButton = UIButton(type: .system)
    
    init(_ email :String){
       
        self.email = email
        super.init(nibName: nil, bundle: nil)
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("Not storyboard based")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = .systemBackground
        super.viewDidLoad()
        addConfirmationField()
        addButton()
    }
    
    func addConfirmationField(){
        
        
        ConfirmationField.translatesAutoresizingMaskIntoConstraints = false
        ConfirmationField.placeholder = "confirmation code"
        
        ConfirmationField.borderStyle = .roundedRect
        
        view.addSubview(ConfirmationField)
        
        NSLayoutConstraint.activate([
            ConfirmationField.topAnchor.constraint(equalTo: view.centerYAnchor),
            ConfirmationField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            ConfirmationField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
            ])
    }
    
    
    func addButton(){
        ConfButton.setTitle("Confirm", for: .normal)
        ConfButton.addTarget(self, action: #selector(confirm), for: .touchUpInside)
        view.addSubview(ConfButton)
        ConfButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            ConfButton.topAnchor.constraint(equalTo: ConfirmationField.bottomAnchor),
            ConfButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          
            ConfButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        
    }
    
    
    @objc func confirm(){
        confirmRequest()
    }
    
    
    func confirmRequest(){
        guard let serv = UserDefaults.standard.string(forKey: "server") else {return}
        var request = URLRequest(url: URL(string: "\(serv)/api/account/email/confirm")!)
        request.setValue("application/json", forHTTPHeaderField: "Content-type")
        request.httpMethod =  "POST"
        let confreq = confirmReq(email: self.email, confirmationCode: ConfirmationField.text ?? "")
        
       guard let body = try? JSONEncoder().encode(confreq) else {return}
        
        let task = URLSession.shared.uploadTask(with: request, from: body){ data , response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else {return}
             
            
            guard let response =  response as? HTTPURLResponse else {return}
            if response.statusCode == 200 {
                UserDefaults.standard.set(1, forKey: "isAuthorized")
                
                guard  let tokens = try? JSONDecoder().decode(tokens.self, from: data) else {return}
                
                // refresh token in keychain
                let queryrefresh  = [kSecValueData :tokens.refreshToken.data(using: .utf8) as Any,
                                        kSecAttrAccount : "refreshToken",
                                          kSecClass:kSecClassGenericPassword
                                     
                ]   as CFDictionary
                
                let statusref = SecItemAdd(queryrefresh , nil)
                
                print(statusref)
                
                //access token in keychain
                
                let queryaccess = [     kSecValueData :tokens.accessToken.data(using: .utf8) as Any,
                                        kSecAttrAccount : "accessToken",
                                        kSecClass:kSecClassGenericPassword

                                   
                ]   as CFDictionary
                
                let statusacc = SecItemAdd(queryaccess , nil)
                
                print(statusacc)
                DispatchQueue.main.async {
                    self.navigationController?.pushViewController(ViewController(), animated:true)
                }
                
            }else{
                print("error \(response.statusCode)")
            }
        }
        task.resume()
        
    }


    
    

}

struct confirmReq : Codable{
    let email : String
    let confirmationCode : String
}

nonisolated
struct tokens : Codable {
    let accessToken : String
    let refreshToken : String
}
