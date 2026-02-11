//
//  AuthorizeViewController.swift
//  telegram killer
//
//  Created by Райымбек Омаров on 04.02.2026.
//

import UIKit

class AuthorizeViewController: UIViewController {
    //
  
    let textField = UITextField()
    let  signupButton = UIButton(type: .system)
    
    
   
    
    var userId = ""
    override func viewDidLoad() {
       
        UserDefaults.standard.set("http://localhost:8080", forKey: "server")
        
       view.backgroundColor = .systemBackground
        super.viewDidLoad()
        print("gdg")
        addTextField()
        addButton()
            
        
       
      
    }
    
    func addTextField(){
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "your email"
        textField.borderStyle = .roundedRect
        view.addSubview(textField)
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.centerYAnchor),
            
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor,constant: 20),
            
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor,constant: -20)
        ])
        
        
    }
    
    func addButton(){
        signupButton.translatesAutoresizingMaskIntoConstraints = false
        signupButton.setTitle("Sign Up", for: .normal)
        view.addSubview(signupButton)
        NSLayoutConstraint.activate([
            signupButton.topAnchor.constraint(equalTo: textField.bottomAnchor),
            signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
          
            signupButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.2)
            ])
        
        signupButton.addTarget(self, action: #selector(self.sendEmail), for: .touchUpInside)
        
    }
   @objc func sendEmail(){
       guard let email = self.textField.text else {return}
       
       guard let serv = UserDefaults.standard.string(forKey: "server") else {return}
       
       let endpoint = URL(string: "\(serv)/api/account/signup" )
       var request = URLRequest(url: endpoint!)
       let emailreq = emailreq(email:email )
       guard let body = try? JSONEncoder().encode(emailreq) else{ return}
       request.setValue("application/json", forHTTPHeaderField: "Content-type")
      
       request.httpMethod = "POST"
       
       let task = URLSession.shared.uploadTask(with: request, from: body){ (data, response, error) in
           if let error = error {
               print("\(error)")
               return
           }
           guard let data = data else {return}
           let decoder = JSONDecoder()
           guard let response  = response as? HTTPURLResponse else {return}
           do{
               if  response.statusCode == 200 {
                   let resp =   try decoder.decode(signUpResp.self, from: data)
                   
             //      self.userId = resp.userId
                   DispatchQueue.main.async{
                       self.navigationController?.pushViewController(ConfirmationViewController(email), animated: true)
                   }
                  
                   
                   
                   print("registeredAt: \(resp.registeredAt)")
                   print("message: \(resp.message)")
                   
                   
                   return
               }
               else{
                   print("error \(response.statusCode)")
               }
           }catch{
               print(error)
           }
       }
           task.resume()
       
       print("Sending email to \(email)")
       
    }


}

struct emailreq :Codable {
    let email: String
}

nonisolated
struct signUpResp : Codable {
  //  let userId : String
    let registeredAt : String
    let message : String
}
