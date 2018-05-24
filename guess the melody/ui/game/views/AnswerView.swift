//
//  AnswerView.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class AnswerView: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private var authorName = UILabel() 
    private var songName = UILabel()
    
    var index: Int = 0
    
    func setData(data: GTMAnswerData) {
        authorName.text = data.authorName
        songName.text = data.songName
    }
    
    private func setup() {
        addConstarain()
        configureLabels()
    }
    
    private func addConstarain() {
        authorName.translatesAutoresizingMaskIntoConstraints = false
        songName.translatesAutoresizingMaskIntoConstraints = false
        
        self.addSubview(authorName)
        self.addSubview(songName)
        
        let authorNameConstrains = [authorName.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
                                    authorName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                                    authorName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)]
        
        let songNameConstrains = [songName.topAnchor.constraint(equalTo: authorName.topAnchor, constant: 10),
                                  songName.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
                                  songName.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0),
                                  songName.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)]
        
        NSLayoutConstraint.activate(authorNameConstrains)
        NSLayoutConstraint.activate(songNameConstrains)
    }
    
    private func configureView() {
        self.backgroundColor = UIColor.clear
    }
    
    private func configureLabels() {
        authorName.textAlignment = .center
        authorName.font = GTMFonts.sfProDisplayRegular_14
        authorName.textColor = Colors.mainTextColor
        
        songName.textAlignment = .center
        songName.font = GTMFonts.sfProDisplayRegular_14
        songName.textColor = Colors.mainTextColor
    }
}
