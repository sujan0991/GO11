//
//  VerifyAccountViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

class VerifyAccountViewController: BaseViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var imagePicker = UIImagePickerController()
    var isFront = true;

    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        placeNavBar(withTitle: "Verify Account", isBackBtnVisible: true)
        
        imagePicker.delegate = self
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
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func verifyProfileButtonAction(_ sender: Any) {
        
    }
    
    
    
    //image picker delegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        imagePicker.dismiss(animated: true) {
            let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage
            
            if self.isFront {
                
                self.frontImageView.image = image
                
            }else{
                
                self.backImageView.image = image
            }
            
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        imagePicker.dismiss(animated: true) {
            
            
        }
    }

    
}
