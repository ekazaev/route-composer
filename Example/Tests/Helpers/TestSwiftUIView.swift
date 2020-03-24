//
// RouteComposer
// TestSwiftUIView.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation
import RouteComposer
import SwiftUI

@available(iOS 13.0.0, *)
struct TestSwiftUIView: View, ContextInstantiatable, ContextChecking {

    let context: String

    init(with context: String) {
        self.context = context
    }

    var body: some View {
        Text("Hello SwiftUI!")
    }

    func isTarget(for context: String) -> Bool {
        self.context == context
    }

}

#endif
