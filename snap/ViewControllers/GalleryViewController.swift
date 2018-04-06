//
//  GalleryViewController.swift
//  snap
//
//  Created by Ao Tang on 2018-03-11.
//  Copyright © 2018 ece.ubc. All rights reserved.
//

import UIKit

class GalleryViewController: UIViewController {

    @IBOutlet weak var alertButton: UIBarButtonItem!

    @IBOutlet weak var MenuButton: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    var photos: [INSPhotoViewable] = {
        return [
            INSPhoto(image: UIImage(named: "1")!, thumbnailImage: UIImage(named: "1")!),
            INSPhoto(image: UIImage(named: "2")!, thumbnailImage: UIImage(named: "2")!),
            //INSPhoto(image: UIImage(named: "3")!, thumbnailImage: UIImage(named: "3")!)
            INSPhoto(imageURL: URL(string: "http://35.230.95.204/6E301102-CC70-4802-B747-6BF57275A786.jpeg"), thumbnailImageURL: URL(string: "http://35.230.95.204/6E301102-CC70-4802-B747-6BF57275A786.jpeg")),
            
        ]
    }()
    
    func setupPhotoArray() {
        let user = UserInfo.getInstace()
        let array = user.getPhotos()
        self.photos.removeAll(keepingCapacity: true)
        for eachPhotoName in array {
            //var editedPhotoName:String = String(eachPhotoName.suffix(eachPhotoName.count - 1))
            //editedPhotoName = String(editedPhotoName.prefix(editedPhotoName.count - 1))
            
            let editedPhotoName = Utils.deleteQuote(s: eachPhotoName)
            let url = "http://35.230.95.204/" + editedPhotoName
            print(url)
            self.photos.append(INSPhoto(imageURL: URL(string: url), thumbnailImageURL: URL(string: url)))
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        revealViewController().rearViewRevealWidth = 275
        MenuButton.target = revealViewController()
        MenuButton.action = #selector(SWRevealViewController.revealToggle(_:))
        
        setupPhotoArray()
        
        for photo in photos {
            if let photo = photo as? INSPhoto {
                let photoName = photo.imageURL?.absoluteString
                //photo.attributedTitle = NSAttributedString(string: photoName!, attributes: [NSAttributedStringKey.foregroundColor: UIColor.white])
                
            }
        }
        
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.tintColor = UIColor(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        navigationController?.navigationBar.barTintColor = UIColor(displayP3Red: 119/255, green: 184/255, blue: 239/255, alpha: 1)
        
        
        
        let loadingView = DGElasticPullToRefreshLoadingViewCircle()
        loadingView.tintColor = UIColor(red: 78/255.0, green: 221/255.0, blue: 200/255.0, alpha: 1.0)
        collectionView.dg_addPullToRefreshWithActionHandler({ [weak self] () -> Void in
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now(), execute: {
                print("1")
                let user = UserInfo.getInstace()
                user.selfUpdatePhotos()
                self?.collectionView.dg_stopLoading()
                print("2")
            })
            }, loadingView: loadingView)
        collectionView.dg_setPullToRefreshFillColor(UIColor(displayP3Red: 119/255, green: 184/255, blue: 239/255, alpha: 1))
        collectionView.dg_setPullToRefreshBackgroundColor(collectionView.backgroundColor!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        collectionView.dg_removePullToRefresh()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
}

extension GalleryViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GalleryCollectionViewCell", for: indexPath) as! GalleryCollectionViewCell
        cell.populateWithPhoto(photos[(indexPath as NSIndexPath).row])
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! GalleryCollectionViewCell
        let currentPhoto = photos[(indexPath as NSIndexPath).row]
        let galleryPreview = INSPhotosViewController(photos: photos, initialPhoto: currentPhoto, referenceView: cell)
        
        
        galleryPreview.referenceViewForPhotoWhenDismissingHandler = { [weak self] photo in
            if let index = self?.photos.index(where: {$0 === photo}) {
                let indexPath = IndexPath(item: index, section: 0)
                return collectionView.cellForItem(at: indexPath) as? GalleryCollectionViewCell
            }
            return nil
        }
        present(galleryPreview, animated: true, completion: nil)
    }
}

