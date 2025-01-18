//
//  Layer+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/4/8.
//

import Foundation
import CoreImage
import QuartzCore
import UIKit

extension CALayer {
    @discardableResult
    func addGradient(_ direction: UIView.GradientDirection, locations: [NSNumber] = [NSNumber(value: 0), NSNumber(value: 1)], colors: [UIColor]) -> CAGradientLayer {
        let layer = CAGradientLayer()
        layer.startPoint = direction.points().first!
        layer.endPoint = direction.points().last!
        layer.colors = colors.map({ color in
            return color.cgColor
        })
        layer.locations = locations
        layer.frame = self.bounds
        self.insertSublayer(layer, at: 0)
        return layer
    }
}
