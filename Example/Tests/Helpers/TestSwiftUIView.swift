//
// RouteComposer
// TestSwiftUIView.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import RouteComposer
#if canImport(SwiftUI)
import SwiftUI
#endif

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

@available(iOS 13.0.0, *)
struct TestSwiftUIAnyContextView<Context>: View, ContextInstantiatable, ContextChecking {

    let context: Context

    init(with context: Context) {
        self.context = context
    }

    var body: some View {
        Text("Hello SwiftUI!")
    }

    func isTarget(for context: Context) -> Bool {
        true
    }

}
