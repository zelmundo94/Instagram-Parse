//
//  LoginViewController.swift
//  Instagram
//
//  Created by Denzel Ketter on 3/2/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import Parse 


class LoginViewController: UIViewController {

    var user: ParseUser? 
    //User and Pass outlets
    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    
    @IBAction func onSignIn(sender: AnyObject) {
        
        self.user = ParseUser(username: usernameField.text!, password: passwordField.text!)
        self.user?.onLogin({ () -> () in
                
                print("Login Worked!")
                
                self.performSegueWithIdentifier("loginSegue", sender: nil)
            
            }, failureCallback:  { (error: NSError) -> () in
                
                self.alertPop("Error", message: "Unable to login! Please check your credentials.")
                print(error.localizedDescription)
        })
        
    }
    
    func alertPop(title: String, message: String){
        //alerts user with sign up error
        let alert = UIAlertController(title: title, message: message, preferredStyle:  UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBAction func onSignUp(sender: AnyObject) {
        
        let newUser = PFUser()
        
        newUser.username = usernameField.text
        
        newUser.password = passwordField.text
        
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                
                print("Created New User")
                
            }else{
                
                print(error?.localizedDescription)
            
                if error?.code == 202{
                    self.alertPop("User already exists", message: "Choose something else")
                    
                }
                
            }
        }
        
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
