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
        playerName = "playerName" <~~ json
        playerKey = "playerKey" <~~ json
        isCaptain = "isCaptain" <~~ json
        isViceCaptain = "isViceCaptain" <~~ json
        playerEarningPoint = "playerEarningPoint" <~~ json
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "player_id" ~~> playerId,
            "playerName" ~~> playerName,
            "playerKey" ~~> playerKey,
            "playerEarningPoint" ~~> playerEarningPoint,
            "isCaptain" ~~> isCaptain,
            "isViceCaptain" ~~> isViceCaptain
            
            ])
    }
}


class UserFantasyPlayer: Glossy {
    
    var player: Player?
    var id: Int? {
        return player?.playerId
    }
    
    required init?(json: Gloss.JSON) {
        player = "player" <~~ json
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            "id" ~~> id
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
    var keeper: [UserFantasyPlayer] = []
    
    required init?(json: Gloss.JSON) {
      
        matchId = "match_id" <~~ json
        teamName = "team_name" <~~ json
        captain = "captain" <~~ json
        viceCaptain = "vice_captain" <~~ json
        batsman = ("batsman" <~~ json) ?? []
        bowler = ("bowler" <~~ json) ?? []
        allrounder = ("allrounder" <~~ json) ?? []
        keeper = ("keeper" <~~ json) ?? []
        
    }
    
    func toJSON() -> Gloss.JSON? {
        return jsonify([
            
            "match_id" ~~> matchId,
            "team_name" ~~> teamName,
            "captain" ~~> captain,
            "vice_captain" ~~> viceCaptain,
            "batsman" ~~> batsman,
            "bowler" ~~> bowler,
            "allrounder" ~~> allrounder,
            "keeper" ~~> keeper
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
    var rating: Int?
    var totalCoins: Int?
    var totalCash: Int?
    
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


