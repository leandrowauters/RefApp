//
//  EventVCTextView.swift
//  RefApp
//
//  Created by Leandro Wauters on 2/12/19.
//  Copyright © 2019 Leandro Wauters. All rights reserved.
//

import UIKit

class EventVCTextView: UIView {

    lazy var notesTextView: UITextView = {
        var textView = UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.9770962596, green: 1, blue: 0.8907805085, alpha: 1)
        textView.textColor = UIColor.lightGray
        textView.font = UIFont.systemFont(ofSize: 15)
        return textView
    }()
    
    lazy var enterTextButton: UIButton = {
        var button = UIButton()
        button.setTitle("Enter Note", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.2737779021, green: 0.4506875277, blue: 0.6578510404, alpha: 1)
        button.layer.borderWidth = 5
        button.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
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
        addSubview(enterTextButton)
        enterTextButton.translatesAutoresizingMaskIntoConstraints = false
        enterTextButton.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        enterTextButton.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        enterTextButton.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        enterTextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func addTextView() {
        addSubview(notesTextView)
        notesTextView.translatesAutoresizingMaskIntoConstraints = false
        notesTextView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        notesTextView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        notesTextView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        notesTextView.bottomAnchor.constraint(equalTo: enterTextButton.topAnchor).isActive = true
    }

}
