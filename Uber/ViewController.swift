//
//  ViewController.swift
//  Uber
//
//  Created by Robert Jackson Jr on 6/13/18.
//  Copyright © 2018 Robert Jackson Jr. All rights reserved.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    @IBOutlet var riderLabel: UILabel!
    @IBOutlet var driverLabel: UILabel!
    
    
    
    @IBOutlet var emailTextfield: UITextField!
    
    @IBOutlet var passwordTextfield: UITextField!
    @IBOutlet var riderDriverSwitch: UISwitch!
    
    @IBOutlet var topButton: UIButton!
    
    @IBOutlet var bottomButton: UIButton!
    
    @IBAction func topTapped(_ sender: Any) {
        if emailTextfield.text == "" || passwordTextfield.text == "" {
            displayAlert(title: "Missing Information", message: "You must provide both a email and password")
            
        } else {
            if let email = emailTextfield.text {
                if let password = passwordTextfield.text {
                  
            if signUpMode {
                //Sign Up
               
                Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        
                        if self.riderDriverSwitch.isOn {
                            //Driver
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Driver"
                            req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)

                        } else {
                            //Rider
                            let req = Auth.auth().currentUser?.createProfileChangeRequest()
                            req?.displayName = "Rider"
                            req?.commitChanges(completion: nil)
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)
                            

                        }
                        
                        
                    }
                })
                
            }else {
                // LOG IN
                Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                    if error != nil {
                        self.displayAlert(title: "Error", message: error!.localizedDescription)
                    } else {
                        
                        if user?.displayName == "Driver" {
                          //Driver
                            self.performSegue(withIdentifier: "driverSegue", sender: nil)

                    } else {
                            //Rider
                            self.performSegue(withIdentifier: "riderSegue", sender: nil)

                        }
                        
                        
                    }
                })
            }
        }
    }
}


}

func displayAlert(title:String, message:String){
    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
    self.present(alertController, animated: true, completion: nil)
    
    
}


@IBAction func bottomTapped(_ sender: Any) {
    if signUpMode {
        topButton.setTitle("Log In", for: .normal)
        bottomButton.setTitle("Switch to Sign Up", for: .normal)
        riderLabel.isHidden = true
        driverLabel.isHidden = true
        riderDriverSwitch.isHidden = true
        signUpMode = false
    } else {
        topButton.setTitle("Sign Up", for: .normal)
        bottomButton.setTitle("Switch to Log In", for: .normal)
        riderLabel.isHidden = false
        driverLabel.isHidden = false
        riderDriverSwitch.isHidden = false
        signUpMode = true
    }
    
    
    
}


var signUpMode = true

override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
}

override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
}


}

