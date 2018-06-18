//
// Created by Eugene Kazaev on 18/06/2018.
// Copyright (c) 2018 Gilt Groupe. All rights reserved.
//

import Foundation
import UIKit
import RouteComposer

class GlobalInterceptor: RoutingInterceptor {

    func execute(for destination: ExampleDestination, completion: @escaping (InterceptorResult) -> Void) {
        print("Routing started")
        completion(.success)
    }

}
