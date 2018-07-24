//
// Created by Eugene Kazaev on 15/01/2018.
// Copyright (c) 2018 HBC Tech. All rights reserved.
//

import Foundation
import UIKit

protocol FinalStepComposer {
    
    associatedtype FactoryType: Maker
    
    init<F: Finder>(finder: F, factory: FactoryType, interceptor: AnyRoutingInterceptor?, contextTask: AnyContextTask?, postTask: AnyPostRoutingTask?, previousStep: RoutingStep) where F.ViewController == FactoryType.ViewController, F.Context == FactoryType.Context
    
}

class FinalRoutingStep<FC: Factory>: BaseStep<FactoryBox<FC>>, RoutingStep, InterceptableStep, FinalStepComposer {

    typealias FactoryType = FC
    
    let interceptor: AnyRoutingInterceptor?
    
    let postTask: AnyPostRoutingTask?
    
    let contextTask: AnyContextTask?
    
    required init<F: Finder>(finder: F, factory: FC, interceptor: AnyRoutingInterceptor?, contextTask: AnyContextTask?, postTask: AnyPostRoutingTask?, previousStep: RoutingStep) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        self.postTask = postTask
        self.contextTask = contextTask
        self.interceptor = interceptor
        super.init(finder: finder, factory: factory, previousStep: previousStep)
    }
    
}

class FinalContainerRoutingStep<FC: Container>: BaseStep<ContainerFactoryBox<FC>>, RoutingStep, InterceptableStep, FinalStepComposer {
    
    typealias FactoryType = FC
    
    let interceptor: AnyRoutingInterceptor?
    
    let postTask: AnyPostRoutingTask?
    
    let contextTask: AnyContextTask?
    
    required init<F: Finder>(finder: F, factory: FC, interceptor: AnyRoutingInterceptor?, contextTask: AnyContextTask?, postTask: AnyPostRoutingTask?, previousStep: RoutingStep) where F.ViewController == FC.ViewController, F.Context == FC.Context {
        self.postTask = postTask
        self.contextTask = contextTask
        self.interceptor = interceptor
        super.init(finder: finder, factory: factory, previousStep: previousStep)
    }
    
}
