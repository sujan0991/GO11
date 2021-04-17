//
//  CompletedMatchViewController.swift
//  GameOf11
//
//  Created by Md.Ballal Hossen on 20/3/21.
//  Copyright © 2021 Tanvir Palash. All rights reserved.
//

import UIKit

class CompletedMatchViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
   
    @IBOutlet weak var navTitleLabel: UILabel!
    
    @IBOutlet weak var matchListTableView: UITableView!
    
    @IBOutlet weak var fromDateTextField: UITextField!
    
    @IBOutlet weak var toDateTextField: UITextField!
    
    @IBOutlet weak var goButton: UIButton!
    
    @IBOutlet weak var lastDateLabel: UILabel!
    
    @IBOutlet weak var noResultLabel: UILabel!
    
    //@IBOutlet weak var datePicker: UIDatePicker!
    
    var matches:[MatchList] = []
    var footBallmatches:[FootBallMatchList] = []
    
    var page_no = 1
    var total_page_no : Int!

    let datePicker = UIDatePicker()

    
    override func viewDidLoad() {
        super.viewDidLoad()

   matchListTableView.register(UINib(nibName: "MatchTableViewCell", bundle: nil), forCellReuseIdentifier: "MatchCell")

    matchListTableView.delegate = self
    matchListTableView.dataSource = self
    matchListTableView.removeEmptyCells()
        
        
        navTitleLabel.text = "MATCH ARCHIVE".localized
   
        datePicker.locale = Locale.init(identifier: "en")
        
        fromDateTextField.inputView = datePicker
        toDateTextField.inputView = datePicker
        
      
        datePicker.addTarget(self, action: #selector(self.handleDatePicker), for: UIControl.Event.valueChanged)
        datePicker.datePickerMode = .date
        
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        } else {
            // Fallback on earlier versions
        }

       
        //set min date
        let dateArchived = UserDefaults.standard.object(forKey: "data_archived") as! String
        
        lastDateLabel.text = String.init(format: "**You can't search after the date of %@".localized, dateArchived)
        
        let archivedDate = dateArchived.toDate(format: "yyyy-MM-dd")
        
        print("archivedDate............",archivedDate)
        
       // datePicker.minimumDate = archivedDate
        datePicker.maximumDate = archivedDate
        
    }
    
    @objc func handleDatePicker() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = Locale(identifier: "en")
        
        if fromDateTextField.isEditing{
            fromDateTextField.text = dateFormatter.string(from: datePicker.date)
          //  fromDateTextField.resignFirstResponder()
        }else if toDateTextField.isEditing{
            toDateTextField.text = dateFormatter.string(from: datePicker.date)
           // toDateTextField.resignFirstResponder()
        }
        
    }

    
    //2
