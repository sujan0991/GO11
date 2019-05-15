//
//  InvoiceModel.swift
//  TT
//
//  Created by Dulal Hossain on 4/2/17.
//  Copyright © 2017 DL. All rights reserved.
//

import UIKit
import Gloss
import SwiftyJSON
import MapKit


class MatchList: Glossy {
    
    var matchId: Int?
    var matchKey: String?
    var tournamentName: String?
    var matchName: String?
    var matchTime: String?
    var format: String?
    
    var totalJoinedContests: Int?
    var teams: [MatchTeams] = []
    
    var joiningLastTime: String? {
        return matchTime?.serverTimetoDateString()
    }
    
    required init?(json: Gloss.JSON) {
        matchId = "match_id" <~~ json
        matchKey = "match_key" <~~ json
        tournamentName = "tournament_name" <~~ json
        matchName = "match_name" <~~ json
        matchTime = "match_time" <~~ json
        format = "format" <~~ json
        totalJoinedContests = "total_joined_contests" <~~ json
        teams = ("teams" <~~ json) ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "match_id" ~~> matchId,
            "match_key" ~~> matchKey,
            "tournament_name" ~~> tournamentName,
            "match_time" ~~> matchName,
            "format" ~~> matchTime,
            "email" ~~> format,
            "total_joined_contests" ~~> totalJoinedContests,
            "teams" ~~> teams,
            "joiningLastTime" ~~> joiningLastTime
            ])
    }
}

class MatchTeams: Glossy {
    
    var teamId: Int?
    var name: String?
    var teamKey: String?
    var logo: String?
    
    
    
    required init?(json: Gloss.JSON) {
        teamId = "team_id" <~~ json
        name = "name" <~~ json
        teamKey = "team_key" <~~ json
        logo = "logo" <~~ json
        
        logo = logo?.trimForURL()
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "team_id" ~~> teamId,
            "name" ~~> name,
            "team_key" ~~> teamKey,
            "logo" ~~> logo
            ])
    }
}

class PlayingTeam: Glossy {
    
    var teamId: Int?
    var name: String?
    var teamKey: String?
    var logo: String?
    var playersList: [Player] = []
    
    
    required init?(json: Gloss.JSON) {
        teamId = "team_id" <~~ json
        name = "name" <~~ json
        teamKey = "team_key" <~~ json
        logo = "logo" <~~ json
        logo = logo?.trimForURL()
        
        playersList = "players" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "team_id" ~~> teamId,
            "name" ~~> name,
            "team_key" ~~> teamKey,
            "logo" ~~> logo,
            "players" ~~> playersList
            ])
    }
}

class PlayingTeamsData: Glossy {
    
  
    var firstTeam: PlayingTeam?
    var secondTeam: PlayingTeam?
    
    required init?(json: Gloss.JSON) {
        firstTeam = "a" <~~ json
        secondTeam = "b" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "a" ~~> firstTeam,
            "b" ~~> secondTeam
            ])
    }
}

class Avatar: Glossy {
    
    var avaterId: Int?
    var imagePath: String?
    
    required init?(json: Gloss.JSON) {
        avaterId = "id" <~~ json
        imagePath = "image_path" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> avaterId,
            "image_path" ~~> imagePath
            ])
    }
}

class MatchSquadData: Glossy {
    
    var matchId: Int?
    var matchName: String?
    var matchKey: String?
    var team_rules: SelectionRulesData?
    
    var teams: PlayingTeamsData?
    var playersList: [Player] = []
    
    required init?(json: Gloss.JSON) {
        matchId = "match_id" <~~ json
        matchName = "name" <~~ json
        matchKey = "match_key" <~~ json
        team_rules = "team_rules" <~~ json
        teams = "teams" <~~ json
        playersList = ("players" <~~ json) ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "match_id" ~~> matchId,
            "match_key" ~~> matchKey,
            "name" ~~> matchName,
            "team_rules" ~~> team_rules,
            "teams" ~~> teams,
            "players" ~~> playersList
            ])
    }
}


