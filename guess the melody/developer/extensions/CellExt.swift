//
//  CellExt.swift
//  guess the melody
//
//  Created by Vlad on 04.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import UIKit

protocol CellRegistable { }

extension CellRegistable {
    static func register(table: UITableView) {
        table.register(UINib.init(nibName: String(describing: self), bundle: nil), forCellReuseIdentifier: String(describing: self))
    }
    
    static func register(collectionView : UICollectionView) {
        let nib = UINib.init(nibName: String(describing: self), bundle: nil)
        let identifier = String(describing: self)
        
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
}

protocol CellDequeueReusable { }

extension CellDequeueReusable {
    static func cell(table: UITableView, indexPath: IndexPath) -> Self {
        let cell = table.dequeueReusableCell(withIdentifier: String(describing: self), for: indexPath) as! Self
        return cell
    }
    
    static func cell(collectionView : UICollectionView, indexPath: IndexPath) -> Self {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: self), for: indexPath) as! Self
        return cell
    }
}
