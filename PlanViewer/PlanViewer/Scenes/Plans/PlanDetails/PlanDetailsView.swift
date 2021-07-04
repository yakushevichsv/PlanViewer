//
//  PlanDetails.swift
//  PlanViewer
//
//  Created by syakushevich on 26.06.21.
//

import SwiftUI
import Combine


struct PlanDetailsView: View {
    @ObservedObject var viewModel: PlanDetailsViewModel
    
    init(viewModel: PlanDetailsViewModel) {
        self.viewModel = viewModel
        //UIScrollView.appearance().bounces = false
    }
    
    var body: some View {
        LoadingView(isShowing: $viewModel.isLoading) {
            ScrollView(.horizontal.union(.vertical)) {
                viewModel.housePath
                .stroke(.gray, lineWidth: 2)
                .frame(width: viewModel.houseBoundingRect.maxX + 10,
                       height: viewModel.houseBoundingRect.maxY + 10)
            }.alert(isPresented: $viewModel.shouldDisplayMessage) {
                Alert(title: Text("Message"), message: viewModel.alertMessage.map {Text($0)})
            }
        }.ligthGrayNavigation
        .navigationBarTitleDisplayMode(.inline)
        //.accentColor(.black)
        .onAppear {
            detach {
                await viewModel.onAppear()
            }
        }
    }
}

struct PlanDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        let plan = Bundle.main.path(forResource: "Project 1", ofType: "json").flatMap({ try? PlanListViewModel.loadPlanSynch(path: $0) })
        
        return PlanDetailsView(viewModel: .init(plan: plan!))
    }
}
