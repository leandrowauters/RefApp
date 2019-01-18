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
    
    var number = ""
    
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
        numbersTextView.text = number
    }
    
    @IBAction func enterWasPressed(_ sender: UIButton) {
        if let text = numbersTextView.text {
            homePlayers.append(Int(text)!)
            number = ""
            numbersTextView.text = ""
            let indexPath = IndexPath(row: homePlayers.count - 1, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePlayers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as? HomePlayersCollectionViewCell else {return UICollectionViewCell()}
        cell.numberLabel.text = homePlayers[indexPath.row].description
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row <= homePlayers.count - 2 {
            return CGSize.init(width: 200 / 1.5, height:225 / 1.5)
        }
        return CGSize.init(width: 200, height:225)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 200.0
//        let cellCount = homePlayers.count
        let leftInsets = (view.frame.size.width / 2) + (cellWidth / 2)
        let rightInstets = (self.view.frame.size.width / 2) - (cellWidth / 2)
//        if cellCount == 1 {
//            leftInsets = (view.frame.size.width / 2) + (cellWidth / 2)
//            return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
//        }
//        let numberOfCells = floor(self.view.frame.size.width / cellWidth)
//        leftInsets = (self.view.frame.size.width - (numberOfCells * cellWidth)) / (numberOfCells + 1)
        return UIEdgeInsets(top: 0, left: leftInsets, bottom: 0, right: rightInstets)
    }


}
