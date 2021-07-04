//
//  PlanViewerApp.swift
//  PlanViewer
//
//  Created by syakushevich on 25.06.21.
//

import SwiftUI

@main
struct PlanViewerApp: App {
    let manager = PlanViewerManager()
    var body: some Scene {
        WindowGroup {
            PlanListView(viewModel: manager.listViewModel)
        }
    }
}
