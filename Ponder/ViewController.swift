//
//  ViewController.swift
//  Ponder
//
//  Created by Tobias Robert Brysiewicz on 12/18/15.
//  Copyright © 2015 Tobias Brysiewicz. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class ViewController: UIViewController {
    
    var signupActive = true
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var registerText: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var fbLoginButton: UIButton!
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
// ----------------------
// ALERT FUNCTION
// ----------------------

    @available(iOS 8.0, *)
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        let okAction = UIAlertAction(title: "Ok", style: .Default, handler: { (action) -> Void in
            print("Ok")
        })
        alert.addAction(okAction)
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
// ----------------------
// ACTIVITY FUNCTION
// ----------------------
    
    func activityStart() {
        activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.sharedApplication().beginIgnoringInteractionEvents()
    }
    
// ----------------------
// ACTIVITY FUNCTION
// ----------------------
    func activityStop() {
        self.activityIndicator.stopAnimating()
        UIApplication.sharedApplication().endIgnoringInteractionEvents()
    }
    
// ----------------------
// PONDER SIGNUP FUNCTION
// ----------------------
    
    @available(iOS 8.0, *)
    @IBAction func signup(sender: AnyObject) {
        
        if username.text == "" || password.text == "" {
            
            displayAlert("Error", message: "Invalid username or password")
            
        } else {
            
            activityStart()
            
            var errorMessage = "Please try again later."
            
            if signupActive == true {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text

                user.signUpInBackgroundWithBlock({ (success, error) -> Void in
                    
                    self.activityStop()
                    
                    if error == nil {
                        
                        // Signup Successful
                        self.performSegueWithIdentifier("signup", sender: self)
                        
                    } else {
                        
                        // Signup Failure
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Signup", message: errorMessage)
                        
                    }
                })
                
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password: password.text!, block: { ( user, error ) -> Void in
                    
                    self.activityStop()

                    if user != nil {
                        
                        // Logged In!
                        self.performSegueWithIdentifier("login", sender: self)
                        
                    } else {
                        
                        // Login Failure
                        if let errorString = error!.userInfo["error"] as? String {
                            errorMessage = errorString
                        }
                        
                        self.displayAlert("Failed Login", message: errorMessage)
                    }
                })
            }
        }
    }
    
// ----------------
// FACEBOOK LOGIN
// ----------------
    
    @available(iOS 8.0, *)
    @IBAction func loginWithFacebook(sender: AnyObject) {
        
        PFFacebookUtils.logInInBackgroundWithReadPermissions(["public_profile"], block: { (user: PFUser?, error: NSError?) -> Void in
            
            if(error != nil) {
                self.displayAlert("Error", message: (error?.localizedDescription)!)
                return
            } else {
                
                self.activityStart()
                
                if let user = user {
                    if user.isNew {
                        
                        self.activityStop()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("signup", sender: self)
                            
                        }
                    } else {
                        
                        self.activityStop()
                        
                        dispatch_async(dispatch_get_main_queue()) {
                            
                            self.performSegueWithIdentifier("login", sender: self)
                            
                        }
                        
                    }
                }
            }
        })
    }
    
    
    @IBAction func login(sender: AnyObject) {
        
        if signupActive == true {
            
            signupButton.setTitle("Log in with Whomi", forState: UIControlState.Normal)
            registerText.text = "Not Registered?"
            loginButton.setTitle("Sign Up", forState: UIControlState.Normal)
            fbLoginButton.setTitle("Log in with Facebook", forState: UIControlState.Normal)
            signupActive = false
            
        } else {
            
            signupButton.setTitle("Sign up with Whomi", forState: UIControlState.Normal)
            registerText.text = "Already Registered?"
            loginButton.setTitle("Login", forState: UIControlState.Normal)
            fbLoginButton.setTitle("Sign up with Facebook", forState: UIControlState.Normal)
            signupActive = true
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.signupButton.layer.cornerRadius = 5
//        self.loginButton.layer.cornerRadius = 5
//        self.fbLoginButton.layer.cornerRadius = 5

        let push = PFPush()
        push.setChannel("Giants")
        push.setMessage("The Giants just scored!")
        push.sendPushInBackground()
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
    }
    

    

    
}
