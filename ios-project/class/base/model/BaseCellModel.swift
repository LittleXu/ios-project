//
//  BaseCellModel.swift
//  ForexSwift
//
//  Created by liuxu on 2022/7/8.
//

import Foundation
import Kingfisher


protocol BaseCellModelProtocol {
    var title: String { get set }
    var cellId: String { get set }
    var settings: [String : String] { get set }
}

struct BaseSectionModel {
    var title = ""
    var datas: [BaseCellModelProtocol] = []
}

struct BaseCellModel: BaseCellModelProtocol {
    var title = ""
    var content = ""
    var cellId = ""
    var selectBlock: B?
    var settings: [String : String] = [:]
}

struct BaseCellImageModel: BaseCellModelProtocol {
    var title = ""
    var content = ""
    var cellId = ""
    var image: UIImage?
    var selectBlock: B?
    var settings: [String : String] = [:]
}

struct BaseCellImageSelectModel: BaseCellModelProtocol {
    var title = ""
    var content = ""
    var cellId = ""
    var image: UIImage?
    var select = false
    var selectBlock: B?
    var settings: [String : String] = [:]
}

struct BaseCellSwitchModel: BaseCellModelProtocol {
    var title = ""
    var on = false
    var cellId = ""
    var changedBlock: B1<Bool>?
    var settings: [String : String] = [:]
}
