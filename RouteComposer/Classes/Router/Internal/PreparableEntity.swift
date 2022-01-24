//
// RouteComposer
// PreparableEntity.swift
// https://github.com/ekazaev/route-composer
//
// Created by Eugene Kazaev in 2018-2022.
// Distributed under the MIT license.
//

#if os(iOS)

import Foundation

protocol PreparableEntity {

    var isPrepared: Bool { get }

}

extension PreparableEntity {

    func assertIfNotPrepared() {
        if !isPrepared {
            assertionFailure("Internal inconsistency: prepare(with:) method has never been " +
                "called for \(String(describing: self)).")
        }
    }

}

#endif
