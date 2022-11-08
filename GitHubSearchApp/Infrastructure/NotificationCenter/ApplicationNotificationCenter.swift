//
//  ApplicationNotificationCenter.swift
//  GitHubSearchApp
//
//  Created by chmini on 2022/11/07.
//

import Foundation
import RxSwift

protocol NotificationCenterProtocol {
    var name: Notification.Name { get }
}

extension NotificationCenterProtocol {
    func addObserver() -> Observable<Any?> {
        return NotificationCenter.default.rx.notification(self.name).map { $0.object }
    }
    
    func post(object: Any? = nil) {
        NotificationCenter.default.post(name: self.name, object: object, userInfo: nil)
    }
}

enum ApplicationNotificationCenter: NotificationCenterProtocol {
    case dataDidChange

    var name: Notification.Name {
        switch self {
        case .dataDidChange:
            return Notification.Name.NSManagedObjectContextObjectsDidChange
        }
    }
}
