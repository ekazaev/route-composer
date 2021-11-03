//
// RouteComposer
// GeneratorFactory.swift
// https://github.com/ekazaev/route-composer
//
// Created by wwdc14
// Distributed under the MIT license.
//

import UIKit

public struct GeneratorFactory<VC: UIViewController, C>: Factory {
  // MARK: Associated types
  public typealias ViewController = VC
  
  public typealias Context = C
  
  // MARK: Properties
  let generator: (() throws -> VC)?
  let generatorConfiguration: ((C) throws -> VC)?
  
  // MARK: Functions
  public init(generator: @autoclosure @escaping () throws -> VC) {
    self.generator = generator
    self.generatorConfiguration = nil
  }
  
  public init(generatorConfiguration: @escaping (C) throws -> VC) {
    self.generatorConfiguration = generatorConfiguration
    self.generator = nil
  }
  
  public func build(with context: C) throws -> VC {
    if let generator = generator {
      return try generator()
    } else if let generatorConfiguration = generatorConfiguration {
      return try generatorConfiguration(context)
    } else {
      throw RoutingError.initialController(.notFound, RoutingError.Context("Initial view controller error"))
    }
  }
  
}
