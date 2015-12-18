//
//  PonderViewController.swift
//  Ponder
//
//  Created by Tobias Robert Brysiewicz on 12/18/15.
//  Copyright © 2015 Tobias Brysiewicz. All rights reserved.
//

import UIKit

class PonderViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let label = UILabel(frame: CGRectMake(self.view.bounds.width / 2 - 100, self.view.bounds.height / 2 - 50, 200, 100))
        label.text = "Drag Me"
        label.textAlignment = NSTextAlignment.Center
        self.view.addSubview(label)
    
        let gesture = UIPanGestureRecognizer(target: self, action: Selector("wasDragged:"))
        label.addGestureRecognizer(gesture)
        
        label.userInteractionEnabled = true
        
    }
    
    
    func wasDragged(gesture: UIPanGestureRecognizer) {
        
        print("was dragged")
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
