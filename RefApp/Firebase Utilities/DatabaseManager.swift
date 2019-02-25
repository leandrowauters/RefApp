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
        ref = firebaseDB.collection(DatabaseKeys.GameStatisticsCollectionKey).addDocument(data: ["userID" : gameStatistics.userID, "winnerSide" : gameStatistics.winnerSide, "winnerTeam" : gameStatistics.winnerTeam, "homeYellowCards" : gameStatistics.homeYellowCards, "awayYellowCards" : gameStatistics.awayYellowCards, "homeRedCards" : gameStatistics.homeRedCards, "awayRedCards": gameStatistics.awayRedCards, "homeGoals" : gameStatistics.homeGoals, "awayGoals" : gameStatistics.awayGoals]
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
    static func fetchGameStatistics(vc: UIViewController) -> [GameStatistics]{
        var gameStatistics = [GameStatistics]()
        // add a listener to observe changes to the firestore database
        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.GameStatisticsCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if let error = error {
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot {
                var statistics = [GameStatistics]()
                for document in snapshot.documents {
                    let gameStatistics = GameStatistics.init(dict: document.data())
                    
                    statistics.append(gameStatistics)
                }
                gameStatistics = statistics
            }
        }
        return gameStatistics
    }
    static func postGameDataToDatabase(gameData: GameData) {
        var ref: DocumentReference? = nil
        ref = firebaseDB.collection(DatabaseKeys.GameDataCollectionKey).addDocument(data: ["userID" : gameData.userID, "gameName" : gameData.gameName!, "lengthSelected": gameData.lengthSelected, "numberOfPlayers": gameData.numberOfPlayers, "location" : gameData.location, "dateAndTime" : gameData.dateAndTime, "league": gameData.league, "refereeName": gameData.refereeNames, "capsNames": gameData.caps, "extraTime": gameData.extraTime,"homeTeam" : gameData.homeTeam, "awayTeam" : gameData.awayTeam,"subs" : gameData.subs,"homePlayers" : gameData.homePlayers, "awayPlayers": gameData.awayPlayers, "homeYellowCardPlayers": gameData.homeYellowCardPlayers, "homeRedCardPlayers" : gameData.homeRedCardPlayers, "awayYellowCardPlayers": gameData.awayYellowCardPlayers, "awayRedCardPlayers": gameData.awayRedCardPlayers, "homeGoalsPlayers": gameData.homeGoalsPlayers, "awayGoalsPlayers" : gameData.awayGoalsPlayers, "gameNotes": gameData.gameNotes], completion: { (error) in
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
    static func fetchGameData(vc: UIViewController) -> [GameData]{
        var gameData = [GameData]()
        // add a listener to observe changes to the firestore database
        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.GameDataCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if let error = error {
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot {
                var data = [GameData]()
                for document in snapshot.documents {
                    let gameData = GameData.init(dict: document.data())
                    
                    data.append(gameData)
                }
                gameData = data
            }
        }
        return gameData
    }
    
    static func postSaveGameToDatabase(gameToSave: Game) {
         var ref: DocumentReference? = nil
        ref = firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).addDocument(data: ["userID": gameToSave.userID, "gameName": gameToSave.gameName!, "gameLenght": gameToSave.lengthSelected, "numberOfPlayers" : gameToSave.numberOfPlayers, "location" : gameToSave.location, "dateAndTime" : gameToSave.dateAndTime, "league" : gameToSave.league, "refereeNames" : gameToSave.refereeNames, "caps" : gameToSave.caps , "extraTime" : gameToSave.extraTime, "homeTeam" : gameToSave.homeTeam , "awayTeam" : gameToSave.awayTeam, "subs" : gameToSave.subs, "homeTeam" : gameToSave.homeTeam, "awayTeam" : gameToSave.awayTeam, "subs" : gameToSave.subs, "homePlayers" : gameToSave.homePlayers, "awayPlayers" : gameToSave.awayTeam], completion: { (error) in
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
    static func fetchSaveGames(vc: UIViewController) -> [Game]{
        var savedGames = [Game]()
        // add a listener to observe changes to the firestore database
        listener = DatabaseManager.firebaseDB.collection(DatabaseKeys.SavedGameCollectionKey).addSnapshotListener(includeMetadataChanges: true) { (snapshot, error) in
            if let error = error {
                vc.showAlert(title: "Network Error", message: error.localizedDescription)
            } else if let snapshot = snapshot {
                var games = [Game]()
                for document in snapshot.documents {
                    let savedGame = Game.init(dict: document.data())
                    
                    games.append(savedGame)
                }
                savedGames = games
            }
        }
        return savedGames
    }
}
