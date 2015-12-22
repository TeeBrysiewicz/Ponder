//
//  PonderViewController.swift
//  Ponder
//
//  Created by Tobias Robert Brysiewicz on 12/18/15.
//  Copyright © 2015 Tobias Brysiewicz. All rights reserved.
//

import UIKit
import Parse
import ParseUI
import ParseFacebookUtilsV4

class PonderViewController: ViewController {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var infoLabel: UILabel!
    
    var displayUserId = ""
    
// ---------------------
// DRAG, RESET, SELECITON GESTURE
// ---------------------
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        let translation = gesture.translationInView(self.view)
        let label = gesture.view!
        
        // ANIMATION
        let xFromCenter = label.center.x - self.view.bounds.width / 2
        let scale = min(100 / abs(xFromCenter), 1)
        var rotation = CGAffineTransformMakeRotation(xFromCenter / 200)
        var stretch = CGAffineTransformScale(rotation, scale, scale)
        
        label.transform = stretch
        
        // DRAG
        label.center = CGPoint(x: self.view.bounds.width / 2 + translation.x, y: self.view.bounds.height / 2 + translation.y )
        
        if gesture.state == UIGestureRecognizerState.Ended {
            
            var acceptedOrRejected = ""
            
            //SELECTION
            if label.center.x < 100 {
                
                print("Ugly")
                acceptedOrRejected = "rejected"
                
            } else if label.center.x > self.view.bounds.width - 100 {
                
                print("Hot!")
                acceptedOrRejected = "accepted"
                
            }
            
            if acceptedOrRejected != "" {
                
                PFUser.currentUser()?.addUniqueObjectsFromArray([displayUserId], forKey: acceptedOrRejected)
                PFUser.currentUser()?.saveInBackground()
                
            }
            
            
            // RESET
            label.center = CGPoint(x: self.view.bounds.width / 2 , y: self.view.bounds.height / 2 )
            rotation = CGAffineTransformMakeRotation(0)
            stretch = CGAffineTransformScale(rotation, 1, 1)
            label.transform = stretch
            updateImage()
            
        }
    }

// ---------------------
// UPDATE IMAGE
// ---------------------
    func updateImage() {
        
        // -----------------------
        // ASSIGN CURRENT USER PREFERENCES
        // -----------------------
        var interestedIn = "male"
        if (PFUser.currentUser()!["interestedInWomen"])! as! Bool == true {
            interestedIn = "female"
        }
        
        
        var isFemale = true
        if (PFUser.currentUser()!["gender"])! as! String == "male" {
            isFemale = false
        }
        
        // ------------------
        // MATCH QUERY
        // ---------------------------------------------------
        var query = PFUser.query()
        query?.whereKey("gender", equalTo: interestedIn)
        query?.whereKey("interestedInWomen", equalTo: isFemale)
        
        // CHECK IF ALREADY BEEN ACCEPTED OR REJECTED
        var ignoredUsers = [""]
        
        if let acceptedUsers = PFUser.currentUser()?["accepted"] {
            ignoredUsers += acceptedUsers as! Array
        }
        if let rejectedUsers = PFUser.currentUser()?["rejected"] {
            ignoredUsers += rejectedUsers as! Array
        }
        
        query?.whereKey("objectId", notContainedIn: ignoredUsers)
        // ------------------------------------------------------
        
        query?.limit = 1
        
        query?.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) -> Void in
            
            if error != nil {
                print(error)
            } else if let objects = objects {
                
                for object in objects {
                    
                    self.displayUserId = object.objectId!
                    
                    let imageFile = object["image"] as! PFFile
                    
                    imageFile.getDataInBackgroundWithBlock({ (imageData: NSData?, error: NSError?) -> Void in
                        
                        if error != nil {
                            print(error)
                        } else {
                            if let data = imageData {
                                self.userImage.image = UIImage(data: data)
                            }
                        }
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        userImage.addGestureRecognizer(gesture)
        userImage.userInteractionEnabled = true
        
        updateImage()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "logout" {
            
            PFUser.logOut()
            
        }
    }


}
