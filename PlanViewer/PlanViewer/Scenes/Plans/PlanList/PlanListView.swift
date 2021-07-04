//
//  ContentView.swift
//  PlanViewer
//
//  Created by syakushevich on 25.06.21.
//

import SwiftUI

// TODO: ListView & DetailsView are similar -> place common functionality inside common protocol..

struct PlanListView: View {
    @ObservedObject var viewModel: PlanListViewModel
    var viewModelType: PlanListViewModelType { viewModel }
    
    var body: some View {
        NavigationView {
            LoadingView(isShowing: $viewModel.isLoading) {
                List(viewModelType.plans) { plan in
                    NavigationLink(plan.name, destination: PlanDetailsView(viewModel: viewModelType.detailsViewModel(plan: plan))) //kind of routing...
                }
                .refreshable {
                    await viewModelType.onRefresh()
                }.alert(isPresented: $viewModel.shouldDisplayMessage) {
                    Alert(title: Text("Message"), message: viewModelType.alertMessage.map {Text($0)})
                }
            }.ligthGrayNavigation
            .navigationBarTitleDisplayMode(.automatic)
            .navigationTitle("Plans")
        }
        .onAppear {
            detach {
                await viewModelType.onAppear()
            }
        }
    }
}

struct PlanListView_Previews: PreviewProvider {
    static var previews: some View {
        
        let viewModel = PlanListViewModel()
        let plan2 = Bundle.main.path(forResource: "Project 2", ofType: "json").flatMap({ try? PlanListViewModel.loadPlanSynch(path: $0) })
        
        viewModel.item = plan2.map { [$0] } ?? []
        
        let result = PlanListView(viewModel: viewModel)
        
        return result
    }
}
