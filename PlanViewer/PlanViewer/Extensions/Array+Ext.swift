//
//  Array+Ext.swift
//  PlanViewer
//
//  Created by syakushevich on 27.06.21.
//

import QuartzCore

// MARK: Array.point
extension Array where Element == Float {
    var point: CGPoint! {
        guard count == 2, let x = first, let y = last else {
            return nil
        }
        return CGPoint(x: CGFloat(x), y: CGFloat(y))
    }
}
