//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyFactory {

    var action: AnyAction { get }

    mutating func prepare<Context>(with context: Context) throws

    func build<Context>(with context: Context) throws -> UIViewController

    mutating func scrapeChildren(from factories: [AnyFactory]) throws -> [AnyFactory]

}
