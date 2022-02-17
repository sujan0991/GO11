//
//  WithdrawRequestViewController.swift
//  DropDown
//
//  Created by Md.Ballal Hossen on 24/2/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit

import Mixpanel

class WithdrawRequestViewController: BaseViewController,UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var bKashNoTextField: UITextField!
    @IBOutlet weak var confirmBkashNoTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var cashWithdrawLabel: UILabel!
    @IBOutlet weak var firstSuggestionlabel: UILabel!
    @IBOutlet weak var secondSuggestionlabel: UILabel!
    
    @IBOutlet weak var pendingLabel: UILabel!
    @IBOutlet var pendingReqCountLabel: UILabel!

    @IBOutlet weak var withdrawMethodTableView: UITableView!
    
    @IBOutlet weak var withdrawMethodViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var chooseMethodLabel: UILabel!
    
    @IBOutlet weak var shadowView: UIView!
    
    @IBOutlet weak var redeemPackView: UIView!
    
    @IBOutlet weak var packCollectionView: UICollectionView!
    
    
    @IBOutlet weak var offerLabel: UILabel!
    @IBOutlet weak var redeemCoinsButton: UIButton!
    @IBOutlet weak var withdrawButton: UIButton!
    
    
    let formatter = NumberFormatter()
    
    struct PaymentMethod {
        let name: String
        let channelName: String
        var selected: Bool
    }
    
    var methodLists: [PaymentMethod] = []
    
    var redeemPacks: [Any] = []
    
    
    private var selectedPaymentMethod: Int? {
        didSet {
            withdrawMethodTableView.reloadData()
        }
    }
    
    var selectedChannelType = "None"
    var selectedRedeemAmount = "0"
    
    override func viewDidLoad() {
        super.viewDidLoad()

      //  self.view.setGradientBackground(colorTop:UIColor.white , colorBottom: UIColor.init(named: "light_blue_transparent")!)
        // Do any additional setup after loading the view.
       
       
        getWithdrawChannel()//get Withdraw Channel list
        
        getRedeemPack()
        
        placeNavBar(withTitle: "WITHDRAW REQUEST".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        
        chooseMethodLabel.text = "Choose your withdrawl method".localized
        amountLabel.text = "Amount in BDT".localized
        tkAmountTextField.placeholder = "Amount in BDT".localized
        bKashNoTextField.placeholder = "Personal phone number".localized
        pendingLabel.text = "Pending Withdraw".localized
        
        sendButton.setTitle("Send Withdraw Request".localized, for: .normal)
        sendButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        
        cashWithdrawLabel.text = "Cash-Withdrawl!".localized
        firstSuggestionlabel.text = "The minimum withdrawal amount is 250 BDT and the maximum amount is 4999 BDT.".localized
        secondSuggestionlabel.text = "Personal number is needed while withdrawing the money.".localized
        offerLabel.text = "Special Offer : redeem coins with your prize money to get extra coins!".localized
        
        self.tabBarController?.tabBar.isHidden = true
        
        if let usermodel = AppSessionManager.shared.currentUser {
           
            if Language.language == Language.english{
                
                self.pendingReqCountLabel.text = String.init(format: "%d",usermodel.metadata?.totalPendingRequest ?? "")
            }else{
                
                self.pendingReqCountLabel.text = String.init(format: "%@", self.formatter.string(from: usermodel.metadata?.totalPendingRequest as NSNumber? ?? 0)!)
                
            }
        }else{
            
        }
        
        
        withdrawMethodTableView.delegate = self
        withdrawMethodTableView.dataSource = self
        withdrawMethodTableView.tableFooterView = UIView()
        withdrawMethodTableView.register(UINib(nibName: "WithdrawMethodCell", bundle: nil), forCellReuseIdentifier: "withdrawMethodCell")
        
        packCollectionView.delegate = self
        packCollectionView.dataSource = self
    }
    
    private func updateSelectedIndex(_ index: Int) {
        
        selectedPaymentMethod = index
    }
    
    
    func getWithdrawChannel(){
        
        var lang = ""
        if Language.language == Language.english{
            lang = "EN"
        }else{
            lang = "BN"
        }
        
        APIManager.manager.getWithdrawChannelList(lang: lang) { (status, msg, channelList) in
            
            if status{
            
                for channel in channelList{
                    
                    let temp = channel as! Dictionary<String,Any>
                    if Language.language == Language.english{
                        
                        let name = temp["english_name"] as! String
                        let channelName = temp["channel_name"] as! String
                        //add in methodlist
                        let new = PaymentMethod(name: name, channelName: channelName, selected: false)
                        self.methodLists.append(new)
                        
                    }else{
                        
                        let name = temp["bangla_name"] as! String
                        let channelName = temp["channel_name"] as! String
                        //add in methodlist
                        let new = PaymentMethod(name: name, channelName: channelName, selected: false)
                        self.methodLists.append(new)
                    }
                }
                
                self.withdrawMethodTableView.reloadData()
                
                // set view height based on tableview height
                self.withdrawMethodViewHeight.constant = self.withdrawMethodTableView.contentSize.height + 42
            }else{
                
                print("no channel.......")
                
                let alertController = UIAlertController(title: "", message: msg, preferredStyle: UIAlertController.Style.alert)

                alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    
                        self.GoBack()
                    
                    }))

                self.present(alertController, animated: true, completion: nil)
            }
        }
        
    }
    
    func getRedeemPack(){
        
        var accountBalance = 0.0
        //get the account balance
        if let um = AppSessionManager.shared.currentUser {
            
            accountBalance = Double(um.metadata?.totalCash ?? 0.0)
        }
        //
        APIManager.manager.getRedeemCoinPack { (status, packList, msg) in
            
            if status{
                
                for singleList in packList{
                    
                    let temp = singleList as! Dictionary<String,Any>//to dictionary
                    
                    //if pack amount is smaller then total balance, add to the list
                    
                    if accountBalance >= temp["amount"] as! Double{
                        
                        self.redeemPacks.append(temp)
                    }
                    
                }
            }
        }
        
        print("RedeemCoinPack..........",redeemPacks.count)
       
    }
    
    func GoBack(){

        self.navigationController?.popViewController(animated: true)
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
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
       // return withdrawListArray.count
        return methodLists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"withdrawMethodCell") as! WithdrawMethodCell
        
        // 2
        cell.selectionStyle = .none
        // 3
        let method = methodLists[indexPath.row]
        // 4
        let currentIndex = indexPath.row
        // 5
        let selected = currentIndex == selectedPaymentMethod
        // 6
        cell.configure(method.name)
        // 7
        cell.isSelected(selected)
        // 8
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateSelectedIndex(indexPath.row)
        
