//
//  AwayPlayersCollectionViewCell.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class AwayPlayersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var okayButton: UIButton!

    static func setUpCell(collectionView: UICollectionView, cell: AwayPlayersCollectionViewCell, indexPath row: Int, number: String) -> AwayPlayersCollectionViewCell{
        
        cell.layer.borderWidth = 10
        cell.layer.borderColor = UIColor.white.cgColor
        cell.layer.cornerRadius = 35
        cell.layer.masksToBounds = true
        cell.playerNumberLabel.text = number
        cell.deleteButton.tag = row
        //       if homePlayers.count + 1 == 1 {
        //            cell.deleteButton.isHidden = false
        //        } else {
        //            cell.deleteButton.isHidden = true
        //        }
        if cell.playerNumberLabel.text != "" {
            cell.deleteButton.isEnabled = true
        } else {
            cell.deleteButton.isEnabled = false
        }
        
        if cell.deleteButton.tag <= Game.awayPlayers.count - 1 {
            cell.playerNumberLabel.text = Game.awayPlayers[row].description
            cell.okayButton.isHidden = true
            cell.deleteButton.isEnabled = true
        }
        if cell.deleteButton.tag == Game.numberOfPlayers{
            cell.okayButton.isHidden = false
            cell.playerNumberLabel.isHidden = true
            //            cell.deleteButton.isHidden = true
        } else {
            cell.okayButton.isHidden = true
            cell.playerNumberLabel.isHidden = false
            
        }
        //        cell.numberLabel.text = homePlayers[indexPath.row].description
        return cell
    }
}

