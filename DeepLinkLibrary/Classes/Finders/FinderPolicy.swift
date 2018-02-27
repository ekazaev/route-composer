//
// Created by Eugene Kazaev on 23/01/2018.
//

import Foundation

/// Policy for FinderWithPolicy.
///
/// - allStackUp: Search in full view controller stack starting from root view controller in key UIWindow
/// - allStackDown: Search in full view controller stack starting from topmost view controller and then
///   go down by presenting view controllers.
/// - currentLevel: Look only on currently visible level (won't check presented or presenting view controllers), but if
///   currently visible view controller has children view controller's it will loop through them ass well.
/// - topMost: Check if topmost view controller is the one that we are looking for.
public enum FinderPolicy {

    /// Search in full view controller stack starting from root view controller in key UIWindow
    case allStackUp
    
    /// Search in full view controller stack starting from topmost view controller and then
    /// go down by presenting view controllers.
    case allStackDown

    /// Look only on currently visible level (won't check presented or presenting view controllers), but if
    /// currently visible view controller has children view controller's it will loop through them ass well.
    case currentLevel
    
    /// Check if topmost view controller is the one that we are looking for.
    case topMost

}
