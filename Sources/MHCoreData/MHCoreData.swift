import Foundation
import CoreData

// kazdy NSManagedObject umi rict Hello...
public extension NSManagedObject {
    //
    func sayHello() -> String {
        //
        guard let en = entity.name else { return "Unknown" }
        
        //
        return "Hello from \(en)"
    }
}


// --------------------------------------------------------------------
// Wrapper nad FRC, poskytuje muj delegate
public class MHFRC<Entity:MHFetchable> {
    ///
    private let __FRC: Entity.FRCType
    
    ///
    public var count: Int { __FRC.fetchedObjects?.count ?? 0 }
    
    ///
    public var delegate: NSFetchedResultsControllerDelegate? {
        //
        get { __FRC.delegate }
        set { __FRC.delegate = newValue }
    }
    
    ///
    public func object(at: IndexPath) -> Entity {
        //
        __FRC.object(at: at)
    }
    
    ///
    public init(moc: NSManagedObjectContext,
                _ req: Entity.FReq = Entity.basicFRCFetch)
    {
        //
        __FRC = Entity.FRC(req, moc: moc)
    }
    
    ///
    func fire() -> Bool {
        //
        do {
            //
            try __FRC.performFetch()
            //
            return true
        } catch {
            //
            return false
        }
    }
}
