//
//  NoteHalfTimeView.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/5/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class NoteHalfTimeView: UIView {
    
    lazy var notesTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.9770962596, green: 1, blue: 0.8907805085, alpha: 1)
        textView.text = "Tap to enter notes..."
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    lazy var doneButton: UIButton = {
        var button = UIButton()
        button.setTitle("Done", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.354026258, green: 0.7636645436, blue: 0.9697399735, alpha: 1)
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 0.2737779021, green: 0.4506875277, blue: 0.6578510404, alpha: 1)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addButton()
        addTextView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func addButton() {
        addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        doneButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        doneButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        doneButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func addTextView() {
        addSubview(notesTextView)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: doneButton.topAnchor).isActive = true
    }

}
