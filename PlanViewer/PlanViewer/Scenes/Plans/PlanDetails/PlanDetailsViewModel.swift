//
//  PlanDetailsViewModel.swift
//  PlanViewer
//
//  Created by syakushevich on 27.06.21.
//

import Foundation
import Combine
import QuartzCore
import SwiftUI

// MARK: - HousePlanInfo
struct HousePlanInfo {
    let path: Path
    let boundingRect: CGRect
    
    static let empty = Self.init(path: .init(),
                                 boundingRect: .zero)
}

// MARK: - PlanDetailsViewModelType
protocol PlanDetailsViewModelType: PlanBaseViewModelType {
    var housePlanInfo: HousePlanInfo { get }
}

// MARK: - PlanDetailsViewModel
final class PlanDetailsViewModel: PlanBaseViewModel<HousePlanInfo> {
    private let plan: PlanModel
    
    var house: House { plan.house }
    
    
    init(plan: PlanModel) {
        self.plan = plan
    }
    
    override var shouldLoad: Bool { housePlanInfo.path.isEmpty } //assume loaded finally, otherwise each time it is going to be loaded once again..
    
    override func loadItemAsync(priority: Task.Priority?) async throws -> ElementType {
        let path = house.path()
        return .init(path: path,
                     boundingRect: path.boundingRect)
    }
}

//MARK: - PlanDetailsViewModel.PlanDetailsViewModelType
extension PlanDetailsViewModel: PlanDetailsViewModelType {
    var housePlanInfo: HousePlanInfo { item ?? .empty }
    var housePath: Path { housePlanInfo.path }
    var houseBoundingRect: CGRect { housePlanInfo.boundingRect }
}
