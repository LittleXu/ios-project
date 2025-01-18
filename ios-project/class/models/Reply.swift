//
//  Reply.swift
//  ios-project
//
//  Created by liuxu on 2025/1/15.
//

import Foundation
import ObjectMapper
class CommentReply {
    var comment_from = ""
    var comment_content = ""
    var content = ""
    var time = ""
    // 是否是举报
    var isReport = false
    // 是否是电影
    var isMovie = false
        
    convenience init(json: [String: Any]) {
        self.init()
        self.comment_from = json["comment_from"] as? String ?? ""
        self.comment_content = json["comment_content"] as? String ?? ""
        self.content = json["content"] as? String ?? ""
        self.time = json["time"] as? String ?? ""
        self.isReport = json["isReport"] as? Bool ?? false
        self.isMovie = json["isMovie"] as? Bool ?? false
    }
    
    func toJson() -> [String: Any] {
        return [
            "comment_from": comment_from,
            "comment_content": comment_content,
            "content": content,
            "time": time,
            "isReport": isReport,
            "isMovie": isMovie
        ]
    }
}
