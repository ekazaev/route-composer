//
// RouteComposer
// StepAssemblerWithFinder.swift
// https://github.com/ekazaev/route-composer
//
// Copyright (c) 2018-2025 Eugene Kazaev.
// Distributed under the MIT License.
//
// Modified in a fork by Savva Shuliatev
// https://github.com/Savva-Shuliatev
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation
import UIKit

@MainActor
public struct StepAssemblerWithFinder<F: Finder> {

    let finder: F

    public init(finder: F) {
        self.finder = finder
    }

}
