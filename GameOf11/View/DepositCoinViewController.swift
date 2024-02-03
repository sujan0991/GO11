//
//  DepositCoinViewController.swift
//  DropDown
//
//  Created by MacBook Pro Retina on 2/19/19.
//  Copyright © 2019 Flow_Digital. All rights reserved.
//

import UIKit
import SafariServices
import IQKeyboardManagerSwift


class DepositCoinViewController: BaseViewController,SFSafariViewControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var bDTtoCoinLabel: UILabel!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var addCoinButton: UIButton!
    
    @IBOutlet weak var availableCoinPackLabel: UILabel!
    @IBOutlet weak var packCollectionView: UICollectionView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paymentView: UIView!
    
    
    @IBOutlet weak var selectTermButton: UIButton!
    
    
    @IBOutlet weak var paymentMethodsLabel: UILabel!
    
    @IBOutlet weak var paymentChannelTableView: UITableView!
    
    
    
    @IBOutlet weak var payButton: UIButton!
    
    
    
    @IBOutlet weak var paymentViewHeight: NSLayoutConstraint!
    
    struct Channels {
        let name: String
        let channelName: String
        let max: Int
        let min: Int
        let icon: String
        var selected: Bool
    }
    
    var methodLists: [Channels] = []
    
    
    private var selectedPaymentMethod: Int? {
        didSet {
            paymentChannelTableView.reloadData()
        }
    }
    
    var selectedChannelType = "None"
    var isCoinPack = "no"
    
    var channels:[PaymentChannels] = []
    
    let formatter = NumberFormatter()
    
    var coinPackArray : [Any] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //  IQKeyboardManager.shared.enable = false
        
        placeNavBar(withTitle: "ADD COINS".localized, isBackBtnVisible: true,isLanguageBtnVisible: false, isGameSelectBtnVisible: false,isAnnouncementBtnVisible: false, isCountLabelVisible: false)
        
        self.tabBarController?.tabBar.isHidden = true;
        
        formatter.numberStyle = .decimal
        formatter.locale = NSLocale(localeIdentifier: "bn") as Locale
        
        tkAmountTextField.delegate = self
        
        bDTtoCoinLabel.text = "1 BDT = 50 Coins".localized
        suggestionLabel.text = "Write your amount to get equivalent numbers of coins.Click on the 'ADD COINS' and choose your payment method. Minimum amount is 10 BDT.".localized
        tkAmountTextField.placeholder = "Write amount in BDT to buy Coins".localized
        
        addCoinButton.buttonRound(5, borderWidth: 1.0, borderColor: UIColor.init(named: "brand_red")!)
        addCoinButton.setTitle("ADD COINS".localized, for: .normal)
        
        availableCoinPackLabel.text = "Available Coin Packs".localized
        
        paymentMethodsLabel.text = "Payment Methods".localized
        
        payButton.setTitle("PAY NOW".localized, for: .normal)
        
        
        // tkAmountLabel.becomeFirstResponder()
        
        packCollectionView.delegate = self
        packCollectionView.dataSource = self
        
        
        APIManager.manager.getCoinPack { (status, dataArray, msg) in
            
            
            if status{
                
                self.coinPackArray = dataArray
                
                self.packCollectionView.reloadData()
                
            }else{
                
                self.packCollectionView.isHidden = true
            }
        }
        
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        shadowView.addGestureRecognizer(tap)
        
        //get payment channel
        
        getPaymentChannel()
        
        paymentChannelTableView.delegate = self
        paymentChannelTableView.dataSource = self
        paymentChannelTableView.tableFooterView = UIView()
        paymentChannelTableView.register(UINib(nibName: "PaymentChannelCell", bundle: nil), forCellReuseIdentifier: "paymentChannelCell")
        
    }
    
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
        shadowView.isHidden = true
        paymentView.isHidden = true
        
        if #available(iOS 13, *) {
            if UserDefaults.standard.bool(forKey: "DarkMode"){
                
                overrideUserInterfaceStyle = .dark
                
            }else{
                overrideUserInterfaceStyle = .light
            }
            
        }else{
            
        }
        // to remove previous selection
        
        if selectedPaymentMethod != nil{
            
            selectedPaymentMethod = nil
            selectedChannelType = "None"
            
        }
            
       
    }
    
    
    func getPaymentChannel(){
        
        var lang = ""
        if Language.language == Language.english{
            lang = "EN"
        }else{
            lang = "BN"
        }
        APIManager.manager.getPaymentChannelList(lang: lang) { (status, msg, channelList) in
            
            if status{
                
                self.channels = channelList
                
                
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
    
    func GoBack(){

        self.navigationController?.popViewController(animated: true)
    }

    
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        if tkAmountTextField.text?.count != 0{
            
            self.paymentView.isHidden = false
            self.shadowView.isHidden = false
            
            
            //remove all before inserting
            self.methodLists.removeAll()
            
            // to remove previous selection
            
            if selectedPaymentMethod != nil{
                
                selectedPaymentMethod = nil
                selectedChannelType = "None"
                
            }
            
            for channel in self.channels{
                
                let name = channel.english_name!
                let channelName = channel.channel_name!
                let icon = channel.icon!
                let maxPay = channel.max_pay_amount!
                let minPay = channel.min_pay_amount!
                
                print("method.min amount", minPay)
                let tkAmount = (tkAmountTextField.text! as NSString).intValue
                
                if tkAmount >= minPay && tkAmount <= maxPay{
                    
                    //add in methodlist
                    let new = Channels(name: name, channelName: channelName,max:maxPay ,min: minPay,icon: icon, selected: false)
                    
                    self.methodLists.append(new)

                }

            }
            
            print("self.methodLists.count....", self.methodLists.count)
            
            self.paymentChannelTableView.reloadData()
            
            // set view height based on tableview height
            self.paymentViewHeight.constant = self.paymentChannelTableView.contentSize.height + 180
            
            
            
            self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
            
            let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
            
            
            UIView.animate(withDuration:0.2, animations: {
                
                self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height - self.paymentView.frame.height - bottonSpace, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
                
            }) { _ in
                
                
            }
        }else{
            
            self.view.makeToast("Please give an input")

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return coinPackArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "coinPackCell", for: indexPath) as! CoinPackCollectionViewCell
        
        let singlePack = coinPackArray[indexPath.item] as! Dictionary<String,Any>
        
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
        let singlePack = coinPackArray[indexPath.item] as! Dictionary<String,Any>
        
        tkAmountTextField.text = "\(String(describing: singlePack["amount"]!))"
        
        isCoinPack = "yes"
    }
    
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // return withdrawListArray.count
        return methodLists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"paymentChannelCell") as! PaymentChannelCell

        //cell.radioButton.image =
        // 2
        cell.selectionStyle = .none
        // 3
        let method = methodLists[indexPath.row]
        
        // 4
        let currentIndex = indexPath.row
        // 5
        let selected = currentIndex == selectedPaymentMethod
        // 6
        //cell.configure(method.name,method.icon)
        cell.configure(method.name)
       
        // 7
        cell.isSelected(selected)
        // 8
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        updateSelectedIndex(indexPath.row)

        let method = methodLists[indexPath.row]
        
        selectedChannelType = method.channelName
        
        print("method.name..........", selectedChannelType)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }

    
    private func updateSelectedIndex(_ index: Int) {
        
        selectedPaymentMethod = index
    }
    
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textFieldDidBeginEditing")
        
        if range.location < 2 {
            
            self.packCollectionView.reloadData()
        }
        
        isCoinPack = "no"

        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        paymentView.isHidden = true
        
    }
    
    
    
    @IBAction func selectTermButtonAction(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
    }
    
    @IBAction func termButtonAction(_ sender: Any) {
        
        let urlString = "https://www.gameof11.com/terms-and-conditions"
        
        if let url = URL(string: urlString) {
            
            // UIApplication.shared.open(url, options: [:])
            let svc = SFSafariViewController(url: url)
            
            self.present(svc, animated: true) {
                
                print("open safari")
            }
        }
    }
    
    @IBAction func payNowButtonAction(_ sender: Any) {
        
        if tkAmountTextField.text?.count != 0 {
            
            if selectTermButton.isSelected{
                
                let tkAmount = (tkAmountTextField.text! as NSString).floatValue
                
                print("tkAmount and type ",tkAmount,selectedChannelType)
                
                if selectedChannelType != "None"{
                    
                    APIManager.manager.getInvoice(amount: tkAmount,type:selectedChannelType) { (status, id,url,msg) in
                        
                        print("getInvoice msg",msg!)
                        
                        if status{
                            self.view.makeToast(msg!)
                            
                            print("getInvoice id",id ?? "??",url!)
                            
                            let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BkashPaymentViewController") as? BkashPaymentViewController
                            
                            vc?.urlString = url!
                            vc?.selectedChannelType = self.selectedChannelType
                            vc?.rechargAmount = self.tkAmountTextField.text!
                            vc?.isCoinPack = self.isCoinPack
                            
                            self.navigationController?.pushViewController(vc!, animated: true)
                            
                        }
                        else{
                            self.view.makeToast(msg!)
                        }
                        
                    }
                    
                }else{
                    
                    self.view.makeToast("Please select a payment method")

                }
                
            }else{
                
                self.view.makeToast("Please accept terms & conditions")

            }
        }else{
            
            self.view.makeToast("No amount is given")

        }
    }
    
}
