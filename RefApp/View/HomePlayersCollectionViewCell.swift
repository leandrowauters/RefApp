//
//  HomePlayersCollectionViewCell.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/16/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HomePlayersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var playerNumberLabel: UILabel!
    @IBOutlet weak var okayButton: UIButton!
    
    
    static func setUpCell(collectionView: UICollectionView, cell: HomePlayersCollectionViewCell, indexPath row: Int, number: String) -> HomePlayersCollectionViewCell{

        
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
        
        if cell.deleteButton.tag <= Game.homePlayers.count - 1 {
            cell.playerNumberLabel.text = Game.homePlayers[row].description
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

