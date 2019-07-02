//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare<Context>(with context: Context) throws

    func perform<Context>(with context: Context, completion: @escaping (_: RoutingResult) -> Void)

}
