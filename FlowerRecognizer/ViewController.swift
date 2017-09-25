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
import Alamofire
import SwiftyJSON


class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var textBox: UITextView!
    @IBOutlet weak var mainImage: UIImageView!
    
    let imagePicker = UIImagePickerController()
    let WIKIPEDIA_URL = "https://en.wikipedia.org/w/api.php"

    
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
                self.navigationItem.title = firstResult.identifier.capitalized
                
                
                let params : [String : String] = ["format" : "json", "action" : "query", "prop" : "extracts", "exintro" : "", "explaintext" : "", "titles" : firstResult.identifier.capitalized, "indexpageids" : "", "redirects" : "1"]
                
                self.getWikipediaData(url : self.WIKIPEDIA_URL, parameters : params)

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
    
    func getWikipediaData(url : String, parameters : [String: String]) {
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON {
            (responce) in
            if responce.result.isSuccess {
                let wikipediaResult : JSON = JSON(responce.result.value!)

                let pageid = wikipediaResult["query"]["pageids"][0].intValue
                let text = wikipediaResult["query"]["pages"]["\(pageid)"]["extract"]

                self.textBox.text = "\(text)"

                print(text)

                //self.updateWeatherData(json: weatherResult)
            } else {
                print("Error \(responce.result.error!)" )
                self.navigationItem.title = "Connection Issues"
            }
        }
        
    }
    
    
}

