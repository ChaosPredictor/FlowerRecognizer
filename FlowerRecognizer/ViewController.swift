//
//  ViewController.swift
//  FlowerRecognizer
//
//  Created by Master on 24/09/2017.
//  Copyright © 2017 Master. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker = UIImagePickerController()
    
    @IBOutlet weak var mainImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        //imagePicker.sourceType = .camera //for real phone
        imagePicker.allowsEditing = true
        //imagePicker.allowsEditing = false

    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let userPickedImage = info[UIImagePickerControllerEditedImage] as? UIImage {
            mainImage.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Could not convert to CIImage")
            }
            //print("finish")

            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: FlowerClassifer().model) else {
            fatalError("Loading CoreML Model Failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Could not ... ")
            }
            
            //print(result)
            
            if let firstResult = result.first {
                //print(firstResult.identifier)
                self.navigationItem.title = firstResult.identifier
                //if firstResult.identifier.contains("hotdog") {
                //    self.navigationItem.title = "Hotdog"
                //} else {
                //    self.navigationItem.title = "NOT hotdog"
                //}
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        } catch {
            print(error)
            fatalError("Could not perform handler")
        }
    }
    
    
    @IBAction func cameraButton(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

