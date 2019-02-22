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
    private static let filename = "SavedGames.plist"
    
    static func getGames() -> [Game]{
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: filename).path
        if FileManager.default.fileExists(atPath: path) {
            if let data = FileManager.default.contents(atPath: path){
                do {
                    games = try PropertyListDecoder().decode([Game].self, from: data)
                }catch {
                    print ("property list dedoding error:\(error)")
                }
            }
        } else {
            print("\(filename) does not exist")
        }
        return games
    }
    
    static func addGame(game: Game){
        games.append(game)
        save()
    }
    static func deleteGame(game: Game, atIndex index: Int){
        games.remove(at: index)
        save()
    }
    
    static func save(){
        let path = DataPersistanceManager.filepathToDocumentsDirectory(filename: filename)
        do{
            let data = try PropertyListEncoder().encode(games)
            try data.write(to: path, options:  .atomic)
        }catch{
            print("Property list encoding error \(error)")
        }
    }

    static func saveGame(vc: UIViewController){
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
