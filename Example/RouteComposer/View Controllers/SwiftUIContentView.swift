//
// RouteComposer
// SwiftUIContentView.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2023.
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

// NB: This view exists for the demo purposes only.
@available(iOS 13.0.0, *)
@MainActor struct SwiftUIContentView: View, ContextInstantiatable, ContextChecking, ContextAcceptingView {

    @State private var context: String = ""

    private var currentContext: String

    init(with context: String) {
        self.currentContext = context
    }

    var body: some View {
        VStack {
            Text("Hello SwiftUI. The context is \(context)")
            Button(action: {
                try? UIViewController.router.navigate(to: ConfigurationHolder.configuration.squareScreen, with: nil)
            }, label: {
                Text("Go to Square Tab")
            }).accessibility(identifier: "SwiftUI+\(context)")
        }.onAppear {
            context = currentContext
        }
    }

    func isTarget(for context: String) -> Bool {
        currentContext == context
    }

    mutating func setup(with context: String) throws {
        currentContext = context
    }

}
