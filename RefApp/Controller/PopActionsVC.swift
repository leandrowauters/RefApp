//
//  PopActionsVC.swift
//  RefApp
//
//  Created by Leandro Wauters on 12/28/18.
//  Copyright © 2018 Leandro Wauters. All rights reserved.
//

import UIKit

class PopActionsVC: UIViewController {

    var playerSelected = Int()
    var selectedButton = Int()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(playerSelected)
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(goBack))
        view.addGestureRecognizer(tap)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let destination = segue.destination as? SelectPlayerVC else {return}
        destination.selectedPlayer = playerSelected
        destination.selectedButton = selectedButton
    }
    @objc func goBack(){
        dismiss(animated: true, completion: nil)
    }


}