class FantasySquadData: Glossy {
    
    var teamName: String?
    var batsman: [FantasyPlayer] = []
    var bowler: [FantasyPlayer] = []
    var allrounder: [FantasyPlayer] = []
    var keeper: [FantasyPlayer] = []
    
    required init?(json: Gloss.JSON) {
        
        teamName = "team_name" <~~ json
        batsman = ("batsman" <~~ json) ?? []
        bowler = ("bowler" <~~ json) ?? []
        allrounder = ("allrounder" <~~ json) ?? []
        keeper = ("keeper" <~~ json) ?? []

    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "team_name" ~~> teamName,
            "batsman" ~~> batsman,
            "bowler" ~~> bowler,
            "allrounder" ~~> allrounder,
            "keeper" ~~> keeper
            ])
    }
}

class CreatedTeamList: Glossy {
    
    var status: Int?
    var message: String?
    var teams: [CreatedTeam] = []
    
    required init?(json: Gloss.JSON) {
        status = "status" <~~ json
        message = "message" <~~ json
        teams = "data" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "status" ~~> status,
            "message" ~~> message,
            "data" ~~> teams
            ])
    }
}


class CreatedTeam: Glossy {
    
    var userTeamId: Int?
    var teamName: String?
    var captainName: String?
    var viceCaptainName: String?
    var batsmanCount: Int?
    var bowlerCount: Int?
    var allrounderCount : Int?
    var keeperCount : Int?
    
    required init?(json: Gloss.JSON) {
        userTeamId = "user_team_id" <~~ json
        teamName = "team_name" <~~ json
        captainName = "captain_name" <~~ json
        viceCaptainName = "vice_captain_name" <~~ json
        batsmanCount = "batsman" <~~ json
        bowlerCount = "bowler" <~~ json
        allrounderCount = "allrounder" <~~ json
        keeperCount = "keeper" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "user_team_id" ~~> userTeamId,
            "team_name" ~~> teamName,
            "captain_name" ~~> captainName,
            "vice_captain_name" ~~> viceCaptainName,
            "batsman" ~~> batsmanCount,
            "bowler" ~~> bowlerCount,
            "allrounder" ~~> allrounderCount,
            "keeper" ~~> keeperCount
            
            
            ])
    }
}


class FantasyPlayer: Glossy {
    
    var playerId: Int?
    var playerName: String?
    var playerKey: String?
    var isCaptain: Int?
    var isViceCaptain: Int?
    var playerEarningPoint : Int?
    
    required init?(json: Gloss.JSON) {
        playerId = "player_id" <~~ json
        playerName = "player_name" <~~ json
        playerKey = "player_key" <~~ json
        isCaptain = "is_captain" <~~ json
        isViceCaptain = "is_vice_captain" <~~ json
        playerEarningPoint = "player_earning_point" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "player_id" ~~> playerId,
            "player_name" ~~> playerName,
            "player_key" ~~> playerKey,
            "player_earning_point" ~~> playerEarningPoint,
            "is_captain" ~~> isCaptain,
            "is_vice_captain" ~~> isViceCaptain
            
            ])
    }
}


class UserFantasyPlayer: Glossy {
    
    var id: Int?
    var isCaptain: Int?
    var isViceCaptain: Int?
    
    required init?(json: Gloss.JSON) {
        
        id = "id" <~~ json
        isCaptain = "is_captain" <~~ json
        isViceCaptain = "is_vice_captain" <~~ json
    }

    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "is_captain" ~~> isCaptain,
            "is_vice_captain" ~~> isViceCaptain
            
            ])
    }
}


class UsersFantasyTeam: Glossy {
    
    var matchId: Int?
    var teamName: String?
    var captain: Int?
    var viceCaptain: Int?
    
