//
//  SignupViewController.swift
//  UG Customer
//
//  Created by Amit Sen on 3/13/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import UIKit

class SignupViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmPasswordField: UITextField!
    @IBOutlet weak var genderField: UITextField!
    @IBOutlet weak var birthdayField: UITextField!
    @IBOutlet weak var nationalityField: UITextField!
    @IBOutlet weak var mobileField: UITextField!
    @IBOutlet weak var addressField: UITextField!
    @IBOutlet weak var btnView: UIView!
    
    // public variables
    let viewModel = SignupViewModel.init()
    
    // private variables
    
    //Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setViews()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    @IBAction func goBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func profileImgBtnPressed(_ sender: UIButton) {
    }
    
    // public methods
    
    // private methods
    private func setViews() {
        btnView.backgroundColor = .white
        btnView.layer.backgroundColor = viewModel.colors.go_btn.cgColor
        btnView.makeCircular(borderWidth: 0.0, borderColor: .clear)
        
        nameField.backgroundColor = .white
        nameField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        nameField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        nameField.setPlaceholder(withText: viewModel.texts.name, usingColor: viewModel.colors.textfield_hint)
        nameField.setCustomTextRect()
        
        emailField.backgroundColor = .white
        emailField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        emailField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        emailField.setPlaceholder(withText: viewModel.texts.email, usingColor: viewModel.colors.textfield_hint)
        emailField.setCustomTextRect()
        
        passwordField.backgroundColor = .white
        passwordField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        passwordField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        passwordField.setPlaceholder(withText: viewModel.texts.password, usingColor: viewModel.colors.textfield_hint)
        passwordField.setCustomTextRect()
        
        confirmPasswordField.backgroundColor = .white
        confirmPasswordField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        confirmPasswordField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        confirmPasswordField.setPlaceholder(withText: viewModel.texts.confirmPassword, usingColor: viewModel.colors.textfield_hint)
        confirmPasswordField.setCustomTextRect()
        
        genderField.backgroundColor = .white
        genderField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        genderField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        genderField.setPlaceholder(withText: viewModel.texts.gender, usingColor: viewModel.colors.textfield_hint)
        genderField.setCustomTextRect()
        
        birthdayField.backgroundColor = .white
        birthdayField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        birthdayField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        birthdayField.setPlaceholder(withText: viewModel.texts.birthdate, usingColor: viewModel.colors.textfield_hint)
        birthdayField.setCustomTextRect()
        
        nationalityField.backgroundColor = .white
        nationalityField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        nationalityField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        nationalityField.setPlaceholder(withText: viewModel.texts.nationality, usingColor: viewModel.colors.textfield_hint)
        nationalityField.setCustomTextRect()
        
        mobileField.backgroundColor = .white
        mobileField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        mobileField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        mobileField.setPlaceholder(withText: viewModel.texts.mobile, usingColor: viewModel.colors.textfield_hint)
        mobileField.setCustomTextRect()
        
        addressField.backgroundColor = .white
        addressField.layer.backgroundColor = viewModel.colors.transparent.cgColor
        addressField.makeCircular(borderWidth: 0.7, borderColor: viewModel.colors.textfield_border)
        addressField.setPlaceholder(withText: viewModel.texts.address, usingColor: viewModel.colors.textfield_hint)
        addressField.setCustomTextRect()
        
        
    }
    
    // delegates
}
