//
// Created by Eugene Kazaev on 19/01/2018.
// Copyright (c) 2018 CocoaPods. All rights reserved.
//

import Foundation

struct ExampleUniversalLinksManager {

    private static var translators: [ExampleURLTranslator] = []

    static func register(translator: ExampleURLTranslator) {
        translators.append(translator)
    }

    static func destination(for url: URL) -> ExampleDestination? {
        guard let translator = translators.first(where: { $0.destination(from: url) != nil }) else {
            return nil
        }

        return translator.destination(from: url)
    }
}
