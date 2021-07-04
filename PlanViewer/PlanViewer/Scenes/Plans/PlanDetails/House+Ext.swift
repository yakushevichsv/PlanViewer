//
//  House+Ext.swift
//  PlanViewer
//
//  Created by syakushevich on 27.06.21.
//

import Foundation
import QuartzCore
import SwiftUI

extension House {
    static func roomPathBounds(_ room: Room) -> Path {
        var path = Path()
        
        var startPoint = CGPoint.zero
        var endPoint = CGPoint.zero
    
        room.walls.forEach { wall in
            guard let p1 = wall.start.point, let p2 = wall.end.point else {
                debugPrint("Warning no start or ent \(wall.start) end \(wall.end)")
                return
            }
            assert(startPoint == .zero || endPoint == p1) //start point equal to previous end point...
            endPoint = p2
            if startPoint == .zero {
                startPoint = p1
            }
            path.addLines([p1, p2])
        }
        
        if let center = room.position.point {
            path = path.applying(.init(translationX: center.x, y: center.y))
        }
        
        
        if startPoint == endPoint {
            path.closeSubpath()
        }
        
        return path
    }
    
    static func roomPath(_ room: Room) -> Path {
        var path = Path()
        path.addPath(roomPathBounds(room))
        path.closeSubpath()
        return path
    }
    
    func path() -> Path {
        var path = Path()
        
        rooms.forEach { room in
            path.addPath(Self.roomPath(room))
        }
        path.closeSubpath()
        return path
    }
}
