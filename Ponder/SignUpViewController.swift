//
//  SignUpViewController.swift
//  Ponder
//
//  Created by Tobias Robert Brysiewicz on 12/21/15.
//  Copyright © 2015 Tobias Brysiewicz. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4


class SignUpViewController: ViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var interestedInWomen: UISwitch!
    
// ----------------
// SAVE GENDER PREFERENCE TO PARSE
// ----------------
    @IBAction func signUp(sender: AnyObject) {
        
        PFUser.currentUser()?["interestedInWomen"] = interestedInWomen.on
        PFUser.currentUser()?.saveInBackground()
        
        dispatch_async(dispatch_get_main_queue()) {
            
            self.performSegueWithIdentifier("ponder", sender: self)
            
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
// ----------------
// TEST DATA
// ----------------
        
//        let urlArray = ["http://data.whicdn.com/images/77881747/large.jpg", "http://cdn.unilad.co.uk/wp-content/uploads/2015/09/Instagram_model1.png", "http://www.chareemag.com/wp-content/uploads/2015/03/fit-girls-on-instagram.jpg", "http://slim.top.me/wp-content/uploads/2014/09/Michelle-Lewin.png", "http://cdn2-www.craveonline.com/assets/uploads/gallery/hottest-girls-of-instagram-emily-ratajkowski/screenshot-2014-11-03-at-15-01-47.png"]
//        
//        var counter = 1
//        
//        for url in urlArray {
//            
//            let nsUrl = NSURL(string: url)!
//            
//            if let data = NSData(contentsOfURL: nsUrl) {
//                
//                self.userImage.image = UIImage(data: data)
//                
//                let imageFile: PFFile = PFFile(data: data)!
//                
//                let user:PFUser = PFUser()
//                var username = "user\(counter)"
//                
//                user.username = username
//                user.password = "password"
//                user["image"] = imageFile
//                user["interestedInWomen"] = false
//                user["gender"] = "female"
//                
//                counter++
//                user.signUpInBackground()
//                
//            }
//        }
        
        
// ----------------
// GRAPH REQUEST DATA
// ----------------
        let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, gender, email"])
        graphRequest.startWithCompletionHandler( { (connection, result, error) -> Void in
            
            if error != nil {
                
                print(error)
                
            } else if let result = result {
                
                print(result)
                
                // SAVE FB PARAMETERS TO PARSE
                PFUser.currentUser()?["gender"] = result["gender"]
                PFUser.currentUser()?["name"] = result["name"]
                PFUser.currentUser()?["email"] = result["email"]

                
                PFUser.currentUser()?.saveInBackground()
                
                // GET AND SAVE FB PROFILE PICTURE TO PARSE
                let userId = result["id"] as! String
                let facebookProfilePictureUrl = "https://graph.facebook.com/" + userId + "/picture?type=large"
                
                if let fbpicUrl = NSURL(string: facebookProfilePictureUrl) {
                    
                    if let data = NSData(contentsOfURL: fbpicUrl) {
                        
                        self.userImage.image = UIImage(data: data)
                        
                        let imageFile: PFFile = PFFile(data: data)!
                        PFUser.currentUser()?["image"] = imageFile
                        PFUser.currentUser()?.saveInBackground()
                    }
                }
            }
        })
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
