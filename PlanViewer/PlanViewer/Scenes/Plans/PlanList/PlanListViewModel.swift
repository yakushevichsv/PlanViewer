//
//  PlanListViewModel.swift
//  PlanViewer
//
//  Created by syakushevich on 25.06.21.
//

import Foundation
import SwiftUI
import Combine

// MARK: - PlanListViewModelType
protocol PlanListViewModelType: PlanBaseViewModelType {
    func onRefresh() async
    func detailsViewModel(plan: PlanModel) -> PlanDetailsViewModel
    var plans: [PlanModel] { get }
}

// MARK: - PlanListViewModel
final class PlanListViewModel: PlanBaseViewModel<[PlanModel]> {
    override var shouldLoad: Bool { plans.isEmpty } //assume loaded finally, otherwise each time it is going to be loaded once again..
    
    override func loadItemAsync(priority: Task.Priority?) async throws -> ElementType {
        try await self.loadPlanJSONAsynch(priority: priority)
    }
    
    
    private func loadPlanJSONAsynch(priority: Task.Priority? = nil) async throws -> [PlanModel] {
        assert(!Thread.isMainThread)
        let paths = Bundle.init(for: Self.self).paths(forResourcesOfType: "json", inDirectory: nil)
        guard !paths.isEmpty else {
            assertionFailure("No jsons!")
            return []
        }
        
        return try await loadPlans(paths: paths,
                                   priority: priority)
    }
    
    internal func loadPlans(paths: [String],
                            priority: Task.Priority? = nil) async throws -> [PlanModel] {
        try await withThrowingTaskGroup(of: [PlanModel].self, body: { taskGroup -> [PlanModel] in
            for path in paths {
                _ = taskGroup.spawnUnlessCancelled(priority: priority) {
                    try [Self.loadPlanSynch(path: path)]
                }
            }
            
            var jsons = [PlanModel]()
            
            func shouldContinue() -> Bool {
                !taskGroup.isCancelled
            }
            
            guard shouldContinue() else {
                return jsons
            }
            
            
            for try await json in taskGroup {
                jsons.append(contentsOf: json)
                guard shouldContinue() else {
                    return jsons
                }
            }
            
            debugPrint("!!! Jsons \(jsons)")
            return jsons.sorted { $0.name < $1.name }
        })
    }
    
    static func loadPlanSynch(path: String) throws -> PlanModel {
        let data = try Data(contentsOf: .init(fileURLWithPath: path))
        
        let decoder = JSONDecoder()
        return try decoder.decode(PlanModel.self, from: data)
    }
    
}

// MARK: - PlanListViewModel.PlanListViewModelType
extension PlanListViewModel: PlanListViewModelType {
    var plans: ElementType { item ?? [] }
    
    func detailsViewModel(plan: PlanModel) -> PlanDetailsViewModel {
        .init(plan: plan)
    }
        
    func onRefresh() async {
        await loadItem(priority: .userInitiated, force: true)
    }
}
