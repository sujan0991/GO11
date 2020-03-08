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


class DepositCoinViewController: BaseViewController,SFSafariViewControllerDelegate,UICollectionViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    
    @IBOutlet weak var bDTtoCoinLabel: UILabel!
    
    @IBOutlet weak var suggestionLabel: UILabel!
    
    @IBOutlet weak var tkAmountTextField: UITextField!
    @IBOutlet weak var addCoinButton: UIButton!
    
    @IBOutlet weak var availableCoinPackLabel: UILabel!
    @IBOutlet weak var packCollectionView: UICollectionView!
    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var paymentView: UIView!
    
    @IBOutlet weak var selectBkashButton: UIButton!
    @IBOutlet weak var selectCardButton: UIButton!
    @IBOutlet weak var selectTermButton: UIButton!
    
    
    @IBOutlet weak var paymentMethodsLabel: UILabel!
    @IBOutlet weak var bKashLabel: UILabel!
    @IBOutlet weak var cardLabel: UILabel!
    
    @IBOutlet weak var payButton: UIButton!
    
    
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
        suggestionLabel.text = "You can add coins to your profile from here. As highlighted that 1 BDT = 50 coins which means if you want to add 1000 coins to your profile then write 20 in the input field. Then Click 'Add Coins\' and choose your payment method.  After that, required money will be deducted from your given payment account via our secured payment gateway. The coins will be added to your profile instantly on completion of successful payment. Minimum amount of adding coins is 10 BDT.".localized
        tkAmountTextField.placeholder = "Write amount in BDT to buy Coins".localized
        
        addCoinButton.setTitle("ADD COINS".localized, for: .normal)
        
        availableCoinPackLabel.text = "Available Coin Packs".localized
        
        paymentMethodsLabel.text = "Payment Methods".localized
        bKashLabel.text = "bKash Digital Payment".localized
        cardLabel.text = "Credit/Debit Cards/Mobile\nBanking/Online Banking".localized
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        shadowView.isHidden = true
        paymentView.isHidden = true
    }
    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    
    
    
    @IBAction func addCoinButtonAction(_ sender: Any) {
        
        if tkAmountTextField.text?.count != 0{
            
            self.paymentView.isHidden = false
            self.shadowView.isHidden = false
            self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
            
            let bottonSpace = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 1.0
            
            
            UIView.animate(withDuration:0.2, animations: {
                
                
                self.paymentView.frame = CGRect(x: 0, y:self.view.frame.height - self.paymentView.frame.height - bottonSpace, width: self.paymentView.frame.width, height: self.paymentView.frame.height)
                
            }) { _ in
                
                
            }
            
            
            
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
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        print("textFieldDidBeginEditing")
        
        if range.location < 2 {
            
            self.packCollectionView.reloadData()
        }
        return true
    }
    
    @objc func handleTap(_ sender: UITapGestureRecognizer? = nil) {
        
        shadowView.isHidden = true
        paymentView.isHidden = true
        
    }
    
    @IBAction func selectBkashButtonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if selectCardButton.isSelected{
            
            selectCardButton.isSelected = false
        }
    }
    
    @IBAction func selectCardbuttonAction(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        
        if selectBkashButton.isSelected{
            
            selectBkashButton.isSelected = false
        }
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
                var type = "ghoori"
                if selectBkashButton.isSelected{
                    
                    type = "ghoori"
                    
                }else if selectCardButton.isSelected{
                    
                    type = "foster"
                }
                
                print("tkAmount and type ",tkAmount,type)
                
                APIManager.manager.getInvoice(amount: tkAmount,type:type) { (status, id,url,msg) in
                    
                    print("getInvoice msg",msg!)
                    
                    if status{
                        self.view.makeToast(msg!)
                        
                        print("getInvoice id",id ?? "??",url!)
                        
                        let vc = UIStoryboard.init(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "BkashPaymentViewController") as? BkashPaymentViewController
                        
                        vc?.urlString = url!
                        
                        self.navigationController?.pushViewController(vc!, animated: true)
                        
                    }
                    else{
                        self.view.makeToast(msg!)
                    }
                    
                }
                
            }
        }
    }
    
}
