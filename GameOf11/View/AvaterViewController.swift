//
//  AvaterViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 21/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class AvaterViewController: UIViewController,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var avatarCollectionView: UICollectionView!
    
    @IBOutlet weak var updateButton: UIButton!
    
    var avatars: [Avatar]!
    
    var currentAvaterId: Int!
    
    var selectedAvatarId:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navTitleLabel.text = "SELECT YOUR AVATAR".localized
        updateButton.setTitle("UPDATE AVATAR".localized, for: .normal)
        avatarCollectionView.delegate = self
        avatarCollectionView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if #available(iOS 13, *) {
                  if UserDefaults.standard.bool(forKey: "DarkMode"){
                      
                      overrideUserInterfaceStyle = .dark
                      
                  }else{
                      overrideUserInterfaceStyle = .light
                  }
              
              }else{
                  
              }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return avatars.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as! AvatarCollectionViewCell
        
        let singleAvatar = avatars[indexPath.item]
        
        let url1 = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(singleAvatar.imagePath ?? "")")
        
        cell.avatarImageView.kf.setImage(with: url1)
        
        if currentAvaterId == singleAvatar.avaterId{
            
            selectedAvatarId = String(describing:singleAvatar.avaterId!)
            
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath)
    {
        //Select 1st cell when the collection view is first loaded
        if collectionView.indexPathsForSelectedItems?.first == nil && indexPath.row == 0
        {
            cell.isSelected = true
            collectionView.selectItem(at: indexPath, animated: false, scrollPosition: UICollectionView.ScrollPosition(rawValue: 0))
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let singleAvatar = avatars[indexPath.item]
        
        selectedAvatarId = String(describing:singleAvatar.avaterId!)
        
        print("selectedAvatarId............",selectedAvatarId)
    }
    
    
    @IBAction func updateAvatarAction(_ sender: Any) {
        
        APIManager.manager.updateAvatarWith(avatarId: selectedAvatarId) { (status, msg) in
            
            
            if status{
                
                print("avatar is updated")
                self.dismiss(animated: true) {
                    
                    
                }
            }
        }
    }
    
    @IBAction func closeButtonAction(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            
        }
    }
    
    
}
