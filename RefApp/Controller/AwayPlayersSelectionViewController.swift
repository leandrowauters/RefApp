//
//  AwayPlayersSelectionViewController.swift
//  RefApp
//
//  Created by Leandro Wauters on 1/22/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class AwayPlayersSelectionViewController: UIViewController,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout  {

    let graphics = GraphicClient()
    
    @IBOutlet var numberPadButtons: [UIButton]!
    @IBOutlet weak var numbersCollectionView: UICollectionView!
    @IBOutlet weak var playerEnteredLabel: UILabel!
    
    
    var number = ""{
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
            }
        }
    }
    
    var awayPlayers = Game.awayPlayers {
        didSet{
            DispatchQueue.main.async {
                self.numbersCollectionView.reloadData()
            }
        }
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(Game.awayTeam) Players"
        numbersCollectionView.delegate = self
        numbersCollectionView.dataSource = self

    }
    

    override func viewDidLayoutSubviews() {
        graphics.changeButtonLayout(buttons: numberPadButtons)
    }
    @IBAction func numberPadWasPressed(_ sender: UIButton) {
        number.append(Character(sender.tag.description))
        //        numbersTextView.text = number
        
    }
    @objc func hideLabel() {
        playerEnteredLabel.isHidden = true
    }
    @IBAction func okayWasPressed(_ sender: UIButton) {
        let alert = UIAlertController(title:"Are You Sure?" , message: "Once The Game Begins Settings Cannot Be Change" , preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { (updateAction) in
            let storyboard: UIStoryboard = UIStoryboard (name: "Main", bundle: nil)
            guard let vc = storyboard.instantiateViewController(withIdentifier: "mainGame") as? MainGameVC else {return}
            self.present(vc, animated: true, completion: nil)
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Save For Later", style: .default, handler: { (UIAlertAction) in
                DataPeristanceModel.saveGame(vc: self)
        }))
        self.present(alert, animated: false)
    }
    
    @IBAction func enterWasPressed(_ sender: UIButton) {
        if !awayPlayers.contains(Int(number)!){
            awayPlayers.append(Int(number)!)
            Game.awayPlayers.append(Int(number)!)
            number = ""
            let indexPath = IndexPath(row: awayPlayers.count, section: 0)
            numbersCollectionView.insertItems(at: [indexPath])
            numbersCollectionView.layoutIfNeeded()
            numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        } else {
            playerEnteredLabel.isHidden = false
            let _: Timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(hideLabel), userInfo: nil, repeats: true)
            number = ""
            print("Number of players \(Game.awayPlayers.count)")
        }
    }
    @IBAction func backspacePressed(_ sender: UIButton) {
        number.removeLast()
    }
    
    @IBAction func deleteWasPressed(_ sender: UIButton) {
        awayPlayers.remove(at: sender.tag)
        Game.awayPlayers.remove(at: sender.tag)
        
        let indexPath = IndexPath(row: awayPlayers.count, section: 0)
        numbersCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return awayPlayers.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AwayCell", for: indexPath) as? AwayPlayersCollectionViewCell else {return UICollectionViewCell()}
        return AwayPlayersCollectionViewCell.setUpCell(collectionView: collectionView, cell: cell, indexPath: indexPath.row, number: number)
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
