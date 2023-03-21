//
//  MySection.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/21.
//

import Foundation
import RxDataSources

struct MySection {
  var headerTitle: String
  var items: [Item]
}

extension MySection: AnimatableSectionModelType {
  typealias Item = Repository
  
  var identity: String {
    return headerTitle
  }
  
  init(original: Self, items: [Item]) {
    self = original
    self.items = items
  }
}
