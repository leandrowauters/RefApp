//
//  GameClient.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/21/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

struct GameClient {
    static func printValues (){
        print("Location: \(Game.location)")
        print("Number Of Players: \(Game.numberOfPlayers)")
        print("Legue: \(Game.league)")
        print("Referee \(Game.refereeNames)")
        print("Length: \(Game.lengthSelected)")
        print("Home Team: \(Game.homeTeam)")
        print("Away Team: \(Game.awayTeam)")
        print("Date: \(Game.dateAndTime)")
        print("Extra Time? \(Game.extraTime)")
    }

    static func convertLocalDateToString(str: String, dateFormat: String) -> String {
        // Making a Date from a String
        let dateString = str
        var dateToReturn = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        //        dateFormatter.timeZone = T
        if let date2 = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = dateFormat
            dateToReturn = date2
        }
        dateFormatter.timeZone = TimeZone.current
        return dateFormatter.string(from: dateToReturn)
    }
    func convertIntArrayToString(array: [Int]) -> String? {
        var sentenceToReturn: String?
        for number in array {
            if sentenceToReturn == nil {
                sentenceToReturn = number.description
            } else {
                sentenceToReturn = sentenceToReturn! + ", " + number.description
            }
        }
        return sentenceToReturn
    }
    func convertStringArrayToString(array: [String]) -> String? {
        var sentenceToReturn: String?
        for word in array {
            if sentenceToReturn == nil {
                sentenceToReturn = word
            } else {
                sentenceToReturn = sentenceToReturn! + ", " + word.description
            }
        }
        return sentenceToReturn
    }

    func checkForExtraTime(bool: Bool) -> String{
        if bool {
            return "Yes"
        } else {
            return "No"
        }
    }
    func attributedText(wordsToBold: String, string: String, fontSize: CGFloat) -> NSAttributedString {
        
        let string = string as NSString
        
        let attributedString = NSMutableAttributedString(string: string as String, attributes: [NSAttributedString.Key.font:UIFont.systemFont(ofSize: fontSize)])
        
        let boldFontAttribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: fontSize)]
        
        // Part of string to be bold
        attributedString.addAttributes(boldFontAttribute, range: string.range(of: wordsToBold))

        
        // 4
        return attributedString
    }
    func checkForYellowCardDuplicates(playerToCheck: Int, yellowCardPlayers: [Int]) -> Bool {
        var count = 0
        for player in yellowCardPlayers {
            if playerToCheck == player{
                count += 1
            }
        }
        if count == 2{
            return true
        }
        return false
    }
}