    var batsman: [UserFantasyPlayer] = []
    var bowler: [UserFantasyPlayer] = []
    var allrounder: [UserFantasyPlayer] = []
    var keeper : [UserFantasyPlayer] = []
    
    required init?(json: Gloss.JSON) {
      
        matchId = "match_id" <~~ json
        teamName = "team_name" <~~ json
        captain = "captain" <~~ json
        viceCaptain = "vice_captain" <~~ json
        batsman = ("batsman" <~~ json) ?? []
        bowler = ("bowler" <~~ json) ?? []
        allrounder = ("allrounder" <~~ json) ?? []
        keeper = "keeper" <~~ json ?? []
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            
            "match_id" ~~> matchId,
            "team_name" ~~> teamName,
            "captain" ~~> captain,
            "vice_captain" ~~> viceCaptain,
            "batsman" ~~> batsman.toJSONArray(),
            "bowler" ~~> bowler.toJSONArray(),
            "allrounder" ~~> allrounder.toJSONArray(),
            "keeper" ~~> keeper.toJSONArray()
            ])
    }
}


class Player: Glossy {
    
    var playerId: Int?
    var name: String?
    var playerKey: String?
    var role: String?
    var playerImage: String?
    var creditPoints: Double?
    var teamBelong: Int?
    var playerSelected: Bool = false
    var isCaptain: Bool = false
    var isViceCaptain: Bool = false
    
    required init?(json: Gloss.JSON) {
        playerId = "player_id" <~~ json
        name = "name" <~~ json
        playerKey = "player_key" <~~ json
        role = "role" <~~ json
        playerImage = "player_image" <~~ json
        
        playerImage = playerImage?.trimForURL()
        creditPoints = "credit_points" <~~ json
        teamBelong = "team_belong" <~~ json
        
        //  playerSelected = "playerSelected" <~~ json ?? false
        //  isCaptain = "playerSeisCaptainlected" <~~ json ?? false
        //  isViceCaptain = "isViceCaptain" <~~ json ?? false

    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "player_id" ~~> playerId,
            "name" ~~> name,
            "player_key" ~~> playerKey,
            "role" ~~> role,
            "player_image" ~~> playerImage,
            "credit_points" ~~> creditPoints,
            "team_belong" ~~> teamBelong,
            
            "playerSelected" ~~> playerSelected,
            "isCaptain" ~~> isCaptain,
            "isViceCaptain" ~~> isViceCaptain
            
            ])
    }
    func lastName() -> String {
       
        let firstWord = name?.components(separatedBy: " ").last
        return firstWord ?? name ?? ""
    }
  
}


class UserModel: Glossy {
    
    var id: Int?
    var name: String?
    var email: String?
    var phone: String?
   
    var userTypeId: Int?
    var avatarId: Int?//skippable
    
    var sex: String?
    var address: String?
    var city: String?
    var zipcode: String?
    var dateOfBirth: String?
  
    var gcmRegistrationKey: String?
    var isVerified: Int?
    var metadata: ProfileMetaData?
    var avatar: ProfileAvatar?
    
    required init?(json: Gloss.JSON) {
        id = "id" <~~ json
        name = "name" <~~ json
        email = "email" <~~ json
        phone = "phone" <~~ json
        userTypeId = "user_type_id" <~~ json
        avatarId = "avatar_id" <~~ json
        sex = "sex" <~~ json
        
        address = "address" <~~ json
        city = "city" <~~ json
        zipcode = "zipcode" <~~ json
        dateOfBirth = "dob" <~~ json
        
        gcmRegistrationKey = "gcm_registration_key" <~~ json
        isVerified = "is_verified" <~~ json
        
        metadata = ("metadata" <~~ json)
        avatar = ("avatar" <~~ json)
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "name" ~~> name,
            "email" ~~> email,
            "phone" ~~> phone,
            "user_type_id" ~~> userTypeId,
            "avatar_id" ~~> avatarId,
            "sex" ~~> sex,
            "address" ~~> address,
            "city" ~~> city,
            "zipcode" ~~> zipcode,
            "dob" ~~> dateOfBirth,
            "gcm_registration_key" ~~> gcmRegistrationKey,
            "is_verified" ~~> isVerified,
            "metadata" ~~> metadata,
            "avatar" ~~> avatar
            ])
    }
}

