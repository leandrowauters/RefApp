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
    @IBOutlet weak var numbersTextView: UITextView!
    
    var number = ""{
        didSet{
            print("Did Set Works!!")
            DispatchQueue.main.async {
                
                self.numbersCollectionView.reloadData()
                
            }
        }
    }
    
    var homePlayers = Game.homePlayers {
        didSet{
            print("Did Set Works!!")
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
        let indexPath = IndexPath(row: homePlayers.count, section: 0)
        guard let cell = numbersCollectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as? HomePlayersCollectionViewCell else {fatalError("No cell")}
        cell.playerNumberTextView.text = number
    }
    
    @IBAction func enterWasPressed(_ sender: UIButton) {
            homePlayers.append(Int(number)!)
            number = ""
            print(homePlayers[0])
            numbersTextView.text = ""
            let indexPath = IndexPath(row: homePlayers.count, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePlayers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as? HomePlayersCollectionViewCell else {return UICollectionViewCell()}
        cell.playerNumberTextView.text = number
//        cell.numberLabel.text = homePlayers[indexPath.row].description
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 250, height:225)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 250.0
        var leftInsets = (view.frame.size.width / 2) + (cellWidth / 2)
        let rightInstets = (self.view.frame.size.width / 2) - (cellWidth / 2)
        if homePlayers.count + 1 == 1 {
        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
        leftInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
            return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
        }
        return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
    }
    

}
