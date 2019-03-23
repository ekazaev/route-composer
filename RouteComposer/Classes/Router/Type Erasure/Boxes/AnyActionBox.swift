//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

protocol AnyActionBox: AnyAction {

    associatedtype ActionType: AbstractAction

    init(_ action: ActionType)

}