class ProfileMetaData: Glossy {
    
    var id: Int?
    var userId: Int?
    var rating: Float?
    var totalCoins: Float?
    var totalCash: Float?
    
    var totalContestParticipation: Int?
    var totalMatchParticipation: Int?
    var totalPendingRequest: Int?
    var highestRank: Int?
    
    var photoIdFront: String?
    var photoIdBack: String?
    
    
    required init?(json: Gloss.JSON) {
        id = "id" <~~ json
        userId = "user_id" <~~ json
        rating = "rating" <~~ json
        totalCoins = "total_coins" <~~ json
        totalCash = "total_cash" <~~ json
        totalContestParticipation = "total_contest_participation" <~~ json
        totalMatchParticipation = "total_match_participation" <~~ json
        totalPendingRequest = "total_pending_requests" <~~ json
        highestRank = "highest_rank" <~~ json
        photoIdFront = "nid_front" <~~ json
        photoIdBack = "nid_back" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "user_id" ~~> userId,
            "rating" ~~> rating,
            "total_coins" ~~> totalCoins,
            "total_cash" ~~> totalCash,
            "total_contest_participation" ~~> totalContestParticipation,
            "total_match_participation" ~~> totalMatchParticipation,
            "total_pending_requests" ~~> totalPendingRequest,
            "highest_rank" ~~> highestRank,
            "nid_front" ~~> photoIdFront,
            "nid_back" ~~> photoIdBack
            ])
    }
}

class ProfileAvatar: Glossy {
    
    var id: Int?
    var imagePath: String?
    
    
    required init?(json: Gloss.JSON) {
        id = "id" <~~ json
        imagePath = "image_path" <~~ json
        imagePath = imagePath?.trimForURL()
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "image_path" ~~> imagePath
            ])
    }
}

class ContestPrizes: Glossy {
    
    var id: Int?
    var contestId: Int?
    var rank: Int?
    var prizeAmount: Int?
    var prizeType: String?
    
    
    required init?(json: Gloss.JSON) {
        id = "id" <~~ json
        contestId = "contest_id" <~~ json
        rank = "rank" <~~ json
        prizeAmount = "prize_amount" <~~ json
        prizeType = "prize_type" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "contest_id" ~~> contestId,
            "rank" ~~> rank,
            "prize_amount" ~~> prizeAmount,
            "prize_type" ~~> prizeType
            ])
    }
}

class ContestList: Glossy {
    
    var matchId: Int?
    var userTotalCoin: Int?
    var contests: [ContestData] = []
    
    required init?(json: Gloss.JSON) {
        matchId = "match_id" <~~ json
        userTotalCoin = "user_total_coin" <~~ json
        contests = "contests" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "match_id" ~~> matchId,
            "user_total_coin" ~~> userTotalCoin,
            "contests" ~~> contests
            ])
    }
}


class ContestData: Glossy {
    
