//
//  Debouncer.swift
//  CountryApp
//
//  Created by BB Mete on 4/25/25.
//

import Foundation

/// Debouncer delays execution of a closure to prevent rapid firing.
/// Useful for search bars, text fields, and minimizing API calls.

final class Debouncer {
    private var workItem: DispatchWorkItem?
    private let delay: TimeInterval

    init(delay: TimeInterval) {
        self.delay = delay
    }
    
    func run(action: @escaping () -> Void) {
        workItem?.cancel()
        workItem = DispatchWorkItem(block: action)
        if let workItem = workItem {
            DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        }
    }
}
