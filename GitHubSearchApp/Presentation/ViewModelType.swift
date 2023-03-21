//
//  ViewModelType.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/10/24.
//

import Foundation
import RxSwift

protocol ViewModelType {
  associatedtype Input
  associatedtype Output
  
  func transform(input: Input, disposeBag: DisposeBag) -> Output
}
