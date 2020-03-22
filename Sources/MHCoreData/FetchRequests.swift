//
//  File.swift
//  
//
//  Created by Martin Hruby on 22/03/2020.
//

import Foundation
import CoreData

///
func mhAdd<T>(sorterUp: String, to: NSFetchRequest<T>) -> NSFetchRequest<T>
{
    //
    to.sortDescriptors = [NSSortDescriptor(key: sorterUp, ascending: true)]
    
    //
    return to
}

///
func mhAdd<T>(predicate: NSPredicate, to: NSFetchRequest<T>) -> NSFetchRequest<T>
{
    //
    to.predicate = predicate
    
    //
    return to
}

///
/// Inspirace: https://github.com/stklieme/Fetchable/blob/master/Fetchable.swift
///
public protocol MHFetchable {
    ///
    /// associatedtype CDEntity: NSManagedObject = Self
    
    //
    // static var mhBasicFetch: NSFetchRequest<CDEntity> { get }
}

///
public extension MHFetchable where Self: NSManagedObject {
    //
    typealias FETCHR = NSFetchRequest<Self>
    
    //
    static var entityName : String {
        //
        return String(describing:self)
    }
    
    //
    static var basicFetch: FETCHR {
        //
        NSFetchRequest<Self>(entityName: entityName)
    }
    
    //
    static func fetchRequest(predicate: NSPredicate? = nil,
                             sorter: NSSortDescriptor?) -> FETCHR
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
}

