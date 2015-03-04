//
//  QRImage.swift
//  Scanner
//
//  Created by Anil on 04/03/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import Social
import MobileCoreServices

class QRImage: UIViewController {
    
    var userTextString : String?
    @IBOutlet weak var QRCodeImage: UIImageView!
    @IBOutlet weak var userText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Share", style: UIBarButtonItemStyle.Bordered, target: self, action: "ShareIt")
        self.userText.text = self.userTextString
        var qrText = self.userTextString
        CGSize(width: 300, height: 300)
        self.QRCodeImage.image = {
            var qrCode = QRCode("\(qrText)")!
            qrCode.size = self.QRCodeImage.bounds.size
            return qrCode.image
            }()
    }
    
    func ShareIt(){
        
        var activityIteams : [AnyObject]?
        
        if QRCodeImage.image != nil{
            activityIteams = [userText.text as String!, QRCodeImage.image!]
        }else{
            activityIteams = [userText.text as String!]
        }
        let activityController = UIActivityViewController(activityItems: activityIteams!, applicationActivities: nil)
        self.presentViewController(activityController, animated: true, completion: nil)
        
    }
}
