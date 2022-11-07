//
//  Extenstion+Reactive.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/07.
//

import Foundation
import RxSwift

extension Reactive where Base: UIViewController {
    public var viewWillAppear: Observable<Bool> {
        return methodInvoked(#selector(Base.viewWillAppear))
            .map { $0.first as? Bool ?? false }
    }
}
