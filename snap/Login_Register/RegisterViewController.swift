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
        let username = username_tf.text
        let password = password_tf.text
        let repass = repassword_tf.text
        let email = email_tf.text
        
        let httpAddress = "http://104.199.127.227:5001/register_user"
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
        let imagePickerController = UIImagePickerController()
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
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        
        //imageView.image = image
        print("i think its ok")
        saveImage(image: image)
        uploadProfilePictureToServer(selectedImage: image, info: info)
        picker.dismiss(animated: true, completion: nil)
        goToMainViewController()
    }
    
    func uploadProfilePictureToServer(selectedImage: UIImage, info: [String : Any]) {
        let httpAddress = "http://104.199.127.227:5001/new_face/" + username_tf.text!
        print("http address:" + httpAddress)
       
        
            let parameters: Parameters = [:]
            // You can change your image name here, i use NSURL image and convert into string
        
       
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (key, value) in parameters {
                multipartFormData.append("\(value)".data(using: String.Encoding.utf8)!, withName: key as String)
            }
            
            if let data = imageData{
                multipartFormData.append(data, withName: "image", fileName: "image.png", mimeType: "image/png")
            }
            
        }, usingThreshold: UInt64.init(), to: url, method: .post, headers: headers) { (result) in
            switch result{
            case .success(let upload, _, _):
                upload.responseJSON { response in
                    print("Succesfully uploaded")
                    if let err = response.error{
                        onError?(err)
                        return
                    }
                    onCompletion?(nil)
                }
            case .failure(let error):
                print("Error in upload: \(error.localizedDescription)")
                onError?(error)
            }
        }
            // Start Alamofire
            Alamofire.upload(multipartFormData: { (multipartFormData) in
                multipartFormData.append(UIImageJPEGRepresentation(selectedImage, 0.5)!, withName: "photo_path", fileName: self.username_tf.text!, mimeType: "image/jpeg")
                for (key, value) in parameters {
                    multipartFormData.append((value as AnyObject).data(using: String.Encoding.utf8.rawValue)!, withName: key)
                }
            }, to:httpAddress, method: .post)
            { (result) in
                switch result {
                case .success(let upload, _, _):
                    
                    upload.uploadProgress(closure: { (Progress) in
                        print("Upload Progress: \(Progress.fractionCompleted)")
                    })
                    
                    upload.responseJSON { response in
                        //self.delegate?.showSuccessAlert()
                        print(response.request)  // original URL request
                        print(response.response) // URL response
                        print(response.data)     // server data
                        print(response.result)   // result of response serialization
                        //                        self.showSuccesAlert()
                        //self.removeImage("frame", fileExtension: "txt")
                        if let JSON = response.result.value {
                            print("JSON: \(JSON)")
                        }
                    }
                    
                case .failure(let encodingError):
                    //self.delegate?.showFailAlert()
                    print("CHUCUOLE")
                    print(encodingError)
                    print("chucuole")
                }
                
            }
        
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
