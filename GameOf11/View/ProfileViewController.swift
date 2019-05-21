//
//  ProfileViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/17/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SVProgressHUD

class ProfileViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    @IBOutlet var profilePicImageView: UIImageView!
    @IBOutlet var cameraButton: UIButton!
    @IBOutlet var userNameLabel: UILabel!
    @IBOutlet var depositedCoinCountLabel: UILabel!
    @IBOutlet var winningAmountLabel: UILabel!
    @IBOutlet var pendingReqCountLabel: UILabel!
    
    @IBOutlet var contestCountLabel: UILabel!
    
    @IBOutlet var topRankCountLabel: UILabel!
    @IBOutlet var matchCountLabel: UILabel!
    
    @IBOutlet var addCoinButton: UIButton!
    @IBOutlet var withdrawButton: UIButton!
    
    @IBOutlet var redeemButton: UIButton!
    
    @IBOutlet var phoneNoLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    
    var imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if AppSessionManager.shared.authToken == nil{
            
            self.performSegue(withIdentifier: "openSignUp", sender: self)
        }
        
        placeNavBar(withTitle: "My Profile", isBackBtnVisible: false)

        addCoinButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        withdrawButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        redeemButton.decorateButtonRound(15, borderWidth: 1.0, borderColor: "#30B847")
        
        imagePicker.delegate = self
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if AppSessionManager.shared.authToken != nil{
            APIManager.manager.getMyProfile { (status, um, msg) in
                if status{
                    if let u = um{
                        AppSessionManager.shared.currentUser = u
                        AppSessionManager.shared.save()
                        // self.fill(u)
                        
                        if let um = AppSessionManager.shared.currentUser {
                            
                            self.phoneNoLabel.text = String.init(format: "%@", um.phone ?? "")
                            self.userNameLabel.text = String.init(format: "%@", um.name ?? "")
                            self.emailLabel.text = String.init(format: "%@", um.email ?? "")
                            
                            self.depositedCoinCountLabel.text = String.init(format: "%.2f", um.metadata?.totalCoins ?? "")
                            self.winningAmountLabel.text = String.init(format: "%.2f", um.metadata?.totalCash ?? "")
                            self.pendingReqCountLabel.text = String.init(format: "%d", um.metadata?.totalPendingRequest ?? "")
                            self.contestCountLabel.text = String.init(format: "%d", um.metadata?.totalContestParticipation ?? "")
                            self.topRankCountLabel.text = String.init(format: "%d", um.metadata?.highestRank ?? "")
                            self.matchCountLabel.text = String.init(format: "%d", um.metadata?.totalMatchParticipation ?? "")
                            
                            
                            
                        }
                        else
                        {
                            
                        }
                    }
                }
                else{
                    self.showStatus(status, msg: msg)
                }
            }
        }
        else
        {
            self.performSegue(withIdentifier: "openSignUp", sender: self)
        }
        
        
    }
    
    @IBAction func cameraButtonAction(_ sender: UIButton) {
        //getAvatarList
        APIManager.manager.getAvatarList { (avatars) in
           print(avatars)
        }
//
//        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
//        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
//            self.openCamera()
//        }))
//
//        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
//            self.openGallary()
//        }))
//
//        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
//
//        switch UIDevice.current.userInterfaceIdiom {
//        case .pad:
//            alert.popoverPresentationController?.sourceView = sender
//            alert.popoverPresentationController?.sourceRect = sender.bounds
//            alert.popoverPresentationController?.permittedArrowDirections = .up
//        default:
//            break
//        }
//
//        self.present(alert, animated: true, completion: nil)
    
    }
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallary()
    {
        imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
        imagePicker.allowsEditing = true
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    
    
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        
        
    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
    }
    
    @IBAction func redeemButtonAction(_ sender: Any) {
    }
    
    
    @IBAction func fullProfileButtonAction(_ sender: Any) {
        
        
    }
    @IBAction func verifyButtonAction(_ sender: Any) {
        
        
    }
    
    @IBAction func referToFriendButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ReferalViewController") as? ReferalViewController
       
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func logoutButtonAction(_ sender: Any) {
        
        APIManager.manager.logOut { (status, msg) in
            
             AppSessionManager.shared.logOut()
            if status{
               // SVProgressHUD.showSuccess(withStatus: msg)
                self.showStatus(status, msg: msg)
                
                
            }
            else{
                self.showStatus(false, msg: msg)
                
                //SVProgressHUD.showError(withStatus: msg)
            }
            
        }
    }
    
    //image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            self.profilePicImageView.image = image
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true) {
            
            
        }
    }
    
}

