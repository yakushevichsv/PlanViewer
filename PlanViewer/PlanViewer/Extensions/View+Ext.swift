//
//  View+Ext.swift
//  PlanViewer
//
//  Created by syakushevich on 28.06.21.
//

import SwiftUI

extension View {
  func navigationBarColor(_ backgroundColor: UIColor, textColor: UIColor) -> some View {
    self.modifier(NavigationBarModifier(backgroundColor: backgroundColor, textColor: textColor))
  }
}

extension View {
  var ligthGrayNavigation: some View {
      self.navigationBarColor(UIColor(white: 0.9, alpha: 1), textColor: UIColor.black)
  }
}

