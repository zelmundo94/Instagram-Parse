//
//  ParseUser.swift
//  Instagram
//
//  Created by Denzel Ketter on 3/13/16.
//  Copyright © 2016 Denzel Ketter. All rights reserved.
//

import UIKit
import Parse 

class ParseUser: NSObject {
    
    var username: String?
    var password: String?
    
    //Initializer
    init(username: String, password: String){
        
        
        self.username = username ?? ""
        self.password = password ?? ""
    }
    
    //Login function
    func onLogin(successCallback: () -> (), failureCallback: (NSError) -> ()){
        
        let username = self.username ?? ""
        let password = self.password ?? ""
        
        PFUser.logInWithUsernameInBackground(username, password: password) { (user: PFUser?, error: NSError?) -> Void in
            if let error = error {
                failureCallback(error)
                
            } else {
                
                successCallback()
                
            }
            
      }

}


    //Signup function
    func signUp(successCallback: () -> (), failureCallback: (NSError) -> ()){
        
        //init user object
        let newUser = PFUser()
        
        //set user properties
        newUser.username = self.username
        newUser.password = self.password
        
        //call signup function
        newUser.signUpInBackgroundWithBlock {(success: Bool, error: NSError?) -> Void in
            if let error = error {
                failureCallback(error)
                
            } else {
                
                successCallback()
                
            }
        }
    }
}