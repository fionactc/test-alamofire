//
//  ViewController.swift
//  test5
//
//  Created by Joyce Cheung on 15/8/2016.
//  Copyright © 2016 Joyce Cheung. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController , UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var emailVar = ""
    var passwordVar = ""

    override func viewDidLoad() {
        imagepicker.delegate = self
        
        
        
}
    
    
    let imagepicker = UIImagePickerController()
    var pickedimaged = UIImage()
    
    @IBOutlet var image: UIImageView!
    
    @IBOutlet var password: UITextField!
    @IBOutlet var username: UITextField!
    @IBAction func loginButton(sender: AnyObject) {
        
      passwordVar = password.text!
       emailVar = username.text!
        let parameters: [String: AnyObject] = [
            "email" : emailVar,
            "password": passwordVar
            ]
        print(parameters)
        
        
 
        
    Alamofire.request(.POST, "https://mapo-angular.herokuapp.com/login", parameters: parameters)
        
      
    }
    var json = JSON("")
    @IBAction func getprofile(sender: AnyObject) {
        
        
//        Alamofire.request(.GET, "https://mapo-angular.herokuapp.com/profile").responseJSON { (responseData) -> Void in
//            if((responseData.result.value) != nil) {
//                let swiftyJsonVar = JSON(responseData.result.value!)
//            print(swiftyJsonVar)
//            
//            }
//        }
        let url = "https://mapo-angular.herokuapp.com/profile"
        Alamofire.request(.GET, url).validate().responseJSON { response in
            switch response.result {
            case .Success(let data):
            print("running here")
                 self.json = JSON(data)
                print(self.json)
                var  user = self.json["user"]
                print(user["type"])
            case .Failure(let error):
                print("Request failed with error: \(error)")
            }
        }
       print(json)
        if json == JSON("") {
        print("not loggin")
        }
    
    
    }
    
    @IBAction func addimage(sender: AnyObject) {
        imagepicker.sourceType = .PhotoLibrary
        imagepicker.allowsEditing = true
        
        presentViewController(imagepicker, animated: true, completion: nil)
        
    }
    
    @IBOutlet var getprofile: UIButton!
   
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        if let pickedimaged = info[UIImagePickerControllerEditedImage] as? UIImage {
            
            
            
            
            print("pickedimage")
            self.pickedimaged = pickedimaged
            
            
            self.image.image = pickedimaged
          
            
        }
        
        dismissViewControllerAnimated(true , completion: nil)
        self.image.image = pickedimaged
        
     
        
    }
    
    @IBAction func upload(sender: AnyObject) {
        var URL = "https://mapo-angular.herokuapp.com/account/profileimage"
        
        Alamofire.upload(.POST, URL,
                         // define your headers here
            headers: ["Authorization": "auth_token"],
            multipartFormData: { multipartFormData in
                
                // import image to request
                if let imageData = UIImageJPEGRepresentation(self.pickedimaged, 1) {
                    multipartFormData.appendBodyPart(data: imageData, name: "avatar", fileName: "myImage.png", mimeType: "image/png")
                }
                
                // import parameters
                
            }, // you can customise Threshold if you wish. This is the alamofire's default value
            encodingMemoryThreshold: Manager.MultipartFormDataEncodingMemoryThreshold,
            encodingCompletion: { encodingResult in
                switch encodingResult {
                case .Success(let upload, _, _):
                    upload.responseJSON { response in
                        debugPrint(response)
                    }
                case .Failure(let encodingError):
                    print(encodingError)
                    
                    
                }
        })
        
        
    }
    @IBOutlet var upload: UIButton!
}


