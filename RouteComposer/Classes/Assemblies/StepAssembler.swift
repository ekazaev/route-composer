//
// RouteComposer
// StepAssembler.swift
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
import SwiftUI

@MainActor
public struct StepAssembler<VC: UIViewController, C> {

    public init() {}

    @_disfavoredOverload
    public func finder<F: Finder>(_ finder: F) -> StepAssemblerWithFinder<F> where F.ViewController == VC, F.Context == C {
        getFinder(finder)
    }

    @_spi(Internals)
    public func getFinder<F: Finder>(_ finder: F) -> StepAssemblerWithFinder<F> where F.ViewController == VC, F.Context == C {
        StepAssemblerWithFinder(finder: finder)
    }

}

extension StepAssembler {

    public func finder(_ finder: ClassFinder<VC, C>) -> StepAssemblerWithFinder<ClassFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder(_ finder: InstanceFinder<VC, C>) -> StepAssemblerWithFinder<InstanceFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder(_ finder: NilFinder<VC, C>) -> StepAssemblerWithFinder<NilFinder<VC, C>> {
        getFinder(finder)
    }

    public func finder<ContentView: View & ContextChecking>(_ finder: UIHostingControllerWithContextFinder<ContentView>) -> StepAssemblerWithFinder<UIHostingControllerWithContextFinder<ContentView>> where UIHostingController<ContentView> == VC, ContentView.Context == C {
        getFinder(finder)
    }
}

extension StepAssembler where VC: ContextChecking, C == VC.Context {
    public func finder(_ finder: ClassWithContextFinder<VC, C>) -> StepAssemblerWithFinder<ClassWithContextFinder<VC, C>> {
            getFinder(finder)
      }
}
