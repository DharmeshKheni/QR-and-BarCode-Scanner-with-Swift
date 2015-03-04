//
//  BarImage.swift
//  Scanner
//
//  Created by Anil on 04/03/15.
//  Copyright (c) 2015 Variya Soft Solutions. All rights reserved.
//

import UIKit
import AVFoundation
import RSBarcodes

class BarImage: UIViewController {

    @IBOutlet weak var userText: UILabel!
    var userTextString : String?
    @IBOutlet var barcodeView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.userText.text = self.userTextString
        let gen = RSUnifiedCodeGenerator.shared
        gen.fillColor = UIColor.blackColor()
        gen.strokeColor = UIColor.whiteColor()
        var image: UIImage? = gen.generateCode(self.userTextString!, machineReadableCodeObjectType: AVMetadataObjectTypeCode128Code)
        if let i = image {
            self.barcodeView.image = RSAbstractCodeGenerator.resizeImage(i, scale: 3.0)
        }
    }
}
