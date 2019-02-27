//
// Created by Eugene Kazaev on 14/02/2018.
//

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare(with context: Any?) throws

    func execute(with context: Any?, completion: @escaping (_: InterceptorResult) -> Void)

}
