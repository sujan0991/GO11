//
//  APIManager
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import Gloss
import SVProgressHUD

extension String{
    func isTrue() -> Bool {
        return self == "True"
    }
}

enum RequestActionType:String {
    case accept = "add"
    case reject = "cancel"
    case remove = "remove"
}
enum RequestAction:String {
    case accept = "accepted"
    case reject = "rejected"
}

struct API_K {
    static let DEVICE_TYPE = "iOS"
    static let API_KEY = "base64:8WGdd0uX3GtRtTxeOyuHd3864Mqfc6C/cbhzpEZUdxA="
    static let BaseUrlStr:String =  "http://18.224.1.221/" //"http://159.65.128.173/" //
    //http://159.65.128.173/
    //http://18.224.1.221/

    static let BaseURL = URL(string:"\(BaseUrlStr)api/")!
    
    static let LOGIN = "login"//
    static let LOGOUT = "logout"//

    static let TOKEN_VALIDATION = "validate-token"

 
    static let REGISTER = "registration"
    static let MY_PROFILE = "user"//
    static let OTHER_PROFILE = "othersProfile"
    static let UPLOAD_PROFILE_PICTURE = "uploadProfilePicture"
    static let UPLOAD_COVER_PHOTO = "uploadCoverPhoto"
    static let UPDATE_PROFILE = "updateProfile"
    static let GET_AVATAR_LIST = "avatars"
    static let UPDATE_AVATAR = "update-avatar"
    static let CHANGE_PASSWORD = "change-password"
    static let FORGOT_PASSWORD = "forgot-password"
    static let VERIFY_PROFILE = "user/profile-verify"
    static let UPDATE_GCM_TOKEN = "update-gcm-registration-key"
    
    static let GET_NEXT_MATCH_LIST = "upcoming-matches"//
    static let GET_LIVE_MATCH_LIST = "live-matches"//
    
    static let GET_ACTIVE_CONTEST_LIST = "active-contests"//
    static let GET_MATCH_SQUAD = "get-team-players"//
    static let GET_USERS_TEAM_FOR_MATCH = "get-user-teams"//
    static let GET_USERS_TEAM_PLAYERS = "get-user-team-players"
    static let POST_TEAM = "user-team/create"
    static let JOIN_CONTEST = "user-contest/join"
    
    static let GET_UPCOMING_CONTEST_MATCH_LIST = "user/upcoming-match-contests"//
    static let GET_LIVE_CONTEST_MATCH_LIST = "user/live-match-contests"//
    static let GET_COMPLETED_CONTEST_MATCH_LIST = "user/completed-match-contests"//
    static let GET_USER_JOINRD_CONTEST_LIST = "user/match/contests"//
    
    static let GET_LEADERBOARD_CONTEST = "contest/leaderboard"//
    static let GET_LEADERBOARD_BREAKDOWN = "contest/leaderboard/point-breakdown"//
    static let GET_MATCH_SCORE = "live-match-score"//
    
    static let CREATE_OTP = "createOtp"
    static let GET_PASSWORD = "retrievePassword"
  
    static let REDEEM_COIN = "redeem-coin"
    static let WITHDRAW_REQUEST = "withdraw-request"
    static let GET_WITHDRAW_LIST = "withdrawals-list"
    static let GET_CASH_EQ_COIN = "cash-equivalent-coin"
    static let GET_COIN_PACKS = "coin-packs"
   
    
}

struct API_STRING {
    
    static let  PROPILE_REVIEW_ALERT = "Please set up your profile"
    static let  LOGIN_VALIDATION_TEXT = "The duplicate key value is"
    static let  NOTE_ADD_SUCCESS = "Note sent successfully"
    static let  COMMENT_ADD_SUCCESS = "Feedback sent successfully"
    static let  POST_ADD_SUCCESS = "Upload ad successful"
    static let  POST_ADD_FAIL = "Upload ad failed"

    static let  POST_EDIT_SUCCESS = "Post edited successfully"
    static let  POST_EDIT_FAIL = "Post edit failed"

    static let  NOTE_ADD_FAIL = "Note sending failed"
    static let  COMMENT_ADD_FAIL = "Feedback sending failed"
    
    static let  DELETE_ADD_SUCCESS = "Ad delete successful"
    static let  DELETE_ADD_FAIL = "Ad delete failed"
}

struct APP_STRING {
   
    static let  SERVER_ERROR = "Something went wrong! Please, try later"
    static let PROGRESS_TEXT = "Please wait..."
    static let CommentPlaceHolder = "Write your comment"
    static let PostPlaceHolder = "Details"
    static let CategoryPlaceHolder = "Category"
    static let notePlaceHolder = "Write your note"
    static let EmptyDataText = "No ads are available"
}

enum ResponseType {
    case success
    case fail
    case invalid
}

class APIManager: NSObject {
    
    /*
     *-------------------------------------------------------
     * MARK:- singletone initialization
     *-------------------------------------------------------
     */
    
    private struct Static {
        static var intance: APIManager? = nil
    }
    
    private static var __once: () = {
        Static.intance = APIManager()
    }()
    
    class var manager: APIManager {
        _ = APIManager.__once
        return Static.intance!
    }
    
