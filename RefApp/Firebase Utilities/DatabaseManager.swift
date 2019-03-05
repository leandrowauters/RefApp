//
//  DatabaseManager.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/23/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore


final class DatabaseManager {
    
    private init() {}

    private static var games = [Game]()
    private static var listener: ListenerRegistration!
    static let firebaseDB: Firestore = {
        // gets a reference to firestore database
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        return db
    }()
    
    static func postGameStatisticsToDatabase(gameStatistics: GameStatistics) {
        var ref: DocumentReference? = nil
        ref = firebaseDB.collection(DatabaseKeys.GameStatisticsCollectionKey).addDocument(data: ["userID" : gameStatistics.userID, "winnerSide" : gameStatistics.winnerSide, "totalRunningTime" : gameStatistics.totalRunningTime, "totalInjuryTimeGiven" : gameStatistics.totalInjuryTimeGiven, "homeYellowCards" : gameStatistics.homeYellowCards, "awayYellowCards" : gameStatistics.awayYellowCards, "homeRedCards" : gameStatistics.homeRedCards, "awayRedCards": gameStatistics.awayRedCards, "homeGoals" : gameStatistics.homeGoals, "awayGoals" : gameStatistics.awayGoals]
            , completion: { (error) in
                if let error = error {
                    print("posing statistics failed with error: \(error)")
                } else {
                    print("post created at ref: \(ref?.documentID ?? "no doc id")")
                    
                    // updating a firestore dcoument:
                    // here we are updating the field dbReference for race review,
                    // useful for e.g deleting a (race review) document
                    DatabaseManager.firebaseDB.collection(DatabaseKeys.GameStatisticsCollectionKey)
                        .document(ref!.documentID)
                        .updateData(["dbReference": ref!.documentID], completion: { (error) in
                            if let error = error {
                                print("error updating field: \(error)")
                            } else {
                                print("field updated")
                            }
                        })
                }
        })
    }
    static func fetchGameStatistics(vc: UIViewController, user: User, completion: @escaping(Error?,[GameStatistics]?) -> Void) {
        let query = DatabaseManager.firebaseDB.collection(DatabaseKeys.GameStatisticsCollectionKey).whereField("userID", isEqualTo: user.uid)
        query.getDocuments { (snapshot, error) in
            if let error = error{
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot{
                var gameStatistics = [GameStatistics]()
                for document in snapshot.documents {
                    let savedGameStatistics = GameStatistics.init(dict: document.data())
                    gameStatistics.append(savedGameStatistics)
                }
                completion(nil, gameStatistics)
            }
        }
        
    }

    static func postGameDataToDatabase(gameData: GameData) {
        var ref: DocumentReference? = nil
        ref = firebaseDB.collection(DatabaseKeys.GameDataCollectionKey).addDocument(data: ["userID" : gameData.userID, "winner": gameData.winner, "gameName" : gameData.gameName!, "lengthSelected": gameData.lengthSelected, "numberOfPlayers": gameData.numberOfPlayers, "location" : gameData.location, "dateAndTime" : gameData.dateAndTime, "league": gameData.league, "refereeName": gameData.refereeNames, "capsNames": gameData.caps, "extraTime": gameData.extraTime,"homeTeam" : gameData.homeTeam, "awayTeam" : gameData.awayTeam,"homeScore" : gameData.homeScore, "awayScore" : gameData.awayScore,"totalRunningTime" : gameData.totalRunningTime, "totalInjuryTimeGiven" : gameData.totalInjuryTimeGiven, "subs" : gameData.subs,"homePlayers" : gameData.homePlayers, "awayPlayers": gameData.awayPlayers, "homeYellowCardPlayers": gameData.homeYellowCardPlayers, "homeRedCardPlayers" : gameData.homeRedCardPlayers, "awayYellowCardPlayers": gameData.awayYellowCardPlayers, "awayRedCardPlayers": gameData.awayRedCardPlayers, "homeGoalsPlayers": gameData.homeGoalsPlayers, "awayGoalsPlayers" : gameData.awayGoalsPlayers, "gameNotes": gameData.gameNotes], completion: { (error) in
            if let error = error {
                print("posing gameData failed with error: \(error)")
            } else {
                print("post created at ref: \(ref?.documentID ?? "no doc id")")
                
                // updating a firestore dcoument:
                // here we are updating the field dbReference for race review,
                // useful for e.g deleting a (race review) document
                DatabaseManager.firebaseDB.collection(DatabaseKeys.GameDataCollectionKey)
                    .document(ref!.documentID)
                    .updateData(["dbReference": ref!.documentID], completion: { (error) in
                        if let error = error {
                            print("error updating field: \(error)")
                        } else {
                            print("field updated")
                        }
                    })
            }
        })
    }
    static func fetchGameData(vc: UIViewController, user: User, completion: @escaping(Error?,[GameData]?) -> Void) {
        let query = DatabaseManager.firebaseDB.collection(DatabaseKeys.GameDataCollectionKey).whereField("userID", isEqualTo: user.uid)
        query.getDocuments { (snapshot, error) in
            if let error = error{
               vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot{
                var gameData = [GameData]()
                for document in snapshot.documents {
                    let savedGameData = GameData.init(dict: document.data())
                    gameData.append(savedGameData)
                }
                completion(nil, gameData)
            }
        }

    }
    static func postSaveGameToDatabase(userID: String) {
        let gameToSave = Game.init(userID: userID, gameName: Game.gameName, lengthSelected: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, location: Game.location, dateAndTime: Game.dateAndTime, league: Game.league, refereeNames: Game.refereeNames, caps: Game.caps, extraTime: Game.extraTime, homeTeam: Game.homeTeam, awayTeam: Game.awayTeam, subs: Game.numberOfSubs, homePlayers: Game.homePlayers, awayPlayers: Game.awayPlayers, dbReferenceDocumentId: "")
         var ref: DocumentReference? = nil
        ref = firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).addDocument(data: ["userID": gameToSave.userID, "gameName": gameToSave.gameName!, "gameLength": gameToSave.lengthSelected, "numberOfPlayers" : gameToSave.numberOfPlayers, "location" : gameToSave.location, "dateAndTime" : gameToSave.dateAndTime, "league" : gameToSave.league, "refereeNames" : gameToSave.refereeNames, "caps" : gameToSave.caps , "extraTime" : gameToSave.extraTime, "homeTeam" : gameToSave.homeTeam , "awayTeam" : gameToSave.awayTeam, "subs" : gameToSave.subs, "homePlayers" : gameToSave.homePlayers, "awayPlayers" : gameToSave.awayPlayers, "dBReference" : gameToSave.dbReferenceDocumentId], completion: { (error) in
            if let error = error {
                print("posing gameToSave failed with error: \(error)")
            } else {
                print("post created at ref: \(ref?.documentID ?? "no doc id")")
                
                // updating a firestore dcoument:
                // here we are updating the field dbReference for race review,
                // useful for e.g deleting a (race review) document
                DatabaseManager.firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey)
                    .document(ref!.documentID)
                    .updateData(["dbReference": ref!.documentID], completion: { (error) in
                        if let error = error {
                            print("error updating field: \(error)")
                        } else {
                            print("field updated")
                        }
                    })
            }
        })

    }
//    static func fetchSaveGames(vc: UIViewController,completion: @escaping(Error?, [Game]?) -> Void) {
//        
//        // add a listener to observe changes to the firestore database
//        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
//            if let error = error {
//                vc.showAlert(title: "Network Error", message: error.localizedDescription)
//            } else if let snapshot = snapshot {
//                var games = [Game]()
//                for document in snapshot.documents {
//                    let savedGame = Game.init(dict: document.data())
//                    games.append(savedGame)
//                }
//                completion(nil, games)
//            }
//        }
//    }
    static func deleteSavedGameFromDatabase(vc: UIViewController, gameToDelete: Game) {
        firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).document(gameToDelete.dbReferenceDocumentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        } 
    }
    
    static func fetchSaveGames(vc: UIViewController,userID: String, completion: @escaping(Error?, [Game]?) -> Void) {
        let query = DatabaseManager.firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).whereField("userID", isEqualTo: userID)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot{
                var games = [Game]()
                for document in snapshot.documents {
                    let savedGame = Game.init(dict: document.data())
                    games.append(savedGame)
                }
                completion(nil, games)
            }
        }
        }
    static func fetchReferee(vc: UIViewController, user: User, completion: @escaping(Error?, Referee?) -> Void) {
        let query = DatabaseManager.firebaseDB.collection(DatabaseKeys.UsersCollectionKey).whereField("userId", isEqualTo: user.uid)
        query.getDocuments { (snapshot, error) in
            if let error = error {
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot {
                guard let firstDocumet = snapshot.documents.first else {
                    print("no document found")
                    return
                }
                let referee = Referee.init(dict: firstDocumet.data())
                completion(nil, referee)
            }
        }
    }
    }
