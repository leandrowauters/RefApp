//
//  HomePlayersSelectionViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/16/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HomePlayersSelectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    

    @IBOutlet var numberPadButtons: [UIButton]!
    @IBOutlet weak var numbersCollectionView: UICollectionView!
//    @IBOutlet weak var numbersTextView: UITextView!
    
    var number = ""{
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
                print(Game.numberOfPlayers)
            }
        }
    }
    
    var homePlayers = Game.homePlayers {
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        numbersCollectionView.delegate = self
        numbersCollectionView.dataSource = self
    }
    @IBAction func numberPadWasPressed(_ sender: UIButton) {
        number.append(Character(sender.tag.description))
//        numbersTextView.text = number

    }
    
    @IBAction func enterWasPressed(_ sender: UIButton) {
            homePlayers.append(Int(number)!)
            Game.homePlayers.append(Int(number)!)
            print(Game.homePlayers.count)
            number = ""
//            print(homePlayers[0])
//            numbersTextView.text = ""
            let indexPath = IndexPath(row: homePlayers.count, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        

    }
    @IBAction func deleteWasPressed(_ sender: UIButton) {
        homePlayers.remove(at: sender.tag)
        let indexPath = IndexPath(row: homePlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    @IBAction func deletePlayerWasPressed(_ sender: UIBarButtonItem) {

    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePlayers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as? HomePlayersCollectionViewCell else {return UICollectionViewCell()}
        
        cell.playerNumberLabel.text = number
        cell.deleteButton.tag = indexPath.row
        print("INDEX PATH: \(indexPath.row)")
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
        
        if cell.deleteButton.tag <= homePlayers.count - 1 {
            cell.playerNumberLabel.text = homePlayers[indexPath.row].description
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
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 365, height:247)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 365.0
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
//        var leftInsets = (view.frame.size.width / 2) + (cellWidth / 2)
        let rightInstets = (self.view.frame.size.width / 2) - (cellWidth / 2)
//        if homePlayers.count + 1 == 1 || homePlayers.count == 0{
        
        let leftInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
//            return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
//        }
        return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
    }

    

}
