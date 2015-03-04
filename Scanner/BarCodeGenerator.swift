//
//  BarCodeGenerator.swift
//  Scanner
//
//  Created by Anil on 04/03/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit

class BarCodeGenerator: UIViewController {

    @IBOutlet weak var userText: UITextView!
    @IBOutlet weak var infoLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue?, sender: AnyObject?) {
        
        if segue!.identifier == "Bar" {
            if self.userText.text != ""{
                let ImageviewController : BarImage = segue!.destinationViewController as BarImage
                ImageviewController.userTextString = self.userText.text
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject?) -> Bool {
        
        if identifier == "Bar" {
            if self.userText.text != ""{
                
                return true
            }
        }
        self.infoLabel.text = "Enter Data First"
        return false
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        
        self.view.endEditing(true)
    }

}
