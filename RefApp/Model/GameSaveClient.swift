//
//  GameSaveClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

struct GameSaveClient {
    
//    static var savedGames = [SavedGame]()
    var savedGame: SavedGame
    static var savedGames = [Game]()
//    static var numberOfSaves = UserDefaults.standard.integer(forKey: "numberOfSaves")
//        static var namesOfSaves = [Int: String]()
    static func saveGame(saveName: String) {
        let defaults = UserDefaults.standard
        
//        defaults.set(numberOfSaves, forKey: saveName)
        let gameToSave = Game.init(gameName: saveName, lengthSelected: Game.lengthSelected, numberOfPlayers: Game.numberOfPlayers, location: Game.location, dateAndTime: Game.dateAndTime, league: Game.league, refereeNames: Game.refereeNames, caps: Game.caps, extraTime: Game.extraTime, homeTeam: Game.homeTeam, awayTeam: Game.awayTeam, subs: Game.numberOfSubs, homePlayers: Game.homePlayers, awayPlayers: Game.awayPlayers)
        if let encoded = try? JSONEncoder().encode(gameToSave) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: saveName)
        }
        if let savedGame = defaults.object(forKey: saveName) as? Data {
            if let loadedgame = try? JSONDecoder().decode(Game.self, from: savedGame) {
                let gameToLoad = loadedgame
                GameSaveClient.savedGames.append(gameToLoad)
                for game in GameSaveClient.savedGames {
                    print("The game lenght is: \(game.lengthSelected)")
                }
            }
        }
        let saveGameData = try! JSONEncoder().encode(savedGames)
        UserDefaults.standard.set(saveGameData, forKey: "SavedGames")
//        let savedGame = SavedGame.init(game: game, slot: numberOfSaves, saveName: saveName)
//        savedGames.append(savedGame)
//        if let encoded = try? JSONEncoder().encode(savedGames){
//            let defaults = UserDefaults.standard
//            defaults.set(encoded, forKey: "savedGames")
//        }
//        if let savedGames = defaults.object(forKey: "savedGames") as? Data {
//            if let loadedgames = try? JSONDecoder().decode([SavedGame].self, from: savedGames){
//                self.savedGames = loadedgames
//                for game in self.savedGames{
//                    print(game.saveName)
//                }
//                print(self.savedGames.count)
//            }
//        }
//        print(savedGame.game.lengthSelected)
    }
//        static func retriveGame() ->[SavedGame] { //retrive this is for the previous, I might use it later
//            let defaults = UserDefaults.standard
//            let array = defaults.array(forKey: "savedGame")  as? [SavedGame] ?? [SavedGame]()
//            return array
//        }
    static func retriveGame() ->[Game] { //retrive this is for the previous, I might use it later
        let defaults = UserDefaults.standard
        let array = defaults.array(forKey: "SavedGames")  as? [Game] ?? [Game]()
        return array
    }
    public static func getSavedGames() -> [Game]?{
        let savedGamesData = UserDefaults.standard.data(forKey: "SavedGames")
        let savedGamesArray = try! JSONDecoder().decode([Game].self, from: savedGamesData!)
        return savedGamesArray
    }
    
    static func printAllDefaults(){
        for (key, value) in UserDefaults.standard.dictionaryRepresentation() {
            print("\(key) = \(value) \n")
        }
    }
    static func alert(vc: UIViewController){
        let alert = UIAlertController(title: "", message: "Enter Game Name", preferredStyle: .alert)
        alert.addTextField { (TextField) in
            _ = ""
        }
        alert.addAction(UIAlertAction(title: "Save", style: .default, handler: { (updateAction) in
//            let defaults = UserDefaults.standard
//            defaults.removeObject(forKey: (alert.textFields?.first?.text)!) //remove 
            saveGame(saveName: (alert.textFields?.first?.text)!)
            printAllDefaults()
//            GameSaveClient.numberOfSaves += 1
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        vc.present(alert, animated: false)
    }
}
class SavedGame: Codable {
    var game: Game
    var slot: Int
    var saveName: String
    
    init(game: Game, slot: Int, saveName: String) {
        self.game = game
        self.slot = slot
        self.saveName = saveName
    }
}
