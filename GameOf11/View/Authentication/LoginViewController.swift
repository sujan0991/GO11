//
//  LoginViewController.swift
//  UG Customer
//
//  Created by Amit Sen on 3/8/18.
//  Copyright © 2018 Amit Sen. All rights reserved.
//

import UIKit

class LoginViewController: BaseViewController {
    // IBOutlets
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var fieldContainer: UIView!
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var btnView: UIView!
    
    // public variables
    
    // private variables
    var viewModel: LoginViewModel!
    
    //Overridden Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        viewModel = LoginViewModel.init()
        setViews()
        bindViewModel()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // IBActions
    @IBAction func goBtnPressed(_ sender: UIButton) {
//        viewModel.doLogin { (token) in
//            print("User Name: \(token.accessToken)")
//        }
    }
    
    @IBAction func forgotPasswordBtnPressed(_ sender: UIButton) {
    }
    
    @IBAction func signupBtnPressed(_ sender: UIButton) {
        viewModel.routes.gotoSignupPage(from: self)
    }
    // public methods
    
    // private methods
    private func setViews() {
        layerView.backgroundColor = .white
        layerView.layer.backgroundColor = viewModel.colors.map_gradient.cgColor
        
        btnView.backgroundColor = .white
        btnView.layer.backgroundColor = viewModel.colors.go_btn.cgColor
        btnView.makeCircular(borderWidth: 0.0, borderColor: .clear)
        
        fieldContainer.backgroundColor = .white
        fieldContainer.layer.backgroundColor = viewModel.colors.transparent.cgColor
        
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
    }
    
    private func bindViewModel() {
     //   emailField.reactive.text.bind(signal: viewModel.email)
     //   passwordField.reactive.text.bind(signal: viewModel.password)
    }
    
    // delegates
}
