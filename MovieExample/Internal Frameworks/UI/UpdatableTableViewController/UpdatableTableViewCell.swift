//
// Created by Eugene Kazaev on 25/08/2019.
// Copyright (c) 2019 Eugene Kazaev. All rights reserved.
//

import Foundation
import UIKit

public protocol UpdatableTableViewCell where Self: UITableViewCell {

    associatedtype Data

    static func register(in tableView: UITableView)

    static var reusableIdentifier: String { get }

    func setup(with data: Data)

}
