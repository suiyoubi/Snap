//
//  UserInfo.swift
//  snap
//
//  Created by Ao Tang on 2018-03-21.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import Foundation
import Alamofire

final class UserInfo{
    static let sharedInstance = UserInfo()
    private var username: String = ""
    private var photos: [String] = Array()
    private init() {}
    
    static func getInstace() -> UserInfo {
        return .sharedInstance
    }
    func updateUsername(username:String) {
        self.username = username
    }
    func getUsername() -> String {
        return self.username
    }
    
    func updatePhotos(photos:[String]) {
        self.photos = photos
        //processPhotos()
    }
    func getPhotos() -> [String] {
        return self.photos
    }
    
    func removeDuplicatePhotos() {
        var encountered = Set<String>()
        var result: [String] = []
        for value in self.photos {
            if encountered.contains(value) {
                // Do not add a duplicate element.
            }
            else {
                // Add value to the set.
                encountered.insert(value)
                // ... Append the value.
                result.append(value)
            }
        }
        self.photos = result
    }
    
    func getTrainingPhotoName() -> String{
        if photos.count == 0 {
            return "null"
        }
        return Utils.deleteQuote(s: photos[0])
    }
    func cleanUser() {
        self.photos.removeAll()
        self.username = ""
    }
    func selfUpdatePhotos() {
        let username = self.username
        let httpAddress = "http://35.230.95.204:5001/get_images/" + username
        
        print("updating the photo gallery")
        Alamofire.request(httpAddress, method: .get).responseString { response in
            if let responseString = response.result.value {
                
                if(responseString.count != 2) {
                    var newString = responseString.prefix(responseString.count - 1)
                    newString = newString.suffix(newString.count - 1)
                    let array = newString.components(separatedBy: ", ")
                    print (array[0])
                    //print (array[1])
                    
                    self.photos = array
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
                
            }
        }
    }
}