    var id: Int?
    var matchId: Int?
    var name: String?
    var subtitle: String?
    var contestType: String?
    var entryAmount: Int?
    var winningAmount: Int?
    var teamsCapacity: Int?
    var lastTimeEntry: String?
    var isCompleted: Int?
    var isJoined: Int?
    var createdAt: String?
    var updatedAt: String?
    var prizes: [ContestPrizes] = []
    
    
    required init?(json: Gloss.JSON) {
        id = "id" <~~ json
        matchId = "match_id" <~~ json
        name = "name" <~~ json
        subtitle = "subtitle" <~~ json
        contestType = "contest_type" <~~ json
        entryAmount = "entry_amount" <~~ json
        winningAmount = "winning_amount" <~~ json
        teamsCapacity = "teams_capacity" <~~ json
        lastTimeEntry = "last_time_entry" <~~ json
        isCompleted = "is_completed" <~~ json
        isJoined = "is_joined" <~~ json
        createdAt = "created_at" <~~ json
        updatedAt = "updated_at" <~~ json
        prizes = "prize" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id,
            "match_id" ~~> matchId,
            "name" ~~> name,
            "subtitle" ~~> subtitle,
            "contest_type" ~~> contestType,
            "entry_amount" ~~> entryAmount,
            "winning_amount" ~~> winningAmount,
            "teams_capacity" ~~> teamsCapacity,
            "last_time_entry" ~~> lastTimeEntry,
            "is_completed" ~~> isCompleted,
            "is_joined" ~~> isJoined,
            "created_at" ~~> createdAt,
            "updated_at" ~~> updatedAt,
            "prize" ~~> prizes
            ])
    }
}



class FantaysTeamPreviewData: Glossy {
    
    var fantasyPlayersList: [Player] = []
    
    required init?(json: Gloss.JSON) {
        fantasyPlayersList = "fantasyPlayersList" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "fantasyPlayersList" ~~> fantasyPlayersList
            ])
    }
}

class SelectionRule: Glossy {
    
    var minPerMatch: Int?
    var maxPerMatch: Int?
    
    required init?(json: Gloss.JSON) {
        minPerMatch = "min_per_match" <~~ json
        maxPerMatch = "max_per_match" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "min_per_match" ~~> minPerMatch,
            "max_per_match" ~~> maxPerMatch
            ])
    }
}

class SelectionRulesData: Glossy {
    
    var batsman: SelectionRule?
    var bowler: SelectionRule?
    var allrounder: SelectionRule?
    var keeper: SelectionRule?
    
    
    required init?(json: Gloss.JSON) {
        batsman = "batsman" <~~ json
        bowler = "bowler" <~~ json
        allrounder = "allrounder" <~~ json
        keeper = "keeper" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "batsman" ~~> batsman,
            "bowler" ~~> bowler,
            "allrounder" ~~> allrounder,
            "keeper" ~~> keeper
            ])
    }
}
//


class ProductModel:NSObject, Glossy,MKAnnotation {

    var productId: Int?
    var sub_category_id: Int?
    var updated_at: String?
    var user_id: Int?
    
    var ptitle: String?
    var title: String?{
        return self.address
    }
    
    var lng: String?
    var make: String?
    var model: String?
    var lat: String?
    
    var image: String?
    var pdescription: String?
    var dealership: String?
    var created_at: String?
    var category_id: Int?
    var address: String?
    var user: UserModel?
    
    var subtitle: String? {
        return user?.name
    }
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D.init(latitude: Double(self.lat ?? "0")!, longitude: Double(self.lng ?? "0")!)
    }
    
    required init?(json: Gloss.JSON) {
        
        productId = "id" <~~ json
        sub_category_id = "sub_category_id" <~~ json
        updated_at = "updated_at" <~~ json
        user_id = "user_id" <~~ json
        ptitle = "title" <~~ json

        model = "model" <~~ json
        make = "make" <~~ json
        lat = "lat" <~~ json
        lng = "long" <~~ json
        
        image = "image" <~~ json
        pdescription = "description" <~~ json
        dealership = "dealership" <~~ json
        created_at = "created_at" <~~ json
        category_id = "category_id" <~~ json
        address = "address" <~~ json
        user = "user" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> productId,
            "sub_category_id" ~~> sub_category_id,
            "updated_at" ~~> updated_at,
            "user_id" ~~> user_id,
            "title" ~~> ptitle,
            
            "model" ~~> model,
            "make" ~~> make,
            "long" ~~> lng,
            "lat" ~~> lat,
            
            "image" ~~> image,
            "description" ~~> pdescription,
            "dealership" ~~> dealership,
            "created_at" ~~> created_at,
            "category_id" ~~> category_id,
            "address" ~~> address,
            "user" ~~> user
            ])
    }
}

