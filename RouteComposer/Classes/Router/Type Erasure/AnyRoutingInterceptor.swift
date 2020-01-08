//
// Created by Eugene Kazaev on 14/02/2018.
//

#if os(iOS)

import Foundation
import UIKit

protocol AnyRoutingInterceptor {

    mutating func prepare<Context>(with context: Context) throws

    func perform<Context>(with context: Context, completion: @escaping (_: RoutingResult) -> Void)

}

#endif
