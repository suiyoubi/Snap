//
//  RegisterViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-11.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit
import Alamofire

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var email_tf: UITextField!
    @IBOutlet weak var repassword_tf: UITextField!
    @IBOutlet weak var password_tf: UITextField!
    @IBOutlet weak var username_tf: UITextField!
    
    @IBOutlet weak var warning_label: UILabel!
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        warning_label.text = nil
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func registerAction(_ sender: Any) {
        
        if checkCorrectness() == true {
            sendRegisterRequest()
        }
    }
    
    func sendRegisterRequest() {
        let username = username_tf.text?.lowercased()
        let password = password_tf.text
        let repass = repassword_tf.text
        let email = email_tf.text
        
        let httpAddress = "http://35.230.95.204:5001/register_user"
        let headers = ["username": username!,
                       "password": password!]
        Alamofire.request(httpAddress, method: .post, headers: headers).responseString { response in
            if let JSON = response.result.value {
                /*
                 var jsonobject = JSON as! [String: AnyObject]
                 let origin = jsonobject["origin"] as! String
                 let url = jsonobject["url"] as! String
                 print("JSON: \(jsonobject)")
                 print("IP Address Origin: \(origin)")
                 print("url: \(url)")
                 */
                print("The response is:", JSON)
                if(JSON.elementsEqual("New User added")) {
                    let user = UserInfo.getInstace()
                    user.updateUsername(username: (username?.lowercased())!)
                    let alert = UIAlertController(title: "Register", message: "Register Success!\nDo you want to upload your profile picture now?", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Later", comment: "Default action"), style: .`default`, handler: { _ in
                        NSLog("The \"OK\" alert occured.")
                        
                    }))
                    alert.addAction(UIAlertAction(title: NSLocalizedString("Yes", comment: "Default action"), style: .`default`, handler: { _ in
                        NSLog("The \"Login\" alert occured.")
                        self.actionSheetPopUp()
                        
                    }))
                    self.present(alert, animated: true, completion: nil)
                } else if JSON.elementsEqual("Username already exists") {
                    self.warning_label.text = "Username already Exsits"
                }
            }
            
        }
        
    }
    
    func goToMainViewController() {
        let mainstoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = mainstoryboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
        self.present(newViewController, animated: true, completion: nil)
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
    
    func checkCorrectness() -> Bool{
        
        let username = username_tf.text
        let password = password_tf.text
        let repass = repassword_tf.text
        print("check correctness")
        
        if username == "" {
            warning_label.text = "Please Enter Your Username"
            return false
        } else if password == "" {
            warning_label.text = "Please Enter Your Password"
            return false
        } else if repass == "" {
            warning_label.text = "Please Confirm Your Password"
            return false
        } else if password?.elementsEqual(repass!) == false {
            warning_label.text = "Password Does Not Match"
            return false
        } else {
            warning_label.text = ""
            return true
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //let imageURL = info[UIImagePickerControllerReferenceURL] as? URL
        //imageView.image = image
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
                             to: "http://35.230.95.204:5001/new_face/" + (username_tf.text?.lowercased())!,
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
                                 default:
                                    print("HAHA")
                                }
                                
                         })
                    print("Finish upload image")
            }
            
            
            print("i think its ok")
            saveImage(image: image)
            //uploadProfilePictureToServer(selectedImage: image, info: info)
            picker.dismiss(animated: true, completion: nil)
            goToMainViewController()
            
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
    
    //MARK: - Add image to Library
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
    
    func uploadProfilePictureToServer(selectedImage: UIImage, info: [String : Any]) {
        let httpAddress = "http://35.230.95.204:5001/new_face/" + username_tf.text!
        print("http address:" + httpAddress)
        print("TODO: impelement the photo uploading")
        
        
      
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        goToMainViewController()
    }
    
    func saveImage(image:UIImage) {
        let imageData: NSData = UIImagePNGRepresentation(image)! as NSData
        
        UserDefaults.standard.set(imageData, forKey: "savedImage")
        
        print("photo save as savedImage")
    }
}
