//
//  Movie.swift
//  ios-project
//
//  Created by liuxu on 2025/1/13.
//

import Foundation
import ObjectMapper

class Comment: Mappable {
    required init?(map: ObjectMapper.Map) {
        id <- map["id"]
        avatar <- map["avatar"]
        vote_count <- map["vote_count"]
        nick_name <- map["nick_name"]
        rating <- map["rating"]
        comment_time <- map["comment_time"]
        comment_location <- map["comment_location"]
        comment_content <- map["comment_content"]
        from <- map["from"]
    }
    
    func mapping(map: ObjectMapper.Map) {
        
    }
    
    var id = 0
    var avatar = ""
    var vote_count = ""
    var nick_name = ""
    var rating = 0
    var comment_time = ""
    var comment_location = ""
    var comment_content = ""
    var from = ""
}
