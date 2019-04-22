//
// Created by Eugene Kazaev on 2019-02-27.
//

import Foundation

struct FinderBox<F: Finder>: AnyFinder, CustomStringConvertible {

    let finder: F

    init?(_ finder: F) {
        guard !(finder is NilEntity) else {
            return nil
        }
        self.finder = finder
    }

    func findViewController<Context>(with context: Context) throws -> UIViewController? {
        guard let typedContext = Any?.some(context as Any) as? F.Context else {
            throw RoutingError.typeMismatch(F.Context.self, .init("\(String(describing: F.self)) does " +
                    "not accept \(String(describing: context.self)) as a context."))
        }
        return try finder.findViewController(with: typedContext)
    }

    var description: String {
        return String(describing: finder)
    }

}