    func login(userName:String, password:String, withCompletionHandler completion:(( _ status: Bool,_ authToken:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["phone":userName,
                                      "password":password,
                                      "gcm_registration_key":""
                                    ] 
 
        Request(.post, API_K.LOGIN, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    var isSuccess:Bool?
                    
                    isSuccess = jsonDic["status"] as? Bool ?? true
                   
                    if !isSuccess!{
                        let msg:String? = json["message"].stringValue

                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["access_token"].stringValue

                        completion?(true,token,"Success")
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
   
    func logOut(completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.post, API_K.LOGOUT, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func register(userName:String ,fullName:String, email:String,country:String,phone:String, password:String, withCompletionHandler completion:(( _ status: Bool,_ token:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["userName":userName,
                                      "password":password,
                                      "pushToken":"1234567890",
                                      "deviceType":"iphone",
                                      "email":email,
                                      "latitude":"23.90",
                                      "longitude":"90.23",
                                      "fullName":fullName,
                                      "avatar":"",
                                      "country":country,
                                      "phone":phone]
        
        
        Request(.post, API_K.REGISTER, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue

                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["authToken"].stringValue
                        completion?(true,token,msg)
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
    
    func getOtp(email:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["email":email]
        
        Request(.post, API_K.CREATE_OTP, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    func getMyProfile(completion:(( _ status: Bool,_ user:UserModel?, _ message: String?)->Void)?) {
        
        getDataModel(method: API_K.MY_PROFILE) { (sts, dataModel,msg) in
            if sts{
                
                if let jsA = dataModel{
                    if let histories = UserModel.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    func getOtherProfile(_ userId:String, withCompletionHandler completion:(( _ status: Bool,_ user:UserModel?, _ message: String?)->Void)?) {
        let param:[String:Any] = ["seekedUserId":userId]
        getDataModel(param, method: API_K.OTHER_PROFILE) { (sts, dataModel,msg) in
            if sts{
                if let jsA = dataModel{
                    if let histories = UserModel.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    
    func getAvatarList(completion:(( _ avatars: [Avatar])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_AVATAR_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let avatarArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let avatars = [Avatar].from(jsonArray: avatarArray) {
                                
                                completion?(avatars)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    func updateProfile(fullName:String,country:String,phone:String, aboutme:String, withCompletionHandler completion:(( _ status: Bool,_ token:String?, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["fullName":fullName,
                                      "country":country,
                                      "phone":phone,
                                      "aboutMe":aboutme]
        
        Request(.post, API_K.UPDATE_PROFILE, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        let token:String = json["authToken"].stringValue
                        completion?(true,token,msg)
                    }
                }
                else {
                    completion?(false,nil,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
    
    
    func updateAvatarWith(avatarId:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["avatar_id":avatarId]
        
        Request(.patch, API_K.UPDATE_AVATAR, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func updateGCMKey(key:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["gcm_registration_key":key]
        
        Request(.patch, API_K.UPDATE_GCM_TOKEN, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func redeemCoinForCash(amount:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["amount":amount]
        
        Request(.post, API_K.REDEEM_COIN, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    func postWithdrawRequest(amount:String, number : String , withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["amount":amount, "transaction_number": number ]
        
        Request(.post, API_K.WITHDRAW_REQUEST, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    
    func changePasswordWith(oldPassword:String, newPassword : String , withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["old_password":oldPassword, "new_password": newPassword ]
        
        Request(.patch, API_K.CHANGE_PASSWORD, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
                
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?(false,nil)
            }
        })
    }
    
    func resetPassword(otp:String, password:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["otp":otp,
                                      "password":password,
                                      "passwordConfirmation":password]
        
        Request(.post, API_K.GET_PASSWORD, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["success"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    
    
    func getUpcomingMatchList(completion:(( _ matches: [MatchList])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_NEXT_MATCH_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let matchArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let matches = [MatchList].from(jsonArray: matchArray) {
                                completion?(matches)
                            } else {
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    func getLiveMatchList(completion:(( _ matches: [MatchList])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_LIVE_MATCH_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let matchArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let matches = [MatchList].from(jsonArray: matchArray) {
                                
                                completion?(matches)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    
    func getUserJoinedUpcomingMatchList(completion:(( _ matches: [MatchList])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_UPCOMING_CONTEST_MATCH_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let matchArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let matches = [MatchList].from(jsonArray: matchArray) {
                                completion?(matches)
                            } else {
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    func getUserJoinedLiveMatchList(completion:(( _ matches: [MatchList])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_LIVE_CONTEST_MATCH_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let matchArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let matches = [MatchList].from(jsonArray: matchArray) {
                                completion?(matches)
                            } else {
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    func getUserJoinedCompletedMatchList(completion:(( _ matches: [MatchList])->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        Request(.get, API_K.GET_COMPLETED_CONTEST_MATCH_LIST, parameters: nil)?.responseJSON(completionHandler: { (responseData) in
            print(responseData)
            
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    
                    if !isSuccess{
                        completion?([])
                    }
                    else{
                        if let matchArray = json["data"].arrayObject as? [Gloss.JSON] {
                            
                            if let matches = [MatchList].from(jsonArray: matchArray) {
                                
                                completion?(matches)
                                
                            } else {
                                
                                completion?([])
                            }
                        }
                    }
                }
                else {
                    completion?([])
                }
            case .failure( _):
                SVProgressHUD.dismiss()
                completion?([])
            }
        })
    }
    func getTeamForMatch(matchId:String,completion:(( _ status: Bool,_ user:CreatedTeamList?, _ message: String?)->Void)?) {
        
        let params:[String:String] = ["match_id":matchId]
        getResponseDataModel(params, method: API_K.GET_USERS_TEAM_FOR_MATCH) { (sts, dataModel,msg) in
            
            if sts{
                if let jsA = dataModel{
                    if let histories = CreatedTeamList.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    
    func getActiveContestList(matchId:String,completion:(( _ status: Bool,_ user:ContestList?, _ message: String?)->Void)?) {
      
        let params:[String:String] = ["match_id":matchId]
        getDataModel(params, method: API_K.GET_ACTIVE_CONTEST_LIST) { (sts, dataModel,msg) in
            
            if sts{
                
                if let jsA = dataModel{
                    if let histories = ContestList.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    
    func postTeam(params: UsersFantasyTeam, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        
        RequestForJson(.post, API_K.POST_TEAM, parameters: params.toJSON())?.responseJSON(completionHandler: { (responseData) in
            
            print("Created Team data", responseData)
            
            switch responseData.result {
                
            case .success(let value):
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,msg)
                    }
                    else{
                        completion?(true,msg)
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    func joinInContestWith(contestId:String, teamId:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        
        let params:[String:String] = ["contest_id":contestId,
                                      "user_team_id":teamId,
                                      ]
        
        Request(.post, API_K.JOIN_CONTEST, parameters: params)?.responseJSON(completionHandler: { (responseData) in
            switch responseData.result {
            case .success(let value):
                print(value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                if let jsonDic = json.dictionaryObject {
                    
                    var isSuccess:Bool?
                    
                    isSuccess = jsonDic["status"] as? Bool ?? true
                    
                    if !isSuccess!{
                        let msg:String? = json["message"].stringValue
                        
                        completion?(false,msg)
                    }
                    else{
                        
                        completion?(true,"Success")
                    }
                }
                else {
                    completion?(false,nil)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,error.localizedDescription)
            }
        })
    }
    
    func getJoinedActiveContestList(matchId:String,completion:(( _ status: Bool,_ user:ContestList?, _ message: String?)->Void)?) {
        
        let params:[String:String] = ["match_id":matchId]
        getDataModel(params, method: API_K.GET_USER_JOINRD_CONTEST_LIST) { (sts, dataModel,msg) in
            
            if sts{
                
                if let jsA = dataModel{
                    if let histories = ContestList.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    func getLeaderBoardOfCntest(contestId:String,pageNo:String,completion:(( _ status: Bool,_ data:LeaderBoardData?, _ message: String?)->Void)?) {

        let params:[String:String] = ["contest_id":contestId,"page_number":pageNo]

        getDataModel(params, method: API_K.GET_LEADERBOARD_CONTEST) { (sts, dataModel,msg) in

            if sts{

                if let jsA = dataModel{
                    if let histories = LeaderBoardData.init(json: jsA) {
                        completion?(true,histories,msg)

                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    func getMatchScore(matchId:String,completion:(( _ status: Bool,_ data:MatchScoreData?, _ message: String?)->Void)?) {
        
        let params:[String:String] = ["match_id":matchId]
        
        getDataModel(params, method: API_K.GET_MATCH_SCORE) { (sts, dataModel,msg) in
            
            if sts{
                
                if let jsA = dataModel{
                    if let histories = MatchScoreData.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    func getBreakDownOfCntest(match_id:String,user_team_id:String,completion:(( _ status: Bool,_ data:BreakDownData?, _ message: String?)->Void)?) {
        
        let params:[String:String] = ["match_id":match_id,"user_team_id":user_team_id]
        
        getDataModel(params, method: API_K.GET_LEADERBOARD_BREAKDOWN) { (sts, dataModel,msg) in
            
            if sts{
                
                if let jsA = dataModel{
                    if let histories = BreakDownData.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    
    
    func getMatchSquad(matchId:String,completion:(( _ status: Bool,_ user:MatchSquadData?, _ message: String?)->Void)?) {
        
        let params:[String:String] = ["match_id":matchId]
        getDataModel(params, method: API_K.GET_MATCH_SQUAD) { (sts, dataModel,msg) in
            
            if sts{
                
                if let jsA = dataModel{
                    if let histories = MatchSquadData.init(json: jsA) {
                        completion?(true,histories,msg)
                        
                    } else {
                        completion?(false,nil,msg)
                    }
                }
                else{
                    completion?(false,nil,msg)
                }
            }
            else{
                completion?(false,nil,msg)
            }
        }
    }
    
    
    func getDataModel(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: Gloss.JSON?,_ msg:String?)->Void)?) {
      
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        Request(.get, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            
            switch responseData.result {
            case .success(let value):
                print("responseData",value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                   
                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        
                        if let tempArray = json["data"].dictionaryObject {
                            completion?(true,tempArray,msg)
                        }
                        else{
                            completion?(false,nil,msg)
                        }
                    }
                }
                else {
                    completion?(false,nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }

    func getResponseDataModel(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: Gloss.JSON?,_ msg:String?)->Void)?) {
        
        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
        Request(.get, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
            
            switch responseData.result {
            case .success(let value):
                print("responseData",value)
                SVProgressHUD.dismiss()
                let json = JSON(value)
                
                if let jsonDic = json.dictionaryObject {
                    
                    let isSuccess:Bool = jsonDic["status"] as! Bool
                    let msg:String = json["message"].stringValue
                    
                    if !isSuccess{
                        completion?(false,nil,msg)
                    }
                    else{
                        
                        if let tempArray = json.dictionaryObject {
                            completion?(true,tempArray,msg)
                        }
                        else{
                            completion?(false,nil,msg)
                        }
                    }
                }
                else {
                    completion?(false,nil,APP_STRING.SERVER_ERROR)
                }
            case .failure(let error):
                SVProgressHUD.dismiss()
                completion?(false,nil,error.localizedDescription)
            }
        })
    }
}
//
//struct API_K_TRIP {
//    static let  GET_TRIP_LOCATION = "getLocations"
//    static let  CREATE_TRIP = "createTrip"
//    static let GET_TRIP_LIST = "getMyTrip"
//    static let REMOVE_TRIP = "deleteTrip"
//    static let EDIT_TRIP = "updateTrip"
//    static let INVITED_TRIP_LIST = "getInvitedTrip"
//    static let GET_TRIP_DETAILS = "getTripDetails"
//}
//// Trip Module
//extension APIManager{
//    // Create Trip
//
////    func createTrip(tripTitle:String,tripDescription:String,selFriend:[UserModel],location:SearchPlaceModel?,locationDetails:SearchPlaceDetailModel?,fromDate:String?,toDate:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
////        var ids:[String] = []
////        for frnd:UserModel in selFriend {
////            if let uid = frnd.user_id{
////                ids.append("\(uid)")
////            }
////        }
////        let idStr = ids.joined(separator:",")
////        let lat = "\(locationDetails?.geometry?.location?.lat ?? 0)"
////        let lng = "\(locationDetails?.geometry?.location?.lng ?? 0)"
////        let  imgStr = "https://maps.googleapis.com/maps/api/staticmap?center=\(lat),\(lng)&zoom=12&size=600x400"
////
////        let params:[String:Any] = ["locationName":location?.strFormat?.displayName() ?? "Canada",
////                                   "locationImage":imgStr,
////                                   "latitude":lat,
////                                   "longitude":lng,
////                                   "tripTitle":tripTitle,
////                                   "startDate":fromDate ?? "",
////                                   "endDate":toDate ?? "",
////                                   "friendList":idStr,
////                                   "description":tripDescription]
////        submit(param: params, method: API_K_TRIP.CREATE_TRIP) { (sts, msg) in
////            completion?(sts,msg)
////        }
////    }
//
//    //Remove Trip
//    func removeTrip(tripId:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
//        submit(param: ["tripId":tripId], method: API_K_TRIP.REMOVE_TRIP) { (sts, msg) in
//            completion?(sts,msg)
//        }
//    }
//
//    //Edit trip
//
////    func updateTrip(tripId:String,tripTitle:String,tripDescription:String,selFriend:[UserModel],location:SearchPlaceModel?,locationDetails:SearchPlaceDetailModel?,fromDate:String?,toDate:String?,locationImage:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
////        var ids:[String] = []
////        for frnd:UserModel in selFriend {
////            if let uid = frnd.user_id{
////                ids.append("\(uid)")
////            }
////        }
////        let idStr = ids.joined(separator:",")
////
////        let params:[String:Any] = ["tripId":tripId,
////                                   "locationName":location?.strFormat?.displayName() ?? "Canada",
////                                   "locationImage":locationImage ?? "",
////                                   "latitude":"\(locationDetails?.geometry?.location?.lat ?? 0)",
////            "longitude":"\(locationDetails?.geometry?.location?.lng ?? 0)",
////            "tripTitle":tripTitle,
////            "startDate":fromDate ?? "",
////            "endDate":toDate ?? "",
////            "friendList":idStr,
////            "description":tripDescription]
////        submit(param: params, method: API_K_TRIP.CREATE_TRIP) { (sts, msg) in
////            completion?(sts,msg)
////        }
////    }
//
//
//
//    //Get trip list
//    func getTripList(completion:(( _ trips: [TripModel])->Void)?) {
//
//        getList(method: API_K_TRIP.GET_TRIP_LIST) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    //Invited Trip list
//    func getInvitedTripList(completion:(( _ trips: [TripModel])->Void)?) {
//
//        getList(method: API_K_TRIP.INVITED_TRIP_LIST) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    //Get Locations
//    func getTripLocationList(completion:(( _ trips: [LocationModel])->Void)?) {
//
//        getDataList(method: API_K_TRIP.GET_TRIP_LOCATION) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [LocationModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    func getTripDetails(tripId:String, withCompletionHandler completion:(( _ frnds: [TripModel])->Void)?) {
//
//        let params:[String:Any] = ["tripId":tripId]
//        getList(params, method: API_K_TRIP.GET_TRIP_DETAILS) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//
//    }
//
//    func getDataList(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: [Gloss.JSON]?)->Void)?) {
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
//            switch responseData.result {
//            case .success(let value):
//                print(value)
//                SVProgressHUD.dismiss()
//                let json = JSON(value)
//
//                if let jsonDic = json.dictionaryObject {
//                    let isSuccess:Bool = jsonDic["success"] as! Bool
//
//                    if !isSuccess{
//                        completion?(false,nil)
//                    }
//                    else{
//                        if let locationsArray = json["data"]["lists"].arrayObject as? [Gloss.JSON] {
//                            completion?(true,locationsArray)
//                        }
//                        else{
//                            completion?(false,nil)
//                        }
//                    }
//                }
//                else {
//                    completion?(false,nil)
//                }
//            case .failure( _):
//                SVProgressHUD.dismiss()
//                completion?(false,nil)
//            }
//        })
//    }
//
//
//    func getList(_ param:[String:Any]? = nil,method:String, withCompletionHandler completion:(( _ status: Bool, _ data: [Gloss.JSON]?)->Void)?) {
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
//            switch responseData.result {
//            case .success(let value):
//                print(value)
//                SVProgressHUD.dismiss()
//                let json = JSON(value)
//
//                if let jsonDic = json.dictionaryObject {
//                    let isSuccess:Bool = jsonDic["success"] as! Bool
//
//                    if !isSuccess{
//                        completion?(false,nil)
//                    }
//                    else{
//                        if let locationsArray = json["data"].arrayObject as? [Gloss.JSON] {
//                            completion?(true,locationsArray)
//                        }
//                        else{
//                            completion?(false,nil)
//                        }
//                    }
//                }
//                else {
//                    completion?(false,nil)
//                }
//            case .failure( _):
//                SVProgressHUD.dismiss()
//                completion?(false,nil)
//            }
//        })
//    }
//
//    func submit(param:[String:Any],method:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        Request(.post, method, parameters: param)?.responseJSON(completionHandler: { (responseData) in
//            switch responseData.result {
//            case .success(let value):
//                print(value)
//                SVProgressHUD.dismiss()
//                let json = JSON(value)
//
//                if let jsonDic = json.dictionaryObject {
//
//                    let isSuccess:Bool = jsonDic["success"] as! Bool
//                    let msg:String = json["message"].stringValue
//
//                    if !isSuccess{
//                        completion?(false,msg)
//                    }
//                    else{
//
//                        completion?(true,msg)
//                    }
//                }
//                else {
//                    completion?(false,nil)
//                }
//            case .failure(let error):
//                SVProgressHUD.dismiss()
//                completion?(false,error.localizedDescription)
//            }
//        })
//    }
//}
//
//struct API_K_TASK {
//    static let  CREATE_TASK = "createTask"
//    static let  GET_ALL_TRIP_TASK = "getProposedAllTripTask"
//    static let GET_TRIP_TASK = "getProposedAllTripTask"
//    static let ACCEPT_REJECT_TASK = "acceptRejectTask"
//    static let GET_ACCEPTED_TASK = "acceptedTaskList"
//    static let GET_TASK_DETAILS = "getProposedTask"
//    static let UPLOAD_TASK_FEEDBACK_IMAGE = "uploadFeedbackImage"
//    static let UPLOAD_TASK_FEEDBACK_VIDEO = "uploadFeedbackVideo"
//    static let ADD_FEEDBACK = "addFeedback"
//}
//// task module
//extension APIManager {
//    //Create Task
////    func createTask(tripId:String,tasks:[String],visibility:Status, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
////
////
////        let params:[String:Any] = ["tripId":tripId,
////                                   "tasks":tasks,
////                                   "private":visibility == .showAll ? "public":"private"]
////        submit(param: params, method: API_K_TASK.CREATE_TASK) { (sts, msg) in
////            completion?(sts,msg)
////        }
////    }
//
//    //Get pending tasks
//    func getPendingTasks(completion:(( _ trips: [TripModel])->Void)?) {
//
//        getList(method: API_K_TASK.GET_ALL_TRIP_TASK) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//
//    //Get task Details
//    func getTaskDetails(tripId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
//
//        let params:[String:Any] = ["tripId":tripId]
//        getList(params,method: API_K_TASK.GET_TASK_DETAILS) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    func acceptRejectTask(tripId:String,friendId:String,type:RequestAction, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        let params:[String:String] = ["tripId":tripId,
//                                      "action":type.rawValue,
//                                      "friendId":friendId]
//
//        Request(.post, API_K_TASK.ACCEPT_REJECT_TASK, parameters: params )?.responseJSON(completionHandler: { (responseData) in
//            switch responseData.result {
//            case .success(let value):
//                print(value)
//                SVProgressHUD.dismiss()
//                let json = JSON(value)
//                if let jsonDic = json.dictionaryObject {
//
//                    let isSuccess:Bool = jsonDic["success"] as! Bool
//                    let msg:String = json["message"].stringValue
//
//                    if !isSuccess{
//                        completion?(false,msg)
//                    }
//                    else{
//
//                        completion?(true,msg)
//                    }
//                }
//                else {
//                    completion?(false,nil)
//                }
//            case .failure( _):
//                SVProgressHUD.dismiss()
//                completion?(false,nil)
//            }
//        })
//    }
//
//    //Get pending tasks
//    func getAcceptedTasks(completion:(( _ trips: [TripModel])->Void)?) {
//
//        getList(method: API_K_TASK.GET_ACCEPTED_TASK) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//    func uploadTaskPhoto(_ image:UIImage?,taskId:String, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        let params:[String:String] = ["taskId":taskId]
//
//        UploadRequest(
//            .post,API_K_TASK.UPLOAD_TASK_FEEDBACK_IMAGE,
//            multipartFormData: { multipartFormData in
//                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
//                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
//                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
//                }
//
//                for (key, value) in params {
//                    let val:String = value
//                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
//                }
//        },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON{ (response) -> Void in
//                        switch response.result{
//                        case .success(let value):
//                            let json = JSON(value)
//                            print(json)
//
//                            if let jsonDic = json.dictionaryObject {
//                                let status:Bool = jsonDic["success"] as! Bool
//                                let mssg = jsonDic["message"] as! String
//                                let imagedict:[String:String] = jsonDic["data"] as! [String : String]
//                                completion?(status,mssg)
///*
//                               if let imageName =  imagedict["imageName"] {
//                                completion?(status,mssg,imageName)
//                                }
//                               else{
//                                completion?(status,mssg,nil)
//                                }*/
//                            }
//                            else {
//                                completion?(false,APP_STRING.SERVER_ERROR)
//                            }
//                            SVProgressHUD.dismiss()
//
//                        case .failure(let error):
//                            SVProgressHUD.dismiss()
//                            completion?(false,APP_STRING.SERVER_ERROR)
//                        }
//                    }
//                case .failure(let encodingError):
//                    SVProgressHUD.dismiss()
//                    completion?(false,APP_STRING.SERVER_ERROR)
//                }
//        })
//    }
//
//    func uploadTaskVideo(_ videoURL:URL?,taskId:String, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        let params:[String:String] = ["taskId":taskId]
//
//        UploadRequest(
//            .post,API_K_TASK.UPLOAD_TASK_FEEDBACK_VIDEO,
//            multipartFormData: { multipartFormData in
//                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
//                 multipartFormData.append(videoURL!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
//
//                for (key, value) in params {
//                    let val:String = value
//                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
//                }
//        },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON{ (response) -> Void in
//                        switch response.result{
//                        case .success(let value):
//                            let json = JSON(value)
//                            print(json)
//
//                            if let jsonDic = json.dictionaryObject {
//                                let status:Bool = jsonDic["success"] as! Bool
//                                let mssg = jsonDic["message"] as! String
//                                let videodict:[String:String] = jsonDic["data"] as! [String : String]
//
//                                NSLog("jsonDIC in uploadfeedbackVideo %@", jsonDic)
//
//                                completion?(status,mssg)
//                                /*
//                                 if let imageName =  imagedict["imageName"] {
//                                 completion?(status,mssg,imageName)
//                                 }
//                                 else{
//                                 completion?(status,mssg,nil)
//                                 }*/
//                            }
//                            else {
//                                completion?(false,APP_STRING.SERVER_ERROR)
//                            }
//                            SVProgressHUD.dismiss()
//
//                        case .failure(let error):
//                            SVProgressHUD.dismiss()
//                            completion?(false,APP_STRING.SERVER_ERROR)
//                        }
//                    }
//                case .failure(let encodingError):
//                    SVProgressHUD.dismiss()
//                    completion?(false,APP_STRING.SERVER_ERROR)
//                }
//        })
//    }
//
//
//    func updateFeedback(taskId:String,imageUrl:String,videoUrl:String, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
//
//        let params:[String:Any] = ["taskId":taskId,"imageUrl":imageUrl,"videoUrl":videoUrl]
//
//
//        submit(param: params, method: API_K_TASK.ADD_FEEDBACK) { (sts, msg) in
//            completion?(sts,msg)
//        }
//    }
//}
//
//struct API_K_PROFILE {
//    static let MY_PROFILE = "user"
//    static let OTHER_PROFILE = "othersProfile"
//    static let UPLOAD_PROFILE_PICTURE = "uploadProfilePicture"
//    static let UPLOAD_COVER_PHOTO = "uploadCoverPhoto"
//    static let UPDATE_PROFILE = "updateProfile"
//}
//extension APIManager{
//

//    func upload(_ image:UIImage?,type:PictureSelectType, withCompletionHandler completion:(( _ status:Bool, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        let params:[String:String] = [:]
//
//        UploadRequest(
//            .post,
//            (type == .profilepicture) ? API_K_PROFILE.UPLOAD_PROFILE_PICTURE:API_K_PROFILE.UPLOAD_COVER_PHOTO,
//            multipartFormData: { multipartFormData in
//                // multipartFormData.appendBodyPart(fileURL: fileURL!, name: "unicorn")
//                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
//                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
//                }
//
//                for (key, value) in params {
//                    let val:String = value
//                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
//                }
//        },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON{ (response) -> Void in
//                        switch response.result{
//                        case .success(let value):
//                            let json = JSON(value)
//                            print(json)
//
//                            if let jsonDic = json.dictionaryObject {
//                                let status:Bool = jsonDic["success"] as! Bool
//                                let mssg = jsonDic["message"] as! String
//                                completion?(status,mssg)
//                            }
//                            else {
//                                completion?(false,APP_STRING.SERVER_ERROR)
//                            }
//                            SVProgressHUD.dismiss()
//
//                        case .failure(let error):
//                            SVProgressHUD.dismiss()
//                            completion?(false,APP_STRING.SERVER_ERROR)
//                        }
//                    }
//                case .failure(let encodingError):
//                    SVProgressHUD.dismiss()
//                    completion?(false,APP_STRING.SERVER_ERROR)
//
//                }
//        })
//
//    }
//}
//
//struct API_K_PASSPORT {
//    static let  GET_MY_PASSPORTS = "getPassports"
//    static let  GET_TRIP_PASSPORT = "getPassportforTrip"
//    static let GET_PASSPORT_DETAILS = "getPassportDetails"
//    static let CONFIRM_PASSPORT = "confirmPassport"
//}
//// task module
//extension APIManager {
//    //Get Passport
//    func getMyPassports(completion:(( _ trips: [TripModel])->Void)?) {
//
//        getList(method: API_K_PASSPORT.GET_MY_PASSPORTS) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//
//    //Get task Details
//    func getPassportDetails(tripId:String,friendId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
//
//        let params:[String:Any] = ["tripId":tripId,
//                                   "friendId":friendId]
//        getList(params,method: API_K_PASSPORT.GET_PASSPORT_DETAILS) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [TripModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    func confirmPassport(tripId:String,friendId:String, withCompletionHandler completion:(( _ status: Bool, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        let params:[String:String] = ["tripId":tripId,
//                                      "friendId":friendId]
//
//        Request(.post, API_K_PASSPORT.CONFIRM_PASSPORT, parameters: params )?.responseJSON(completionHandler: { (responseData) in
//            switch responseData.result {
//            case .success(let value):
//                print(value)
//                SVProgressHUD.dismiss()
//                let json = JSON(value)
//                if let jsonDic = json.dictionaryObject {
//
//                    let isSuccess:Bool = jsonDic["success"] as! Bool
//                    let msg:String = json["message"].stringValue
//
//                    if !isSuccess{
//                        completion?(false,msg)
//                    }
//                    else{
//
//                        completion?(true,msg)
//                    }
//                }
//                else {
//                    completion?(false,nil)
//                }
//            case .failure( _):
//                SVProgressHUD.dismiss()
//                completion?(false,nil)
//            }
//        })
//    }
//}
//
//struct API_K_BLOG {
//    static let GET_BLOG_LIST = "getBlogs"
//    static let CREATE_BLOG = "createBlog"
//    static let UPLOAD_BLOG_IMAGE = "uploadBlockImage"
//    static let GET_BLOG_DETAILS = "othersProfile"
//    static let UPLOAD_BLOG_VIDEO = "uploadBlogVideo"
//
//}
//
//extension APIManager{
//
//    func uploadBlogImage(_ image:UIImage?, withCompletionHandler completion:(( _ status:Bool,_ url:String?, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        UploadRequest(
//            .post,API_K_BLOG.UPLOAD_BLOG_IMAGE,
//            multipartFormData: { multipartFormData in
//                if let image = image, let imageData =  UIImageJPEGRepresentation(image, 0.8) {
//                    multipartFormData.append(imageData, withName: "image", fileName: "file.png", mimeType: "application/octet-stream")
//                }
//
//                /*for (key, value) in params {
//                    let val:String = value
//                    multipartFormData.append(val.data(using: .utf8)!, withName: key)
//                }*/
//        },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON{ (response) -> Void in
//                        switch response.result{
//                        case .success(let value):
//                            let json = JSON(value)
//                            print(json)
//
//                            if let jsonDic = json.dictionaryObject {
//                                let status:Bool = jsonDic["success"] as! Bool
//                                let mssg = jsonDic["message"] as! String
//                                let imagedict:[String:String] = jsonDic["data"] as! [String : String]
//
//                                 if let imageName =  imagedict["imageName"] {
//                                 completion?(status,imageName,mssg)
//                                 }
//                                 else{
//                                 completion?(status,nil,mssg)
//                                 }
//                            }
//                            else {
//                                completion?(false,nil,APP_STRING.SERVER_ERROR)
//                            }
//                            SVProgressHUD.dismiss()
//
//                        case .failure(let error):
//                            SVProgressHUD.dismiss()
//                            completion?(false,nil,APP_STRING.SERVER_ERROR)
//                        }
//                    }
//                case .failure(let encodingError):
//                    SVProgressHUD.dismiss()
//                    completion?(false,nil,APP_STRING.SERVER_ERROR)
//                }
//        })
//    }
//
//    func uploadBlogVideo(_ videoURL:URL?, withCompletionHandler completion:(( _ status:Bool,_ url:String?,_ thumburl:String?, _ msg:String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
////        var movieData: NSData?
////        do {
////            movieData = try NSData(contentsOfFile: (videoURL?.relativePath)!, options: NSData.ReadingOptions.alwaysMapped)
////        } catch _ {
////            movieData = nil
////            return
////        }
//
//        UploadRequest(
//            .post,API_K_BLOG.UPLOAD_BLOG_VIDEO,
//            multipartFormData: { multipartFormData in
//
//                //  upload only mp4 video
//                multipartFormData.append(videoURL!, withName: "video", fileName: "video.mp4", mimeType: "video/mp4")
//                //  upload any type of video
//                //multipartFormData.append(videoURL!, withName: "File1")
////                multipartFormData.append(("VIDEO".data(using: String.Encoding.utf8, allowLossyConversion: false))!, withName: "Type")
////
//
//
//            },
//            encodingCompletion: { encodingResult in
//                switch encodingResult {
//                case .success(let upload, _, _):
//                    upload.responseJSON{ (response) -> Void in
//                        switch response.result{
//                        case .success(let value):
//                            let json = JSON(value)
//                            print(json)
//
//                            if let jsonDic = json.dictionaryObject {
//                                let status:Bool = jsonDic["success"] as! Bool
//                                let mssg = jsonDic["message"] as! String
//                                let videodict:[String:String] = jsonDic["data"] as! [String : String]
//
//                                NSLog("jsonDIC in uploadBlogVideo %@", jsonDic)
//
//                                if let videoUrl =  videodict["videoPath"] {
//                                    if let thumbUrl = videodict["videoThumbPath"]{
//
//                                        completion?(status,videoUrl,thumbUrl,mssg)
//                                    }
//                                }
//                                else{
//                                    completion?(status,nil,nil,mssg)
//                                }
//                            }
//                            else {
//                                completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
//                            }
//                            SVProgressHUD.dismiss()
//
//                        case .failure(let error):
//                            SVProgressHUD.dismiss()
//                            completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
//                        }
//                    }
//                case .failure(let encodingError):
//                    SVProgressHUD.dismiss()
//                    completion?(false,nil,nil,APP_STRING.SERVER_ERROR)
//                }
//        })
//    }
//
//    func createBlog(title:String,details:String,imageUrl:String?,videoUrl:String?, withCompletionHandler completion:(( _ status: Bool, _ message: String?)->Void)?) {
//
//        SVProgressHUD.show(withStatus: APP_STRING.PROGRESS_TEXT)
//
//        var params:[String:String] = ["blogTitle":title,
//                                      "description":details]
//        if let imgUrl = imageUrl{
//            params["imageUrl"] = imgUrl
//        }
//        if let videoUrl = videoUrl{
//            params["videoUrl"] = videoUrl
//        }
//
//        submit(param: params, method: API_K_BLOG.CREATE_BLOG) { (sts, msg) in
//            completion?(sts,msg)
//        }
//    }
//
////    func getBlogPosts(type:BlogType, withCompletionHandler completion:(( _ trips: [BlogModel])->Void)?) {
////
////        let params:[String:String] = ["getMyBlog":type.rawValue]
////
////        getList(params,method: API_K_BLOG.GET_BLOG_LIST) { (sts, jsonArray) in
////            if sts{
////                if let jsA = jsonArray{
////                    if let histories = [BlogModel].from(jsonArray: jsA) {
////                        completion?(histories)
////
////                    } else {
////
////                        completion?([])
////                    }
////                }
////                else{
////                    completion?([])
////                }
////            }
////            else{
////                completion?([])
////            }
////        }
////    }
////
////    func getBlogDetails(blogId:String, withCompletionHandler completion:(( _ trips: [TripModel])->Void)?) {
////
////        let params:[String:Any] = ["blogId":blogId]
////        getList(params,method: API_K_BLOG.GET_BLOG_DETAILS) { (sts, jsonArray) in
////            if sts{
////                if let jsA = jsonArray{
////                    if let histories = [TripModel].from(jsonArray: jsA) {
////                        completion?(histories)
////
////                    } else {
////
////                        completion?([])
////                    }
////                }
////                else{
////                    completion?([])
////                }
////            }
////            else{
////                completion?([])
////            }
////        }
////    }
//}
//
//
//
//struct API_K_TRAVEL_HISTORY {
//    static let GET_TRAVEL_HISTORY = "getTravelHistory"
//    static let GET_MY_TRAVEL_HISTORY = "getMyTravelHistory"
//
//}
//
//extension APIManager{
//
//    func getTravelHistories(completion:(( _ trips: [BlogHistoryModel])->Void)?) {
//
//       // let params:[String:String] = ["getMyBlog":type.rawValue]
//
//        getList(method: API_K_TRAVEL_HISTORY.GET_TRAVEL_HISTORY) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [BlogHistoryModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//    func getTravelMyHistories(completion:(( _ trips: [BlogHistoryModel])->Void)?) {
//
//        // let params:[String:String] = ["getMyBlog":type.rawValue]
//
//        getList(method: API_K_TRAVEL_HISTORY.GET_MY_TRAVEL_HISTORY) { (sts, jsonArray) in
//            if sts{
//                if let jsA = jsonArray{
//                    if let histories = [BlogHistoryModel].from(jsonArray: jsA) {
//                        completion?(histories)
//
//                    } else {
//
//                        completion?([])
//                    }
//                }
//                else{
//                    completion?([])
//                }
//            }
//            else{
//                completion?([])
//            }
//        }
//    }
//
//}
