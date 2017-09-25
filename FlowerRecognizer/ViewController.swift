//
//  ViewController.swift
//  FlowerRecognizer
//
//  Created by Master on 24/09/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        print("button pressed")
    }
    
}

