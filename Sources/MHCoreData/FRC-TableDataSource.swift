//
//  File.swift
//  
//
//  Created by Martin Hruby on 22/03/2020.
//

import Foundation
import CoreData
import UIKit

///
public func mhFire<T>(frc: NSFetchedResultsController<T>) -> Bool {
    //
    do {
        //
        try frc.performFetch()
        //
        return true
    } catch {
        //
        return false
    }
}

///
/// Wrapper nad FRC, poskytuje muj delegate
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
    func fire() -> Bool { mhFire(frc: __FRC) }
}
