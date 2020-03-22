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


/// Popis zpracovani pro jednu tabulku
public struct MHTableDEF<Type> {
    // pro nejake ucely (...) si drzim slabou ref na tabulku
    // TODO: mozna nebude potreba
    weak var table: UITableView?
    
    // predpokladam homogenni tabulku s jednim rid
    let reuseId: String
    var tableIsDynamic: Bool { table != nil }
    
    // zprava pro cil, zkonfigurujj si bunku
    public typealias CellConfigDelegate = (UITableViewCell, Type)->()
    public typealias CellSelectionDelegate = (Type)->()
    
    // ...
    let cellConfig: CellConfigDelegate
    let cellSelect: CellSelectionDelegate?
    
    
    //
    public init(reuse: String, cellConfig: @escaping CellConfigDelegate) {
        //
        self.reuseId = reuse
        self.cellConfig = cellConfig
        self.cellSelect = nil
    }
}

///
/// Tabulkovy DS
public class MHFRCDataSource<Entity> : NSObject, UITableViewDataSource, NSFetchedResultsControllerDelegate where Entity:MHFetchable
{
    ///
    let FRC: MHFRC<Entity>
    
    ///
    let def: MHTableDEF<Entity>
    
    ///
    public init?(_ mhFRC: MHFRC<Entity>, def: MHTableDEF<Entity>) {
        //
        self.FRC = mhFRC
        self.def = def
        
        //
        super.init()
        
        //
        if def.tableIsDynamic {
            //
            FRC.delegate = self
        }
        
        //
        guard mhFRC.fire() else {
            //
            return nil
        }
    }
    
    ///
    public func numberOfSections(in tableView: UITableView) -> Int {
        ///
        return 1
    }
    
    ///
    public func tableView(_ tableView: UITableView,
                          numberOfRowsInSection section: Int) -> Int
    {
        ///
        return FRC.count
    }
    
    ///
    public func tableView(_ tableView: UITableView,
                          cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        ///
        guard let _cell = tableView.dequeueReusableCell(withIdentifier: def.reuseId)
            else { fatalError() }
        
        //
        def.cellConfig(_cell, FRC.object(at: indexPath))
        
        //
        return _cell
    }
    
    ///
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        //
        def.table?.endUpdates()
    }
    
    ///
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        //
        def.table?.beginUpdates()
    }
    
    ///
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        //
        switch type {
        case .insert:
            //
            if let nip = newIndexPath {
                //
                def.table?.insertRows(at: [nip], with: .fade)
            }
        case .update:
            //
            if let ip = indexPath {
                //
                def.table?.reloadRows(at: [ip], with: .fade)
            }
            
        case .move:
            //
            if let oip = indexPath, let nip = newIndexPath {
                //
                def.table?.moveRow(at: oip, to: nip)
            }
            
        case .delete:
            //
            if let ip = indexPath {
                //
                def.table?.deleteRows(at: [ip], with: .fade)
            }
        //
        @unknown default:
            ()
        }
    }
}
