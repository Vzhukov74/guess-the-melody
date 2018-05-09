//
//  GTMHelper.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMHelper {
    class func randomizeArray<T>(array: [T]) -> [T] {
        var result = [T]()
        
        let randomNumbers: NSMutableSet = []
        
        for _ in 0...(array.count - 1) {
            var random: Int = 0
            repeat {
                random = Int(arc4random_uniform((UInt32(array.count))))
            } while randomNumbers.contains(random)
            randomNumbers.add(random)
            
            let randomObj = array[random]
            result.append(randomObj)
        }
        return result
    }
}
