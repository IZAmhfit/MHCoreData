import Foundation
import CoreData

//
public extension NSManagedObject {
    //
    func sayHello() -> String {
        //
        guard let en = entity.name else { return "Unknown" }
        
        //
        return "Hello from \(en)"
    }
}
