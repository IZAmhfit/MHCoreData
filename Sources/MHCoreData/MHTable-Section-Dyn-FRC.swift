//
//  File.swift
//  
//
//  Created by Martin Hruby on 24/03/2020.
//

import Foundation
import UIKit
import CoreData

// --------------------------------------------------------------------
// Tabulkovy SectionDriver, dynamicky
// --------------------------------------------------------------------
// 1) sablonovity - potrebuju Entitu z CoreData
// 2) odvozuje od SectionDriver
// 3) stava se FRC-delegatem
public class MHFRCSectionDriver<Entity:MHFetchable> : MHSectionDriver, NSFetchedResultsControllerDelegate
{
    // ----------------------------------------------------------------
    // wrapper nad FRC
    let FRC: MHFRC<Entity>
    
    // ----------------------------------------------------------------
    // ...
    public init?(_ mhFRC: MHFRC<Entity>, cellPrototype: String,
                 header: String? = nil)
    {
        // ...
        self.FRC = mhFRC
        super.init(cellPrototype: cellPrototype, header: header)
        
        // stavam se delegatem FRCu
        FRC.delegate = self
        
        // provadim fetch
        if mhFRC.fire() == false {
            //
            return nil
        }
    }
    
    // ----------------------------------------------------------------
    // obvious...
    override var count: Int { return FRC.count }
    
    // ----------------------------------------------------------------
    // UITableViewDataSource::cellForRow(at:)...
    override func dynamicAt(row: Int, table: UITableView) -> MHTableCell {
        // pokud nedostanu bunku, tak lehnu (co jineho...)
        guard let _cell = mhTable?.tableView.dequeueReusableCell(withIdentifier: cellPrototype!) as? MHTableCell
            else { fatalError("FRC: Dynamicky section driver nedostal cell") }
        
        // ... mapuju do sveho prosturu IP
        let _ip = IndexPath(row: row, section: 0)
        
        // bunka necht se sebe-zkonfiguruje...
        _cell.selfConfig(with: FRC.object(at: _ip))
        
        //
        return _cell
    }
    
    // ----------------------------------------------------------------
    //
    override func objectAt(row: Int) -> Any? {
        //
        return FRC.object(at: IndexPath(row: row, section: 0))
    }

    // ----------------------------------------------------------------
    // FRC, delegate metody, predavam do MHTable
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        //
        mhTable?.tableDynamics(from: self, operation: .endUpdates)
    }
    
    // ----------------------------------------------------------------
    //
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        //
        mhTable?.tableDynamics(from: self, operation: .beginUpdates)
    }
    
    // ----------------------------------------------------------------
    // TODO: prekontrolovat vyznamy indexPath, newIndexPath apod...
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        //
        guard let _mhTable = mhTable else {
            //
            return
        }
        
        //
        switch type {
            //
        case .insert:
            //
            if let nip = newIndexPath {
                //
                _mhTable.tableDynamics(from: self,
                                       operation: .insert(nip.row))
            }
            
            //
        case .update:
            //
            if let ip = indexPath {
                //
                _mhTable.tableDynamics(from: self,
                                       operation: .update(ip.row))
            }
            
        case .move:
            //
            if let oip = indexPath, let nip = newIndexPath {
                //
                _mhTable.tableDynamics(from: self,
                                       operation: .move(oip.row, nip.row))
            }
            
        case .delete:
            //
            if let ip = indexPath {
                //
                _mhTable.tableDynamics(from: self,
                                       operation: .delete(ip.row))
            }
        //
        @unknown default:
            ()
        }
    }
}
