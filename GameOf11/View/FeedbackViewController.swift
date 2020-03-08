//
//  FeedbackViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 23/8/19.
//  Copyright © 2019 Tanvir Palash. All rights reserved.
//

import UIKit

class FeedbackViewController: UIViewController,UITextViewDelegate {
    
    @IBOutlet weak var navTitlelabel: UILabel!
    @IBOutlet weak var feedbackView: UIView!
    
    @IBOutlet weak var phoneTextField: UITextField!
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var feedbackPlaceHolderLabel: UILabel!
    @IBOutlet weak var feedbackTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        
        navTitlelabel.text = "YOUR FEEDBACK".localized
        feedbackPlaceHolderLabel.text = "Write your feedback message".localized
        sendButton.setTitle("Send Your Feedback".localized, for: .normal)
        emailTextField.text = String.init(format: "%@", (AppSessionManager.shared.currentUser?.email)!)
        phoneTextField.text = String.init(format: "%@", (AppSessionManager.shared.currentUser?.phone)!)
        
        feedbackTextView.delegate = self
        
        self.feedbackView.layer.cornerRadius = 5
        self.feedbackView.layer.applySketchShadow(
            color: UIColor.init(named: "ShadowColor")!,
            alpha: 1.0,
            x: 0,
            y: 2,
            blur: 6,
            spread: 0)
        
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        
        self.feedbackPlaceHolderLabel.isHidden = true
        
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        
        if feedbackTextView.text.count <= 0{
            
            self.feedbackPlaceHolderLabel.isHidden = false
            
        }
    }
    
    @IBAction func fedbackButtonAction(_ sender: Any) {
        
        
        if feedbackTextView.text.count != 0{
            
            let params:[String:String] = ["phone":phoneTextField.text!,
                                          "email": emailTextField.text!,
                                          "message":feedbackTextView.text!]
            
            
            APIManager.manager.postFeedback(params: params) { (status, msg) in
                
                
                if status{
                    
                    self.view.makeToast(msg!)
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }
        
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
}
