//
// RouteComposer
// AnyActionBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//
// Become a sponsor:
// https://github.com/sponsors/ekazaev
//

import Foundation

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}
