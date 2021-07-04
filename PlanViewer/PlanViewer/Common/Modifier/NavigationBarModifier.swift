//
//  NavigationBarModifier.swift
//  PlanViewer
//
//  Created by syakushevich on 28.06.21.
//

import SwiftUI

struct NavigationBarModifier: ViewModifier {
    var backgroundColor: UIColor
    var textColor: UIColor

    init(backgroundColor: UIColor, textColor: UIColor) {
        self.backgroundColor = backgroundColor
        self.textColor = textColor
        let coloredAppearance = UINavigationBarAppearance()
        coloredAppearance.configureWithTransparentBackground()
        coloredAppearance.backgroundColor = .clear
        coloredAppearance.titleTextAttributes = [.foregroundColor: textColor]
        coloredAppearance.largeTitleTextAttributes = [.foregroundColor: textColor]

        let appearance = UINavigationBar.appearance()
        appearance.standardAppearance = coloredAppearance
        appearance.compactAppearance = coloredAppearance
        appearance.scrollEdgeAppearance = coloredAppearance
        appearance.tintColor = textColor
  }

  func body(content: Content) -> some View {
    ZStack{
       content
        VStack {
          GeometryReader { geometry in
             Color(self.backgroundColor)
                .frame(height: geometry.safeAreaInsets.top)
                .edgesIgnoringSafeArea(.top)
              //Spacer()
          }
        }
     }
  }
}