//    private func queryForReviewer() {
//        // Query - for the user who created this race review
//        let query = DatabaseManager.firebaseDB.collection(DatabaseKeys
//            .UsersCollectionKey).whereField("userId", isEqualTo: raceReview.reviewerId)
//        query.getDocuments { (snapshot, error) in
//            if let error = error {
//                self.showAlert(title: "Network Error", message: error.localizedDescription, actionTitle: "Try Again")
//            } else if let snapshot = snapshot {
//                guard let firstDocument = snapshot.documents.first else {
//                    print("no document found")
//                    return
//                }
//                let reviewer = RRUser(dict: firstDocument.data())
//                DispatchQueue.main.async {
//                    self.detailView.usernameLabel.text = "reviewed by @\(reviewer.username ?? "no ussername")"
//                }
//
//                // setting up image url
//                guard let imageURL = reviewer.imageURL,
//                    !imageURL.isEmpty else {
//                        print("no imageURL")
//                        return
//                }
//                //use Kinhgisher or SWDwebImage cocoapods
//                if let image = ImageCache.shared.fetchImageFromCache(urlString: imageURL) {
//                    self.detailView.reviewersProfileImageView.image = image
//                } else {
//                    ImageCache.shared.fetchImageFromNetwork(urlString: imageURL) { (appError, image) in
//                        if let appError = appError {
//                            self.showAlert(title: "Fetching Image Error", message: appError.errorMessage(), actionTitle: "Ok")
//                        } else if let image = image {
//                            self.detailView.reviewersProfileImageView.image = image
//                        }
//                    }
//                }
//
//            }
//        }
//    }
//}
