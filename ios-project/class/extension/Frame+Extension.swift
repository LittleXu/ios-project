//
//  Frame+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/3/31.
//

import Foundation
import UIKit


extension UIView {
    var x: CGFloat {
        get {
            return frame.x
        }
        set {
            var newFrame = frame
            newFrame.x = newValue
            frame = newFrame
        }
    }
    
    var y: CGFloat {
        get {
            return frame.y
        }
        set {
            var newFrame = frame
            newFrame.y = newValue
            frame = newFrame
        }
    }
    
    var width: CGFloat {
        get {
            return frame.width
        }
        set {
            var newFrame = frame
            newFrame.width = newValue
            frame = newFrame
        }
    }
    
    
    var height: CGFloat {
        get {
            return frame.height
        }
        set {
            var newFrame = frame
            newFrame.height = newValue
            frame = newFrame
        }
    }
    
}


extension CGRect {
    var x: CGFloat {
        get {
            return origin.x
        }
        set {
            origin.x = newValue
        }
    }
    
    var y: CGFloat {
        get {
            return origin.y
        }
        set {
            origin.y = newValue
        }
        
    }
    
    var width: CGFloat {
        get {
            return size.width

        }
        set {
            size.width = newValue
        }
    }
    
    var height: CGFloat {
        get {
            return size.height
        }
        set {
            size.height = newValue
        }
    }
}
