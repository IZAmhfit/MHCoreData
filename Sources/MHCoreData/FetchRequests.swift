//
//  File.swift
//  
//
//  Created by Martin Hruby on 22/03/2020.
//

import Foundation
import CoreData

///
/// Inspirace: https://github.com/stklieme/Fetchable/blob/master/Fetchable.swift
/// V kodu je pak treba pro kazdou tridu "TR" CD entity dopsat:
/// extension TR : MHFetchable {}
public protocol MHFetchable where Self: NSManagedObject{
    ///
    associatedtype Entity: NSManagedObject = Self
    associatedtype AttributeName: RawRepresentable where AttributeName.RawValue == String
    
    // typova zkratka...
    typealias FReq = NSFetchRequest<Self>
    typealias FRCType = NSFetchedResultsController<Self>
    
    //
    static var frcBasicKey: AttributeName { get }
}

///
public extension MHFetchable where Self: NSManagedObject
{
    
    // ...
    static var entityName : String {
        //
        return String(describing:self)
    }
    
    // ...
    static var basicFetch: FReq {
        //
        NSFetchRequest<Self>(entityName: entityName)
    }
    
    //
    static var basicFRCFetch: FReq {
        //
        fetchRequest(keySortedUp: frcBasicKey)
    }
    
    //
    static func fetchRequest(keySortedUp: AttributeName) -> FReq {
        //
        let _fr = basicFetch
        
        //
        _fr.sortDescriptors = [NSSortDescriptor(key: keySortedUp.rawValue,
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

///
public extension NSFetchRequest where ResultType:NSFetchRequestResult  {
    
}