class LeaderBoardUserListData: Glossy {
    
    
    var username: String?
    var avatar: String?
    var user_team_id:Int?
    var rank:Int?
    var team_name:String?
    var team_earning_point:Float?
    
    required init?(json: Gloss.JSON) {
        username = "username" <~~ json
        avatar = "avatar" <~~ json
        user_team_id = "user_team_id" <~~ json
        rank = "rank" <~~ json
        team_name = "team_name" <~~ json
        team_earning_point = "team_earning_point" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "username" ~~> username,
            "avatar" ~~> avatar,
            "user_team_id" ~~> user_team_id,
            "rank" ~~> rank,
            "team_name" ~~> team_name,
            "team_earning_point" ~~> team_earning_point,
            ])
    }
}

class LeaderBoardData: Glossy {
    
    var contest_id: Int?
    var match_status_id:Int?
    var user_rank:Int?
    var username:String?
    var user_team_id:Int?
    var user_avatar:String?
    var user_team_name:String?
    var team_earning_point:Float?
    var last_updated_time:String?
    var total_page_number:Int?
    var leaderboard: [LeaderBoardUserListData] = []
    
    
    required init?(json: Gloss.JSON) {
        contest_id = "contest_id" <~~ json
        match_status_id = "match_status_id" <~~ json
        user_rank = "user_rank" <~~ json
        username = "username" <~~ json
        user_team_id = "user_team_id" <~~ json
        user_avatar = "user_avatar" <~~ json
        user_team_name = "user_team_name" <~~ json
        team_earning_point = "team_earning_point" <~~ json
        last_updated_time = "last_updated_time" <~~ json
        total_page_number = "total_page_number" <~~ json
        leaderboard = "leaderboard" <~~ json ?? []
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "contest_id" ~~> contest_id,
            "match_status_id" ~~> match_status_id,
            "user_rank" ~~> user_rank,
            "subtiusernametle" ~~> username,
            "user_team_id" ~~> user_team_id,
            "user_avatar" ~~> user_avatar,
            "user_team_name" ~~> user_team_name,
            "team_earning_point" ~~> team_earning_point,
            "last_updated_time" ~~> last_updated_time,
            "total_page_number" ~~> total_page_number,
            "leaderboard" ~~> leaderboard
            ])
    }
}

class TeamScoreData: Glossy {
    
    
    var team_name:String?
    var team_key:String?
    var is_first_batting:Int?
    var team_earning_point:Float?
    var score:String?
    
    required init?(json: Gloss.JSON) {
        team_name = "team_name" <~~ json
        team_key = "team_key" <~~ json
        is_first_batting = "is_first_batting" <~~ json
        
        score = "score" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "team_name" ~~> team_name,
            "team_key" ~~> team_key,
            "is_first_batting" ~~> is_first_batting,
            
            "score" ~~> score,
            ])
    }
}

class MatchScoreData: Glossy {
    
    
    var match_id:Int?
    var match_format:String?
    var match_status_id:Int?
    
    var match_name:String?
    var result:String?
    var teams: [TeamScoreData] = []
    
    
    required init?(json: Gloss.JSON) {
        match_id = "match_id" <~~ json
        match_format = "match_format" <~~ json
        match_status_id = "match_status_id" <~~ json
        match_name = "match_name" <~~ json
        result = "result" <~~ json
        teams = "teams" <~~ json ?? []
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "match_id" ~~> match_id ,
            "match_format" ~~> match_format,
            "match_status_id" ~~> match_status_id,
            "match_name" ~~> match_name,
            "result" ~~> result,
            "teams" ~~> teams,
            ])
    }
}


class PointBreakDown: Glossy {
    
    
    var player_id:Int?
    var runs:Int?
    var sixes:Int?
    
    var fours:Int?
    var strike_rate:Double?
    var dismissed:Int?

