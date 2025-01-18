//
//  DateFormatter+Extension.swift
//  ForexSwift
//
//  Created by liuxu on 2022/6/8.
//

import Foundation

extension DateFormatter {
    func string(from timeInterval: TimeInterval) -> String {
        return self.string(from: Date(timeIntervalSince1970: timeInterval))
    }
}
