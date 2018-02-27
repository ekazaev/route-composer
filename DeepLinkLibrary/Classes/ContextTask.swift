//
//  ContextTask.swift
//  DeepLinkLibrary
//
//  Created by Eugene Kazaev on 27/02/2018.
//

import Foundation
import UIKit

/// ContextTask
/// The task to be executed after UIViewController created or found.
public protocol ContextTask {
    
    associatedtype ViewController: UIViewController
    
    associatedtype Context
    
    func apply(on viewController: ViewController, with context: Context)
    
}