//    @objc func tapDone(sender: Any, datePicker1: UIDatePicker) {
//        print(datePicker1)
//        if let datePicker = self.fromDateTextField.inputView as? UIDatePicker { // 2.1
//            let dateformatter = DateFormatter() // 2.2
//            dateformatter.dateStyle = .short // 2.3
//            self.fromDateTextField.text = dateformatter.string(from: datePicker.date) //2.4
//        }
//        self.fromDateTextField.resignFirstResponder() // 2.5
//    }
    
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            print(".......matches.coun......",matches.count)
            
            return matches.count
            
        }else{
            
            return footBallmatches.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier:"MatchCell") as! MatchTableViewCell
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let match = matches[indexPath.section]
            
            cell.setInfo(match)
            
            cell.statusLabel.text = String.init(format: "COMPLETED".localized )
            cell.statusLabel.textColor = UIColor.init(named: "on_green")!

            if indexPath.section == (matches.count) - 3 {
                
                print("(self.matches.count) - 3")
                
                if total_page_no > page_no { // more items to fetch
                    
                    
                    page_no = page_no + 1
                    
                    getCompletedMatch(pageNo: page_no)
                    
                }else{
                    
                 //   showMoreButton.isHidden = false
                    
                }
            }

            
            return cell

            
        }else{
            
            let match = footBallmatches[indexPath.section]
            
            cell.setFootballInfo(match)
           
            cell.statusLabel.text = String.init(format: "COMPLETED".localized )
            cell.statusLabel.textColor = UIColor.init(named: "on_green")!

            if indexPath.section == (footBallmatches.count) - 3 {
                
                print("(self.matches.count) - 3")
                
                if total_page_no > page_no { // more items to fetch
                    
                    
                    page_no = page_no + 1
                    
                    getCompletedFootBallMatch(pageNo: page_no)
                    
                }else{
                    
                 //   showMoreButton.isHidden = false
                    
                }
            }
            
            return cell

           
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
       
        print("didSelectRowAt............ \(indexPath.section)")
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
            
            let match = matches[indexPath.section]
            
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
            popupVC?.type = .completedContest
            popupVC?.parentMatch = match
            popupVC?.modalPresentationStyle = .fullScreen
            popupVC?.modalTransitionStyle = .crossDissolve
            
            let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            
            self.present(navigationController, animated: true) {
                
//                SVProgressHUD.dismiss()
                print("")
            }

        }else{
            let match = footBallmatches[indexPath.section]
            let popupVC = UIStoryboard.init(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "ContestListViewController") as? ContestListViewController
            popupVC?.type = .completedContest
            popupVC?.parentMatchFootball = match
            popupVC?.modalPresentationStyle = .fullScreen
            popupVC?.modalTransitionStyle = .crossDissolve
            
            let navigationController = UINavigationController.init(rootViewController: popupVC ?? popupVC ?? self)
            navigationController.isNavigationBarHidden = true
            navigationController.modalPresentationStyle = .fullScreen
            
            self.present(navigationController, animated: true) {
                
           //     SVProgressHUD.dismiss()
                print("")
            }
            
        }
    }

    
    @IBAction func goButtonAction(_ sender: Any) {
        
        fromDateTextField.resignFirstResponder()
        toDateTextField.resignFirstResponder()
        
        if  UserDefaults.standard.object(forKey: "selectedGameType") as? String == "cricket"{
        
           
            if !fromDateTextField.text!.isEmpty && !toDateTextField.text!.isEmpty {
                
                getCompletedMatch(pageNo: 1)
                
             
            
            }

        }else{
            if !fromDateTextField.text!.isEmpty && !toDateTextField.text!.isEmpty {
             
              getCompletedFootBallMatch(pageNo: 1)
            }
        }
        
        
    }
    
    func getCompletedMatch(pageNo:Int){
    
        let p_no:String = String(describing: pageNo)

        APIManager.manager.getUserJoinedCompletedMatchListArchive(from_date: self.fromDateTextField.text!, to_date: toDateTextField.text!,page_no: p_no) { (nextMatches,pageCount,msg) in
            
            print("pageCount......",pageCount ?? 0)
            
            if pageCount != 0 {
               
                self.matchListTableView.isHidden = false
                
                if self.page_no == 1{
                    
                    self.total_page_no = pageCount
                    
                    self.matches = nextMatches
                    
                }else{
                    
                    self.matches.append(contentsOf: nextMatches)
                }

                print("self.matches",self.matches.count)
                self.matchListTableView.reloadData()

            }else{
                
                print("pageCount......????",pageCount ?? 0)
                self.noResultLabel.text = msg
                self.matchListTableView.isHidden = true
                

            }
            
        }
    }
    
    func getCompletedFootBallMatch(pageNo:Int){
    
        let p_no:String = String(describing: pageNo)

        APIManager.manager.getUserJoinedCompletedFootBallMatchListArchive(from_date: self.fromDateTextField.text!, to_date: toDateTextField.text!,page_no: p_no) { (nextMatches,pageCount,msg) in
            
            print("pageCount......",pageCount ?? 0)
            
            if pageCount == 0 {
                
                self.noResultLabel.text = msg
                self.matchListTableView.isHidden = true
                
            }else{
                
                self.matchListTableView.isHidden = false
            
            if self.page_no == 1{
                
                self.total_page_no = pageCount
                
                self.footBallmatches = nextMatches
                
            }else{
                
                self.footBallmatches.append(contentsOf: nextMatches)
            }

            print("self.matches",self.matches.count)
            self.matchListTableView.reloadData()
            }
        }
    }

    
    @IBAction func backButtonAction(_ sender: Any) {
        
        self.navigationController?.dismiss(animated: true, completion: {
            
            
        })
        
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