//        guard let cell = tableView.cellForRow(at: indexPath) as? WithdrawMethodCell
//            else{
//              return
//            }
        
        let method = methodLists[indexPath.row]
        
        selectedChannelType = method.channelName
        
        print("method.name..........", selectedChannelType)
        
    }


    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return redeemPacks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coinPackCell", for: indexPath) as! CoinPackCollectionViewCell
        
        let singlePack = redeemPacks[indexPath.item] as! Dictionary<String,Any>
        
        //String.init(format:"%d",self.selectedContest?.entryAmount ?? 0)
        if Language.language == Language.english{
            cell.oldpackLabel.text = "\(String(describing: singlePack["actual_amount"]!)) BDT"
            cell.newPackLabel.text = "\(String(describing: singlePack["amount"]!)) BDT"
            cell.counAmountLabel.text = "\(String(describing: singlePack["coin"]!)) COINS"
        }else{
            
            cell.oldpackLabel.text = "\(String(describing: formatter.string(for: singlePack["actual_amount"]!)!)) টাকা"
            cell.newPackLabel.text = "\(String(describing: formatter.string(for: singlePack["amount"]!)!)) টাকা"
            cell.counAmountLabel.text = "\(String(describing: formatter.string(for: singlePack["coin"]!)!)) কয়েন"
            
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        return CGSize(width: collectionView.frame.size.height, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        print("didSelectItemAt")
        let singlePack = redeemPacks[indexPath.item] as! Dictionary<String,Any>
        
        selectedRedeemAmount = "\(String(describing: singlePack["amount"]!))"
        
        print("selectedRedeemAmount..",selectedRedeemAmount)
    }
    
    
    
    
    @IBAction func sendRequestButtonAction(_ sender: Any) {
        
        
        if tkAmountTextField.text?.count != 0 && bKashNoTextField.text?.count != 0 && confirmBkashNoTextField.text?.count != 0{

            //if available coin pack, show them first

            if self.redeemPacks.count > 0{
               
                packCollectionView.reloadData()
                self.shadowView.isHidden = false
                self.redeemPackView.isHidden = false
                
            }else{

                withdrawRequest()
            }
            
        
     
        }else{

            self.view.makeToast("Please provide amount and phone number properly".localized)

        }
    }

    
    func withdrawRequest(){
        
        if  bKashNoTextField.text != confirmBkashNoTextField.text{
            
            self.view.makeToast( "Given numbers are not same!".localized)
            
        }else if selectedChannelType == "None"{
            
            self.view.makeToast( "Please select a payment method!".localized)
            
        }else{
            
            let tkAmount = (tkAmountTextField.text! as NSString).intValue
            
            if tkAmount >= Int32(AppSessionManager.shared.currentUser!.minWithdrawLimit ?? 250) && tkAmount <= Int32(AppSessionManager.shared.currentUser!.maxWithdrawLimit ?? 4999){
                
                if tkAmount <= Int32(AppSessionManager.shared.currentUser!.metadata!.totalCash ?? 0){
                    
                    sendButton.isUserInteractionEnabled = false
                    print("all ok!", selectedChannelType)

                    
                    APIManager.manager.postWithdrawRequest(amount: self.tkAmountTextField.text ?? "0", number: self.bKashNoTextField.text ?? "0", channelType:selectedChannelType ) { (success, msg) in
                        if(success)
                        {
                            self.view.makeToast(msg!)
                            
                            //set cash_withdraw_done event in mixpanel
                            let p: Properties = ["user_id": AppSessionManager.shared.currentUser!.id ?? "",
                                                 "profile_balance": AppSessionManager.shared.currentUser!.metadata!.totalCash ?? "",
                                                 "channel": self.selectedChannelType ,
                                                 "amount": self.tkAmountTextField.text ?? "0"]
                            
                            Mixpanel.mainInstance().track(event: "cash_withdraw_done", properties: p)//
                           
                            
                            self.navigationController?.popViewController(animated: true)
                            self.sendButton.isUserInteractionEnabled = false
                            
                          

                        }
                        else{
                            self.view.makeToast( msg!)
                            self.sendButton.isUserInteractionEnabled = false
                        }
                    }
                    
                }else{
                    
                    self.view.makeToast("You are trying to withdraw more than your balance".localized)
                    
                }
                
                
                
            }else{
                
                self.view.makeToast("Minimum withdraw is \(AppSessionManager.shared.currentUser!.minWithdrawLimit ?? 250) and maximum is \(AppSessionManager.shared.currentUser!.maxWithdrawLimit ?? 4999)" )
               
                
            }
           
           
        }
        
    }
    
    
    func redeemCoin(){
        
        if selectedRedeemAmount != "0"{
            
            APIManager.manager.redeemCoinForCash(amount: selectedRedeemAmount ) { (success, msg) in
    
            if(success)
            {
                self.redeemCoinsButton.isUserInteractionEnabled = true
                self.view.makeToast( msg!)
                
                //set coin_redeem_from_withdraw event in mixpanel
                let p: Properties = ["user_id": AppSessionManager.shared.currentUser!.id ?? "",
                                     "profile_balance": AppSessionManager.shared.currentUser!.metadata!.totalCash ?? "",
                                     "isFromOffer": "yes" ,
                                     "amount": self.tkAmountTextField.text ?? "0"]
                
                Mixpanel.mainInstance().track(event: "coin_redeem_from_withdraw", properties: p)//
                
                self.navigationController?.popViewController(animated: true)
    
            }
            else{
                self.view.makeToast(msg!)
                self.redeemCoinsButton.isUserInteractionEnabled = true
            }
    
        }
            
        }else{
            
            self.view.makeToast("Please select a pack!".localized)
           
        }

    }
    
    @IBAction func withdrawButtonAction(_ sender: Any) {
        
        withdrawRequest()
        
        self.shadowView.isHidden = true
        redeemPackView.isHidden = true
    }
    
    @IBAction func redeemCoinButtonAction(_ sender: Any) {
        
        redeemCoin()
    }
    
    
    @IBAction func pendingWithdrawButtonAction(_ sender: Any) {
        
        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PendingWithdrawViewController") as? PendingWithdrawViewController
        
        
        self.navigationController?.pushViewController(vc!, animated: true)
        
    }
    
    @IBAction func hideRedeemView(_ sender: Any) {
        
        self.shadowView.isHidden = true
        redeemPackView.isHidden = true
    }
    

  
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
}

