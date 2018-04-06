//
//  MainViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-08.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MainViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate  {

    let imagePickerController = UIImagePickerController()
    @IBOutlet weak var menuButton: UIBarButtonItem!
    
    @IBOutlet weak var savedImageDisplay: UIImageView!
    
    @IBOutlet weak var username_lb: UILabel!
    
    @IBOutlet weak var numberOfImages_lb: UILabel!
 
    @IBOutlet weak var trainingImageExsits_lb: UILabel!
    
    @IBOutlet weak var trainingImageButton: UIButton!
    
    @IBOutlet weak var trainingImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        sideMenus()
        customizeNavBar()
        // Do any additional setup after loading the view.
        let user = UserInfo.getInstace()
        let username = user.getUsername()
        username_lb.text = "Hello, " + username
        //savedImageDisplay.image = UIImage(
        updateImageList()
        
        
        print("******" + user.getUsername())
    }

    func updateTextInfo() {
        trainingImageView.isHidden = true
        
        let user = UserInfo.getInstace()
        
        let numberImage = user.getPhotos().count
        
        if numberImage == 0 {
            numberOfImages_lb.text = "You don't have any photo in the gallery."
        } else if numberImage == 1{
            numberOfImages_lb.text = "You only have training photo in the gallery."
        } else {
            numberOfImages_lb.text = "You have " + String(numberImage) + " photos in the gallery."
        }
        
        if(numberImage == 0) {
            trainingImageExsits_lb.text = "Ops, looks like you dont have training photo!"
            trainingImageButton.setTitle("Take the Photo Now!", for: .normal)
        }else {
            trainingImageExsits_lb.text = "Your training photo looks awesome!"
            trainingImageButton.setTitle("Show My Photo!", for: .normal)
            let trainingImageName = user.getTrainingPhotoName()
            downloadTrainingPhoto(trainingPhotoName: trainingImageName)
            
        }
    }
    
    func updateImageList() {
        let user = UserInfo.getInstace()
        let username = user.getUsername()
        let httpAddress = "http://35.230.95.204:5001/get_images/" + username
        
        Alamofire.request(httpAddress, method: .get).responseString { response in
            if let responseString = response.result.value {
                
                if(responseString.count != 2) {
                    var newString = responseString.prefix(responseString.count - 1)
                    newString = newString.suffix(newString.count - 1)
                    let array = newString.components(separatedBy: ", ")
                   
                    user.updatePhotos(photos: array)
                    print(user.getPhotos())
                    
                }
                
                /*
                 var jsonobject = JSON as! [String: AnyObject]
                 let origin = jsonobject["origin"] as! String
                 let url = jsonobject["url"] as! String
                 print("JSON: \(jsonobject)")
                 print("IP Address Origin: \(origin)")
                 print("url: \(url)")
                 */
                print("The response string is:", responseString)
                self.updateTextInfo()
            }
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func sideMenus() {
        if revealViewController() != nil {
            menuButton.target = revealViewController()
            menuButton.action = #selector(SWRevealViewController.revealToggle(_:))
            revealViewController().rearViewRevealWidth = 275
            
            view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
    }
    
    
    @IBAction func buttonAction(_ sender: Any) {
        if(trainingImageButton.currentTitle?.elementsEqual("Show My Photo!") == true) {
            trainingImageView.isHidden = false
            trainingImageButton.setTitle("Hide My Photo!", for: .normal)
        } else if trainingImageButton.currentTitle?.elementsEqual("Hide My Photo!") == true {
            trainingImageView.isHidden = true
            trainingImageButton.setTitle("Show My Photo!", for: .normal)
        } else if trainingImageButton.currentTitle?.elementsEqual("Take the Photo Now!") == true {
            actionSheetPopUp()
        }
    }
    
    func downloadTrainingPhoto(trainingPhotoName: String) {
        let catPictureURL = URL(string: "http://35.230.95.204/" + trainingPhotoName)!
        
        let data = try? Data(contentsOf: catPictureURL)
        
        if let imageData = data {
            print("getting the training image")
            let image = UIImage(data: imageData)
            trainingImageView.image = image
        } else {
            print("fail to get training image")
        }
    }
    
    func customizeNavBar() {
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 119/255, green: 184/255, blue: 239/255, alpha: 1)
        
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
    }
    
    func actionSheetPopUp() {
        
        let imagePickerController = self.imagePickerController
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a Source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            } else {
                print("Camera Not Avaible")
            }
            
            
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //let imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        //imageView.image = image
        
        let username = UserInfo.getInstace().getUsername()
        print("hello")
        if let imgUrl = info[UIImagePickerControllerImageURL] as? URL{
            let imgName = imgUrl.lastPathComponent
            let documentDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first
            let localPath = documentDirectory?.appending(imgName)
            
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            let data = UIImagePNGRepresentation(image)! as NSData
            data.write(toFile: localPath!, atomically: true)
            //let imageData = NSData(contentsOfFile: localPath!)!
            let photoURL = URL.init(fileURLWithPath: localPath!)//NSURL(fileURLWithPath: localPath!)
            
            if let data = UIImageJPEGRepresentation(image,1) {
                let parameters: Parameters = [
                    "access_token" : "YourToken"
                ]
                // You can change your image name here, i use NSURL image and convert into string
                let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
                let fileName = imageURL.absoluteString
                // Start Alamofire
                
                print("start upload image")
                Alamofire.upload(
                    multipartFormData: { multipartFormData in
                        // On the PHP side you can retrive the image using $_FILES["image"]["tmp_name"]
                        multipartFormData.append(imgUrl, withName: "file")
                        for (key, val) in parameters {
                            multipartFormData.append((val as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                        }
                },
                    to: "http://35.230.95.204:5001/new_face/" + username,
                    method: .post,
                    encodingCompletion: { encodingResult in
                        switch encodingResult {
                        case .success(let upload, _, _):
                            upload.responseJSON { response in
                                if let jsonResponse = response.result.value as? [String: Any] {
                                    print("SUCCESS")
                                    print("$$$$$$")
                                    print(jsonResponse)
                                    print("$$$$$$")
                                    
                                }
                            }
                        case .failure(let encodingError):
                            print("FAILED")
                            print("$$$$$$")
                            print(encodingError)
                            print("$$$$$$")
                        }
                        
                })
                print("Finish upload image")
                print("UPLOAD SUCCESS!")
                updateImageList()
            }
            
            
            print("i think its ok")
           
            //uploadProfilePictureToServer(selectedImage: image, info: info)
            picker.dismiss(animated: true, completion: nil)
            
            
            
        } else {
            picker.dismiss(animated: true, completion: nil)
            let image = info[UIImagePickerControllerOriginalImage] as! UIImage
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
            let imagePickerController = self.imagePickerController
            imagePickerController.sourceType = .photoLibrary
            present(imagePickerController, animated: true, completion: nil)
        }
        
        /*
         print("i think its ok")
         saveImage(image: image)
         uploadProfilePictureToServer(selectedImage: image, info: info)
         picker.dismiss(animated: true, completion: nil)
         goToMainViewController()
         */
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
