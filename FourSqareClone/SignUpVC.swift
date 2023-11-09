//
//  ViewController.swift
//  FourSqareClone
//
//  Created by Jinu on 08/11/23.
//

import UIKit
import ParseCore

class SignUpVC: UIViewController {
    @IBOutlet weak var userNameText: UITextField!
    
    @IBOutlet weak var passwordText: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }
    
    @objc func addButtonCLicked(){
        //segue
        performSegue(withIdentifier: "toPlaceVC", sender: nil)
    }

    @IBAction func signInClicked(_ sender: Any) {
       
        if userNameText.text  != "" && passwordText.text != ""{
            PFUser.logInWithUsername(inBackground: userNameText.text!, password: passwordText.text!) { user, error in
                if error != nil{
                    self.makeAlert(titleText: "Error!", messageText: error?.localizedDescription ?? "Error")
                }
                else{
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                   
                }
                    
            }
        }else{
            makeAlert(titleText: "Error!", messageText: "Username/Password?")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if userNameText.text  != "" && passwordText.text != ""{
            let user = PFUser()
            user.username = userNameText.text!
            user.password = passwordText.text!
            user.signUpInBackground { success, error in
                if error != nil{
                    self.makeAlert(titleText: "Error!", messageText: error?.localizedDescription ?? "Error" )
                }else{
                    
                    self.performSegue(withIdentifier: "toPlacesVC", sender: nil)

                }
            }
            
        }else{
             makeAlert(titleText: "Error!", messageText: "Username/password?")
        }
        
    }
    
    func makeAlert(titleText: String,messageText: String){
        let alert = UIAlertController(title: titleText, message: messageText, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okButton)
        self.present(alert, animated: true,completion: nil)
    }
    

}

