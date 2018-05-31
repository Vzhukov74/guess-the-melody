//
//  LabelsSetting.swift
//  guess the melody
//
//  Created by Maximal Mac on 31.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

enum LabelType {
    case cellTitle
    case cellInfoLabel
    case cellInfo
    case cellLockTitle

    static let `default` = LabelType.cellInfo
}

extension UILabel {
    
    fileprivate struct AssociatedKeys {
        static fileprivate var type: UInt8 = 0
    }
    
    var type: LabelType {
        get {
            if let returnValue = objc_getAssociatedObject(self, &AssociatedKeys.type) as? LabelType {
                return returnValue
            }
            return LabelType.default
        }
        set {
            objc_setAssociatedObject(self, &AssociatedKeys.type, newValue as LabelType, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            
            switch type {
            case .cellTitle:
                self.textAlignment = .center
                self.font = GTMFonts.sfProDisplayRegular_16
                self.textColor = Colors.mainTextColor
            case .cellInfoLabel:
                self.textAlignment = .center
                self.font = GTMFonts.sfProDisplayRegular_16
                self.textColor = Colors.mainTextColor
            case .cellInfo:
                self.textAlignment = .center
                self.font = GTMFonts.sfProDisplayLight_14
                self.textColor = Colors.mainTextColor
            case .cellLockTitle:
                self.textAlignment = .center
                self.font = GTMFonts.sfProDisplayRegular_16
                self.textColor = UIColor.white
            }
        }
    }
}
