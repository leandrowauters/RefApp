//
//  HomePlayersSelectionViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/16/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class HomePlayersSelectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    
    let graphics = GraphicClient()
    @IBOutlet var numberPadButtons: [UIButton]!
    @IBOutlet weak var numbersCollectionView: UICollectionView!

    
    var number = ""{
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
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
        title = "\(Game.homeTeam) Players"
        numbersCollectionView.delegate = self
        numbersCollectionView.dataSource = self
        scrollToLastIndex()
    }
    
    func scrollToLastIndex(){
        let indextPath = IndexPath(item: Game.homePlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indextPath, at: .centeredHorizontally, animated: true)
    }
    override func viewDidLayoutSubviews() {
        graphics.changeButtonLayout(buttons: numberPadButtons)
    }
    @IBAction func numberPadWasPressed(_ sender: UIButton) {
        
        number.append(Character(sender.tag.description))
//        numbersTextView.text = number

    }

    @IBAction func enterWasPressed(_ sender: UIButton) {
        if number != ""{
        if !homePlayers.contains(Int(number)!){
            homePlayers.append(Int(number)!)
            Game.homePlayers.append(Int(number)!)
            print("Number of players \(Game.homePlayers.count)")
            number = ""
            let indexPath = IndexPath(row: homePlayers.count, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            showAlert(title: "Player Already Entered", message: "Try again")
//            let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hideLabel), userInfo: nil, repeats: true)
            number = ""
            print("Number of players \(Game.homePlayers.count)")
        }
        } else {
            showAlert(title: "Please enter player", message: "Try again")
        }
    }
    @IBAction func backspacePressed(_ sender: UIButton) {
        number.removeLast()
    }
    
    @IBAction func deleteWasPressed(_ sender: UIButton) {
        homePlayers.remove(at: sender.tag)
        Game.homePlayers.remove(at: sender.tag)
        
        let indexPath = IndexPath(row: homePlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePlayers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "numberCell", for: indexPath) as? HomePlayersCollectionViewCell else {return UICollectionViewCell()}
        return HomePlayersCollectionViewCell.setUpCell(collectionView: collectionView, cell: cell, indexPath: indexPath.row, number: number)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize.init(width: 250, height:250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let cellWidth : CGFloat = 250.0
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
