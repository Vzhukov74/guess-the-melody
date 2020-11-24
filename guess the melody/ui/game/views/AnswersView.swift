//
//  AnswersView.swift
//  guess the melody
//
//  Created by Vlad on 08.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class AnswersView: UIView {

    private var answer0View = AnswerView()
    private var answer1View = AnswerView()
    private var answer2View = AnswerView()
    private var answer3View = AnswerView()
    private var swapButton = UIButton()
    
    private var answer0ViewCenterConstrain: NSLayoutConstraint!
    private var answer1ViewCenterConstrain: NSLayoutConstraint!
    private var answer2ViewCenterConstrain: NSLayoutConstraint!
    private var answer3ViewCenterConstrain: NSLayoutConstraint!
    
    private var swapIsLock = false
    private var answersIsHide = false
    
    var isLock: Bool = false
    var userDidAnswer: ((_ index: Int) -> Bool)?
    var userDidSwap: (() -> Bool)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    private func setup() {
        setupViews()
        addViewOnSuperView()
        configureButton()
        addConstarain()
    }
    
    private func setupViews() {
        answer0View.index = 0
        answer0View.isUserInteractionEnabled = true
        answer0View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView(_:))))
        
        answer1View.index = 1
        answer1View.isUserInteractionEnabled = true
        answer1View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView(_:))))
        
        answer2View.index = 2
        answer2View.isUserInteractionEnabled = true
        answer2View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView(_:))))
        
        answer3View.index = 3
        answer3View.isUserInteractionEnabled = true
        answer3View.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapOnView(_:))))
        
        answer0View.translatesAutoresizingMaskIntoConstraints = false
        answer1View.translatesAutoresizingMaskIntoConstraints = false
        answer2View.translatesAutoresizingMaskIntoConstraints = false
        answer3View.translatesAutoresizingMaskIntoConstraints = false
        swapButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addViewOnSuperView() {
        addSubview(answer0View)
        addSubview(answer1View)
        addSubview(answer2View)
        addSubview(answer3View)
        addSubview(swapButton)
    }
    
    private func configureButton() {
        swapButton.setTitle("swap", for: .normal)
        swapButton.titleLabel?.font = GTMFonts.sfProDisplayBold_16
        swapButton.setTitleColor(Colors.alertLoseBackground, for: .normal)
        swapButton.addTarget(self, action: #selector(self.useDidSwap), for: .touchUpInside)
    }
    
    private func addConstarain() {
        answer0ViewCenterConstrain = answer0View.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        answer1ViewCenterConstrain = answer1View.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        answer2ViewCenterConstrain = answer2View.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        answer3ViewCenterConstrain = answer3View.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0)
        
        let answer0ViewConstrains = [answer0ViewCenterConstrain, answer0View.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8), answer0View.topAnchor.constraint(equalTo: self.topAnchor, constant: 0), answer0View.heightAnchor.constraint(equalToConstant: 40)]
        
        let answer1ViewConstrains = [answer1ViewCenterConstrain, answer1View.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8), answer1View.topAnchor.constraint(equalTo: answer0View.bottomAnchor, constant: 10), answer1View.heightAnchor.constraint(equalToConstant: 40)]
        
        let answer2ViewConstrains = [answer2ViewCenterConstrain, answer2View.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8), answer2View.topAnchor.constraint(equalTo: answer1View.bottomAnchor, constant: 10), answer2View.heightAnchor.constraint(equalToConstant: 40)]
        
        let answer3ViewConstrains = [answer3ViewCenterConstrain, answer3View.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.8), answer3View.topAnchor.constraint(equalTo: answer2View.bottomAnchor, constant: 10), answer3View.heightAnchor.constraint(equalToConstant: 40)]
        
        let swapButtonConstrains = [swapButton.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0), swapButton.topAnchor.constraint(equalTo: answer3View.bottomAnchor, constant: 10), swapButton.heightAnchor.constraint(equalToConstant: 40), swapButton.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0)]
        
        NSLayoutConstraint.activate(answer0ViewConstrains as! [NSLayoutConstraint])
        NSLayoutConstraint.activate(answer1ViewConstrains as! [NSLayoutConstraint])
        NSLayoutConstraint.activate(answer2ViewConstrains as! [NSLayoutConstraint])
        NSLayoutConstraint.activate(answer3ViewConstrains as! [NSLayoutConstraint])
        NSLayoutConstraint.activate(swapButtonConstrains)
    }
    
    func setData(data: [GTMAnswerData]) {
        //self.animateWith(data: data)
        unhideAnswers(data: data)
    }
    
    func configureSwapButton(swapsLeft: Int, swapsTotal: Int) {
        swapIsLock = swapsLeft == 0
        
        self.swapButton.setTitle("Swaps: \(String(swapsLeft))/\(String(swapsTotal))" as String, for: .normal)
    }
    
    private func animateWith(data: [GTMAnswerData]) {
        hideAnswers {
            self.unhideAnswers(data: data)
        }
    }
    
    private func spin(view: UIView) {
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: { (_) in
            UIView.animate(withDuration: 0.2) {
                view.transform = CGAffineTransform(rotationAngle: 0)
            }
        })
    }

    private func shake(view: UIView) {

    }
    
    private func hideAnswers(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.transitionFlipFromTop, .curveEaseInOut], animations: {
            self.answer0ViewCenterConstrain.constant = UIScreen.main.bounds.width
            self.answer1ViewCenterConstrain.constant = -UIScreen.main.bounds.width
            self.answer2ViewCenterConstrain.constant = UIScreen.main.bounds.width
            self.answer3ViewCenterConstrain.constant = -UIScreen.main.bounds.width
            self.layoutIfNeeded()
        }, completion: { (_) in
            completion?()
        })
    }
    
    private func unhideAnswers(data: [GTMAnswerData]) {
        self.answer0View.isHidden = true
        self.answer1View.isHidden = true
        self.answer2View.isHidden = true
        self.answer3View.isHidden = true
        
        self.answer0ViewCenterConstrain.constant = -UIScreen.main.bounds.width
        self.answer1ViewCenterConstrain.constant = UIScreen.main.bounds.width
        self.answer2ViewCenterConstrain.constant = -UIScreen.main.bounds.width
        self.answer3ViewCenterConstrain.constant = UIScreen.main.bounds.width
        
        self.layoutIfNeeded()
        
        self.answer0View.setData(data: data[self.answer0View.index])
        self.answer1View.setData(data: data[self.answer1View.index])
        self.answer2View.setData(data: data[self.answer2View.index])
        self.answer3View.setData(data: data[self.answer3View.index])
        
        self.answer0View.isHidden = false
        self.answer1View.isHidden = false
        self.answer2View.isHidden = false
        self.answer3View.isHidden = false
        
        UIView.animate(withDuration: 0.5, delay: 0.1, options: [.transitionFlipFromTop, .curveEaseInOut], animations: {
        
            self.answer0ViewCenterConstrain.constant = 0
            self.answer1ViewCenterConstrain.constant = 0
            self.answer2ViewCenterConstrain.constant = 0
            self.answer3ViewCenterConstrain.constant = 0
        
            self.layoutIfNeeded()
    })
    }
}

@objc extension AnswersView {
    private func didTapOnView(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? AnswerView else { return }
        self.useDidAnswer(index: view.index)
    }
    
    private func useDidAnswer(index: Int) {
        assert(index < 4)
        guard userDidAnswer != nil, !isLock else { return }
        
        if self.userDidAnswer!(index) {
            self.hideAnswers(completion: nil)
        }
    }
    
    private func useDidSwap() {
        guard userDidSwap != nil, !isLock else { return }
        
        if swapIsLock {
            //SwiftyBeaver.debug("add here shake animation!")
            //self.shake(view: self.swapButton)
        } else {
            if self.userDidSwap!() {
                self.spin(view: self.swapButton)
            }
        }
    }
}
