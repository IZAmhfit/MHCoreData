import Foundation
import CoreData

//
extension NSManagedObject {
    //
    public func sayHello() -> String {
        //
        guard let en = entity.name else { return "Unknown" }
        
        //
        return "Hello from \(en)"
    }
}
