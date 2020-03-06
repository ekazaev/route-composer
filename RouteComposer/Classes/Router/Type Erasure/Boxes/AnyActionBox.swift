//
// RouteComposer
// AnyActionBox.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2020.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}

#endif
