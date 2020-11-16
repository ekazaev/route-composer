//
// RouteComposer
// SwiftUIContentView.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

import Foundation
import RouteComposer
import SwiftUI

// NB: This view exists for the demo purposes only.
@available(iOS 13.0.0, *)
struct SwiftUIContentView: View, ContextInstantiatable, ContextChecking, ContextAcceptingView {

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
            self.context = self.currentContext
        }
    }

    func isTarget(for context: String) -> Bool {
        currentContext == context
    }

    mutating func setup(with context: String) throws {
        currentContext = context
    }

}
