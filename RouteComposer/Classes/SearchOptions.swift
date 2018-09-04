//
// Created by Eugene Kazaev on 04/09/2018.
//

import Foundation

/// A set of options for the `findViewController` method
public struct SearchOptions: OptionSet {

    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    /// Compare with a view controller provided
    public static let current = SearchOptions(rawValue: 1 << 0)

    /// If the view controller is a container, search in its visible view controllers
    public static let visible = SearchOptions(rawValue: 1 << 1)

    /// If the view controller is a container, search in all the view controllers it contains
    public static let containing = SearchOptions(rawValue: 1 << 2)

    /// Start the search from the view controller provided and search in all view controllers it presented
    public static let presented = SearchOptions(rawValue: 1 << 3)

    /// Start the search from the view controller provided and search in all view controllers that presenting it
    public static let presenting = SearchOptions(rawValue: 1 << 4)

    /// If the view controller is a container, search in all the view controllers it contains
    public static let currentAllStack: SearchOptions = [.current, .containing]

    /// If the view controller is a container, search in all visible view controllers it contains
    public static let currentVisibleOnly: SearchOptions = [.current, .visible]

    /// Iterate through the all visible view controllers in the stack.
    public static let allVisible: SearchOptions = [.currentVisibleOnly, .presented, .presenting]

    /// Iterate through the all view controllers in the stack.
    public static let fullStack: SearchOptions = [.current, .containing, .presented, .presenting]

    /// Iterate through the all view controllers on the current level and all the view controllers
    /// presented from the current level.
    public static let currentAndUp: SearchOptions = [.currentAllStack, .presented]

    /// Iterate through the all view controllers on the current level and all the view controllers
    /// that are presenting the current level.
    public static let currentAndDown: SearchOptions = [.currentAllStack, .presenting]

}
