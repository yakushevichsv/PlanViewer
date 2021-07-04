//
//  PlanBaseViewModel.swift
//  PlanViewer
//
//  Created by syakushevich on 29.06.21.
//

import SwiftUI
import Combine
// MARK: - PlanBaseViewModelType
protocol PlanBaseViewModelType {
    func onAppear() async
    
    var isLoading: Bool { get set }
    var shouldLoad: Bool { get }
    func loadItem(priority: Task.Priority?,
                  force: Bool) async
    
    func loadItem(force: Bool) async
    func loadItem(priority: Task.Priority?) async
    func loadItem() async
    
    func cancelLoad()
    var shouldDisplayMessage: Bool { get set }
    var alertMessage: String? { get set }
}

extension PlanBaseViewModelType {
    func loadItem() async {
        await loadItem(priority: nil)
    }
    
    func loadItem(priority: Task.Priority?) async {
        await loadItem(priority: priority,
                       force: false)
    }
    
    func loadItem(force: Bool) async {
        await loadItem(priority: nil,
                       force: force)
    }
}

// MARK: - PlanBaseViewModel
class PlanBaseViewModel<T>: ObservableObject, PlanBaseViewModelType {
    typealias ElementType = T
    
    @Published var isLoading = false
    @Published var alertMessage: String? = nil
    var shouldDisplayMessage: Bool = false
    @Published var item: ElementType!
    
    private(set)var jsonTask: AnyCancellable? {
        didSet {
            oldValue?.cancel()
        }
    }
    
    // MAKR: - Virtual
    var shouldLoad: Bool { fatalError("Overwrite") }
    
    func loadItemAsync(priority: Task.Priority?) async throws -> ElementType {
        fatalError("Implement")
    }
    
    
    // MARK: - Private
    private func adjustShouldDisplayMessage() {
        shouldDisplayMessage = alertMessage?.isEmpty == false
    }
    
    //MARK: - Strategy
    func loadItem(priority: Task.Priority?,
                  force: Bool) async {
        guard shouldLoad || force else { return }
        
        
        let task = asyncDetached(priority: priority) { [unowned self] in
            try await self.loadItemAsync(priority: priority)
        }
        
        await MainActor.run { [weak self] in
            self?.isLoading = !force
        }
        
        let result = await task.getResult()
        jsonTask = result.publisher.receive(on: DispatchQueue.main).delay(for: 1, scheduler: RunLoop.main).sink { [unowned self] result in
            self.isLoading = false
            switch result {
            case let .failure(error):
                self.alertMessage = error.localizedDescription
            default:
                self.alertMessage = nil
            }
            self.adjustShouldDisplayMessage()
        } receiveValue: { [unowned self] item in
            self.item = item
        }
    }
    
    func cancelLoad() {
        jsonTask = nil
    }
    
    deinit {
        cancelLoad()
    }
    
    // MARK: - PlanBaseViewModelType
    func onAppear() async {
        await loadItem(priority: .userInitiated)
    }
}
