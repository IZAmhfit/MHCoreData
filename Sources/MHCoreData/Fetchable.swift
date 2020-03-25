//
//  File.swift
//  
//
//  Created by Martin Hruby on 22/03/2020.
//

import Foundation
import CoreData

// --------------------------------------------------------------------
// Inspirace: https://github.com/stklieme/Fetchable/blob/master/Fetchable.swift
// V kodu je pak treba pro kazdou tridu "TR" CD entity dopsat:
// extension TR : MHFetchable {}
// --------------------------------------------------------------------
// tenhle protokol smi implementovat tridy NSManagedObject
public protocol MHFetchable where Self: NSManagedObject {
    // ----------------------------------------------------------------
    // ...
    // associatedtype Entity: NSManagedObject = Self
    
    // ----------------------------------------------------------------
    // typova zkratka...
    typealias FReq = NSFetchRequest<Self>
    typealias FRCType = NSFetchedResultsController<Self>
    typealias AttributeName = String
    
    // ----------------------------------------------------------------
    // chci po entite, aby mi rekla, podle ktereho attr se
    // ma usporadavat FRC
    static var frcBasicKey: AttributeName { get }
}

// --------------------------------------------------------------------
// extension protokolu znamena pridani funkcionality vsem
// tridam implementujicim tento protokol
public extension MHFetchable where Self: NSManagedObject
{
    // ----------------------------------------------------------------
    // obskurni konstrukce, z tridy dostavam nazev entity
    // predpoklad: nazev entity == nazev tridy
    static var entityName : String {
        //
        return String(describing: self)
    }
    
    // zakladni objekt dotazu
    static var basicFetch: FReq {
        //
        NSFetchRequest<Self>(entityName: entityName)
    }
    
    // ... pro FRC, tj. MUSIM (!!!) dodat sortDescription
    static var basicFRCFetch: FReq {
        //
        fetchRequest(keySortedUp: frcBasicKey)
    }
    
    // ...
    static func fetchRequest(keySortedUp: AttributeName) -> FReq {
        //
        let _fr = basicFetch
        
        //
        _fr.sortDescriptors = [NSSortDescriptor(key: keySortedUp,
                                                ascending: true)]
        
        //
        return _fr
    }
    
    //
    static func fetchRequest(predicate: NSPredicate? = nil,
                             sorter: NSSortDescriptor?) -> FReq
    {
        //
        let _fr = basicFetch
        
        //
        _fr.predicate = predicate
        
        //
        if let _sorter = sorter {
            //
            _fr.sortDescriptors = [_sorter]
        }
        
        //
        return _fr
    }
    
    ///
    static func FRC(_ fetchReq: FReq, moc: NSManagedObjectContext) -> FRCType
    {
        //
        NSFetchedResultsController(fetchRequest: fetchReq,
                                   managedObjectContext: moc,
                                   sectionNameKeyPath: nil, cacheName: nil)
    }
}
