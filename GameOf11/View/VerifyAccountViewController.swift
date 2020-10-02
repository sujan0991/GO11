//
//  VerifyAccountViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices

class VerifyAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var isFront = true;

    @IBOutlet weak var navTitleLabel: UILabel!
    @IBOutlet weak var suggestionLabel: TIFAttributedLabel!
    
    
    
    @IBOutlet weak var frontSelectButton: UIButton!
    @IBOutlet weak var frontImageView: UIImageView!
    @IBOutlet weak var frontImageLabel: UILabel!
    
    @IBOutlet weak var backImageButton: UIButton!
    @IBOutlet weak var backImageView: UIImageView!
    @IBOutlet weak var backImageLabel: UILabel!
    
    @IBOutlet weak var verifyButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

   //     self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        
      //  placeNavBar(withTitle: "VERIFY ACCOUNT", isBackBtnVisible: true)
        self.tabBarController?.tabBar.isHidden = true
        
        imagePicker.delegate = self
        
        frontImageView.layer.cornerRadius = 5.0
        frontImageView.layer.borderWidth = 1.0
        frontImageView.layer.borderColor = UIColor.init(named: "on_green")?.cgColor
        backImageView.layer.cornerRadius = 5.0
        backImageView.layer.borderWidth = 1.0
        backImageView.layer.borderColor = UIColor.init(named: "on_green")?.cgColor
        
        navTitleLabel.text = "VERIFY YOUR PROFILE".localized
        suggestionLabel.text = "To verify your profile, you need to provide any one of these mentioned Govt. issued ID i.e. NID, Driving License, Passport, Birth Certificate.You need to upload the photo of both the front and back side of the ID. For Passport you can upload the main page and address page in a single image.".localized
        
        frontSelectButton.setTitle("SELECT IMAGE".localized, for: .normal)
        backImageButton.setTitle("SELECT IMAGE".localized, for: .normal)
        
        frontImageLabel.text = "Front Side Image".localized
        backImageLabel.text = "Back Side Image".localized
        verifyButton.setTitle("VERIFY YOUR PROFILE".localized, for: .normal)
        
        
        let userData = AppSessionManager.shared.currentUser
        
        if userData?.metadata?.photoIdFront != nil{
            
            let url = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(userData?.metadata?.photoIdFront ?? "")")
            
            self.frontImageView.kf.setImage(with: url)
            
            
//            frontSelectButton.isHidden = true
//            backImageButton.isHidden = true
//            verifyButton.isHidden = true
            
        }
        if userData?.metadata?.photoIdBack != nil{
            
            let url = URL(string: "\(UserDefaults.standard.object(forKey: "media_base_url") as? String ?? "")\(userData?.metadata?.photoIdBack ?? "")")
            
            self.backImageView.kf.setImage(with: url)
        }
    }
    
    
    @IBAction func frontImageButtonAction(_ sender: UIButton) {
        
        photoSelect(sender)
        isFront = true
    }
    
    
    @IBAction func backImageButtonAction(_ sender: UIButton) {
        
        photoSelect(sender)
        isFront = false
    }
    
    func photoSelect(_ sender: UIButton) {
        
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallary()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            alert.popoverPresentationController?.sourceView = sender
            alert.popoverPresentationController?.sourceRect = sender.bounds
            alert.popoverPresentationController?.permittedArrowDirections = .up
        default:
            break
        }
        
        self.present(alert, animated: true, completion: nil)

    }
    
    func openCamera()
    {
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerController.SourceType.camera))
        {
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
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
        imagePicker.allowsEditing = false
        self.present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func verifyProfileButtonAction(_ sender: Any) {
        
        if frontImageView.image != nil && backImageView.image != nil{
            
            
            
            let params = [
                
                "nid_front":frontImageView.image!,
                "nid_back":backImageView.image!,
                ] as [String : Any]
            
            APIManager.manager.postVerifyProfile(params: params, withCompletionHandler: { (status, msg) in
                
                print("msg in post messege",msg)
                if status{
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
        }else if frontImageView.image != nil{
            
            let params = [
                
                "nid_front":frontImageView.image!,
                
                ] as [String : Any]
            
            APIManager.manager.postVerifyProfile(params: params, withCompletionHandler: { (status, msg) in
                
                print("msg in post messege",msg)
                
                if status{
                    
                    self.navigationController?.popViewController(animated: true)
                }
                
            })
        }else{
            
            self.view.makeToast("Please upload one image at least!".localized)
        }
        
        
    }
    
    
    
    //image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if self.isFront {
                
                
                self.frontImageView.image = image
                self.verifyButton.isUserInteractionEnabled = true
                
            }else{
                
                self.backImageView.image = image
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true) {
            
            
        }
    }
    @IBAction func infoButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/verify-profile"
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
    }
    
    
    @IBAction func backbuttonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    
}


@IBDesignable class TIFAttributedLabel: UILabel {
    
    @IBInspectable var fontSize: CGFloat = 13.0
    
    @IBInspectable var fontFamily: String = "Open Sans"
    
    override func awakeFromNib() {
        var attrString = NSMutableAttributedString(attributedString: self.attributedText!)
        attrString.addAttribute(NSAttributedString.Key.font, value: UIFont(name: self.fontFamily, size: self.fontSize)!, range: NSMakeRange(0, attrString.length))
        self.attributedText = attrString
    }
    
    
}
