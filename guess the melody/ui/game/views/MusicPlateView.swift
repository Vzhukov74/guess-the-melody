//
//  MusicPlateView.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

class MusicPlateView: UIView {
    enum Spin {
        case pi
        case zero
    }
    
    private var isSpinnig = false
    private var spin: Spin = .zero
    private var angle: Double = 0
    
    override func draw(_ rect: CGRect) {
        
        let width = bounds.width
        let height = bounds.height / 8
        
        let center = CGPoint(x: bounds.width / 2, y: bounds.height / 2)
        
        let radius: CGFloat = (bounds.width / 2) / 8
        
        let startAngle: CGFloat = 0
        let endAngle: CGFloat = 2 * .pi
        
        let path0 = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: width, height: height), cornerRadius: 0)
        path0.lineWidth = height
        let color0 = Colors.musicPlate0
        color0.setStroke()
        path0.stroke()
        
        let path1 = UIBezierPath(roundedRect: CGRect(x: 0, y: height, width: width, height: height), cornerRadius: 0)
        path1.lineWidth = height
        let color1 = Colors.musicPlate1
        color1.setStroke()
        path1.stroke()
        
        let path2 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 2, width: width, height: height), cornerRadius: 0)
        path2.lineWidth = height
        let color2 = Colors.musicPlate2
        color2.setStroke()
        path2.stroke()
        
        let path3 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 3, width: width, height: height), cornerRadius: 0)
        path3.lineWidth = height
        let color3 = Colors.musicPlate3
        color3.setStroke()
        path3.stroke()
        
        let path4 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 4, width: width, height: height), cornerRadius: 0)
        path4.lineWidth = height
        let color4 = Colors.musicPlate4
        color4.setStroke()
        path4.stroke()
        
        let path5 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 5, width: width, height: height), cornerRadius: 0)
        path5.lineWidth = height
        let color5 = Colors.musicPlate5
        color5.setStroke()
        path5.stroke()
        
        let path6 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 6, width: width, height: height), cornerRadius: 0)
        path6.lineWidth = height
        let color6 = Colors.musicPlate6
        color6.setStroke()
        path6.stroke()
        
        let path7 = UIBezierPath(roundedRect: CGRect(x: 0, y: height * 7, width: width, height: height), cornerRadius: 0)
        path7.lineWidth = height
        let color7 = Colors.musicPlate7
        color7.setStroke()
        path7.stroke()
        
        let path8 = UIBezierPath(arcCenter: center,
                                radius: radius,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true)

        path8.lineWidth = radius

        let color8 = UIColor.white
        color8.setStroke()
        color8.setFill()
        path8.stroke()
        path8.fill()
        
        let circle = UIBezierPath()
        circle.addArc(withCenter: center, radius: rect.width / 2, startAngle: 0, endAngle: 2 * .pi, clockwise: true)
        UIColor.clear.setFill()
        circle.fill()
        let circleLayer = CAShapeLayer()
        circleLayer.path = circle.cgPath
        self.layer.mask = circleLayer
    }
    
    func startSpin() {
        if !isSpinnig {
            isSpinnig = true
            spinWith(options: .curveEaseIn)
        }
    }
    
    func stopSpin() {
        isSpinnig = false
    }
    
    private func spinWith(options: UIViewAnimationOptions) {
        UIView.animate(withDuration: 0.2, delay: 0, options: options, animations: {
            self.angle += .pi / 2
            
            if self.angle > 2 * .pi {
                self.angle = 0
            }
 
            self.transform = CGAffineTransform(rotationAngle: CGFloat(self.angle))
        }) { (_) in
            if self.isSpinnig {
                self.spinWith(options: .curveLinear)
            } else if options != .curveEaseOut {
                self.spinWith(options: .curveEaseOut)
            }
        }
    }
}
