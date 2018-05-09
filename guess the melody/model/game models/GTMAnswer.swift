//
//  GTMAnswer.swift
//  guess the melody
//
//  Created by Vlad on 09.05.2018.
//  Copyright © 2018 VZ. All rights reserved.
//

import Foundation

class GTMAnswer {
    var author: String = ""
    var songName: String = ""
    var albumImageUrl: String = ""
    var songUrl: String = ""
    
    func setData(author : String, songName : String, albumImageUrl : String, songUrl : String) {
        self.author = author
        self.songName = songName
        self.albumImageUrl = albumImageUrl
        self.songUrl = songUrl
    }
    
    func setData(data : [String : AnyObject]) {
        self.author = data["author"] as? String ?? ""
        self.songName = data["songName"] as? String ?? ""
        self.albumImageUrl = data["albumImageUrl"] as? String ?? ""
        self.songUrl = data["songUrl"] as? String ?? ""
    }
}
