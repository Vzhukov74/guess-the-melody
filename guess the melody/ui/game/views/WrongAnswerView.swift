//
//  WrongAnswerView.swift
//  guess the melody
//
//  Created by Maximal Mac on 24.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class WrongAnswerView: UIView {
    
    var nextAction: (() -> Void)?
    
    private let nextButton = UIButton()
    private let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        backgroundColor = Colors.alertBackground
        
        self.addSubview(nextButton)
        self.addSubview(titleLabel)
        
        setConstrains()
        
        titleLabel.text = "It is wrong answer!"
        titleLabel.textAlignment = .center
        titleLabel.textColor = UIColor.white
        titleLabel.font = GTMFonts.sfProDisplayRegular_16
        nextButton.setTitle("Next question!", for: .normal)
        nextButton.titleLabel?.font = GTMFonts.sfProDisplayRegular_20
        nextButton.contentMode = .center
        nextButton.tintColor = Colors.mainTextColor
        
        nextButton.addTarget(self, action: #selector(self.nextButtonAction), for: .touchUpInside)
    }
    
    private func setConstrains() {
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let nextButtonConstrains = [nextButton.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20), nextButton.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20), nextButton.heightAnchor.constraint(equalToConstant: 50), nextButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -12)]
        let titleLabelConstrains = [titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20), titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20), titleLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 12)]
        
        NSLayoutConstraint.activate(nextButtonConstrains)
        NSLayoutConstraint.activate(titleLabelConstrains)
    }
}

@objc extension WrongAnswerView {
    func nextButtonAction() {
        nextAction?()
    }
}