    var wickets:Int?
    var maiden_overs:Int?
    var economy:Double?

    var catches:Int?
    var runouts:Int?
    var stumbeds:Int?

    
    
    required init?(json: Gloss.JSON) {
        player_id = "player_id" <~~ json
        runs = "runs" <~~ json
        sixes = "sixes" <~~ json
        
        fours = "fours" <~~ json
        strike_rate = "strike_rate" <~~ json
        dismissed = "dismissed" <~~ json
        
        wickets = "wickets" <~~ json
        maiden_overs = "maiden_overs" <~~ json
        economy = "economy" <~~ json
        
        catches = "catches" <~~ json
        runouts = "runouts" <~~ json
        stumbeds = "stumbeds" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "player_id" ~~> player_id ,
            "runs" ~~> runs,
            "sixes" ~~> sixes,
            "fours" ~~> fours,
            "strike_rate" ~~> strike_rate,
            "dismissed" ~~> dismissed,
            "wickets" ~~> wickets ,
            "maiden_overs" ~~> maiden_overs,
            "economy" ~~> economy,
            "catches" ~~> catches,
            "runouts" ~~> runouts,
            "stumbeds" ~~> stumbeds,

            ])
    }
}


class PlayerInfoData: Glossy {
    
    
    var player_id:Int?
    var player_name:String?
    var player_role:String?
    
    var player_image:String?
    var is_captain:Int?
    var is_vice_captain:Int?
    
    var player_earning_point:Float?
    var last_updated_time:String?
    var is_in_playing_xi:String?
    var point_breakdown: PointBreakDown?
    
    
    required init?(json: Gloss.JSON) {
        player_id = "player_id" <~~ json
        player_name = "player_name" <~~ json
        player_role = "player_role" <~~ json
        player_image = "player_image" <~~ json
        is_captain = "is_captain" <~~ json
        is_vice_captain = "is_vice_captain" <~~ json
        player_earning_point = "player_earning_point" <~~ json
        last_updated_time = "last_updated_time" <~~ json
        is_in_playing_xi = "is_in_playing_xi" <~~ json
        point_breakdown = "point_breakdown" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            
            "player_id" ~~> player_id ,
            "player_name" ~~> player_name,
            "player_role" ~~> player_role,
            "player_image" ~~> player_image,
            "is_captain" ~~> is_captain,
            "is_vice_captain" ~~> is_vice_captain,
            "player_earning_point" ~~> player_earning_point ,
            "last_updated_time" ~~> last_updated_time,
            "is_in_playing_xi" ~~> is_in_playing_xi,
            "point_breakdown" ~~> point_breakdown,
            
            ])
    }
}


class TeamInfoData: Glossy {
    
    
    var user_team_id:String?
    var team_name:String?
    var team_earning_point:Float?
    
    var player_info: [PlayerInfoData] = []
    
    
    
    required init?(json: Gloss.JSON) {
        user_team_id = "user_team_id" <~~ json
        team_name = "team_name" <~~ json
        team_earning_point = "team_earning_point" <~~ json
        player_info = "player_info" <~~ json ?? []
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            
            "user_team_id" ~~> user_team_id ,
            "team_name" ~~> team_name,
            "team_earning_point" ~~> team_earning_point,
            "player_info" ~~> player_info,
            
            
            ])
    }
}


class BreakDownData: Glossy {
    
    
    var match_id:String?
    var match_status_id:Int?
    var is_calculation_complete:Int?
    
    var team_info: TeamInfoData?
    
    
    
    required init?(json: Gloss.JSON) {
        match_id = "match_id" <~~ json
        match_status_id = "match_status_id" <~~ json
        is_calculation_complete = "is_calculation_complete" <~~ json
        team_info = "team_info" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            
            "match_id" ~~> match_id ,
            "match_status_id" ~~> match_status_id,
            "is_calculation_complete" ~~> is_calculation_complete,
            "team_info" ~~> team_info,
            
            
            ])
    }
}