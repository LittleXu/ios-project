//
//  Movie.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import Foundation
import ObjectMapper

class Movie: Mappable {
    required init?(map: ObjectMapper.Map) {
        region <- map["region"]
        category <- map["category"]
        actors <- map["actors"]
        score <- map["score"]
        star <- map["star"]
        img <- map["img"]
        subject <- map["subject"]
        votecount <- map["votecount"]
        director <- map["director"]
        title <- map["title"]
        duration <- map["duration"]
        showed <- map["showed"]
        release <- map["release"]
        enough <- map["enough"]
    }
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
    var region = ""
    var category = ""
    var actors = ""
    var star = ""
    var img = ""
    var subject = ""
    var votecount = ""
    var score = ""
    var director = ""
    var title = ""
    var duration = ""
    var showed = ""
    var release = ""
    var enough = ""
}
