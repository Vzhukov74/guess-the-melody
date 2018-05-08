//
//  GTMStaticDataStore.swift
//  guess the melody
//
//  Created by Vlad on 08.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation
import SwiftyBeaver

class GTMStaticDataStore {
    static func openLevelsJsonFileFor(name: String) -> Data? {
        let path = Bundle.main.path(forResource: name, ofType: "json")
        var text = ""
        do {
            text = try String(contentsOfFile: path!, encoding: String.Encoding.utf8)
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
        }
        let data = text.data(using: String.Encoding.utf8)
        return data
    }
    
    static func getLevels() -> [String: AnyObject]? {
        
        guard let data = GTMStaticDataStore.openLevelsJsonFileFor(name: "levels") else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions() ) as? [String: AnyObject]
            return json
        } catch {
            SwiftyBeaver.error(error.localizedDescription)
            return nil
        }
    }
    
    static func getQuestions() -> [String: AnyObject]? {
        
        guard let data = GTMStaticDataStore.openLevelsJsonFileFor(name: "questions") else {
            return nil
        }
        
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions() ) as? [String: AnyObject]
            return json
        } catch {
            return nil
        }
    }
}
