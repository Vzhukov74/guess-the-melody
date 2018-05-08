//
//  AlbumImageView.swift
//  guess the melody
//
//  Created by Vlad on 07.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class AlbumImageView: UIImageView {
    override func draw(_ rect: CGRect) {
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        let radius: CGFloat = (bounds.width / 2) / 8
        
        let path = UIBezierPath()
        path.addArc(withCenter: center, radius: radius, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setFill()
        path.fill()
    }
    
    func makeCurcular(_ rect: CGRect) {
        let circle = UIBezierPath()
        let center = CGPoint(x: rect.width / 2, y: rect.height / 2)
        circle.addArc(withCenter: center, radius: rect.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.white.setFill()
        circle.fill()
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.cgPath
        self.layer.mask = circleLayer
    }
}
