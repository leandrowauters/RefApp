//
//  GameSaveClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

struct DataPeristanceModel {
    private static var games = [Game]()


    private static let saveGameFileName = "SavedGames.plist"
    private static let settingsFileName = "SavedSettings.plist"
    
    static func getGames() -> [Game]{
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: saveGameFileName).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path){
                do {
                    games = try PropertyListDecoder().decode([Game].self, from: data)
                }catch {
                    print ("property list dedoding error:\(error)")
                }
            }
        } else {
            print("\(saveGameFileName) does not exist")
        }
        return games
    }
    
    static func addGame(game: Game){
        games.append(game)
        saveGame()
    }
    static func deleteGame(game: Game, atIndex index: Int){
        games.remove(at: index)
        saveGame()
    }
    
    static func saveGame(){
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: saveGameFileName)
        do{
            let data = try PropertyListEncoder().encode(games)
            try data.write(to: path, options:  .atomic)
        }catch{
            print("Property list encoding error \(error)")
        }
    }

    static func saveGameAlert(vc: UIViewController){
        let alert = UIAlertController(title: "", message: "Enter Game Name", preferredStyle: .alert)
        alert.addTextField { (TextField) in
            _ = ""
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
            Game.gameName = alert.textFields?.first?.text
            let game = Game.init(gameName: Game.gameName, lengthSelected: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, location: Game.location, dateAndTime: Game.dateAndTime, league: Game.league, refereeNames: Game.refereeNames, caps: Game.caps, extraTime: Game.extraTime, homeTeam: Game.homeTeam, awayTeam: Game.awayTeam, subs: Game.numberOfSubs, homePlayers: Game.homePlayers, awayPlayers: Game.awayPlayers)
            DataPeristanceModel.addGame(game: game)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: false)
    }
//    static func saveSettings() {
//        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: settingsFileName)
//        do{
//            let data = try PropertyListEncoder().encode(settings)
//            try data.write(to: path, options:  .atomic)
//        }catch{
//            print("Property list encoding error \(error)")
//        }
//    }
//    static func changeSettings(vc: UIViewController, userId: String){
//        if let user = usersession.getCurrentUser() {
//            if user.uid == userId{
//                if let userSettings = DataPeristanceModel.loadUserSettings(userID: userId){
//                    let settings = Settings(userID: user.uid, duration: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, subsPerTeam: Game.numberOfSubs, leagueName: Game.league)
//                }
//                
//            }
//            let settings = Settings(userID: user.uid, duration: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, subsPerTeam: Game.numberOfSubs, leagueName: Game.league)
//            self.settings.append(settings)
//        } else {
//            let settings = Settings(userID: "noUser", duration: settingsToSave.duration, numberOfPlayers: settingsToSave.numberOfPlayers, subsPerTeam: settingsToSave.subsPerTeam, leagueName: settingsToSave.leagueName)
//            self.settings.append(settings)
//        }
//        saveSettings()
//        vc.showAlert(title: "Settings Saved", message: nil)
//    }
//    static func loadSettings() -> [Settings] { //USE USER ID AS PARAMETER TO PERSONIFICATE EACH SETTINGS
//        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: settingsFileName).path
//        if FileManager.default.fileExists(atPath: path) {
//            if let data = FileManager.default.contents(atPath: path){
//                do {
//                    settings = try PropertyListDecoder().decode([Settings].self, from: data)
//                }catch {
//                    print ("property list dedoding error:\(error)")
//                }
//            }
//        } else {
//            print("\(settingsFileName) does not exist")
//        }
//        return settings
//    }
//    static func loadUserSettings(userID: String) -> Settings?{
//        loadedSettings = loadSettings()
//        for settings in loadedSettings {
//            if let user = settings.userID{
//                print(user)
//            }
//        }
//        return loadedSettings.filter{$0.userID == userID}.first
//    }
//    static func removeAllSettings() {
//        settings.removeAll()
//        saveSettings()
//    }
}

