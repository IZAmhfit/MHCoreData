//
//  File.swift
//  
//
//  Created by Martin Hruby on 24/03/2020.
//

import Foundation
import UIKit
import CoreData

///
/// Tabulkovy DS
public class MHFRCSectionDriver<Entity:MHFetchable> : MHSectionDriver, NSFetchedResultsControllerDelegate {
    ///
    let FRC: MHFRC<Entity>
    
    ///
    public init?(_ mhFRC: MHFRC<Entity>, cellPrototype: String,
                 header: String? = nil)
    {
        //
        FRC = mhFRC
        
        //
        super.init(cellPrototype: cellPrototype, header: header)
        
        //
        FRC.delegate = self
        
        //
        guard mhFRC.fire() else {
            //
            return nil
        }
    }
    
    //
    override var count: Int {
        //
        return FRC.count
    }
    
    //
    override func dynamicAt(row: Int, table: UITableView) -> MHTableCell {
        //
        guard let _cell = mhTable?.tableView.dequeueReusableCell(withIdentifier: cellPrototype!) as? MHTableCell else { fatalError() }
        
        //
        let _ip = IndexPath(row: row, section: 0)
        
        //
        _cell.selfConfig(with: FRC.object(at: _ip))
        
        //
        return _cell
    }
    
    //
    override func objectAt(row: Int) -> Any? {
        //
        return FRC.object(at: IndexPath(row: row, section: 0))
    }

    ///
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        //
        mhTable?.tableDynamics(from: self, operation: .endUpdates)
    }
    
    ///
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>)
    {
        //
        mhTable?.tableDynamics(from: self, operation: .beginUpdates)
    }
    
    ///
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?)
    {
        //
        switch type {
            //
        case .insert:
            //
            if let nip = newIndexPath {
                //
                mhTable?.tableDynamics(from: self,
                                       operation: .insert(nip.row))
            }
            
            //
        case .update:
            //
            if let ip = indexPath {
                //
                mhTable?.tableDynamics(from: self,
                                       operation: .update(ip.row))
            }
            
        case .move:
            //
            if let oip = indexPath, let nip = newIndexPath {
                //
                mhTable?.tableDynamics(from: self,
                                       operation: .move(oip.row, nip.row))
            }
            
        case .delete:
            //
            if let ip = indexPath {
                //
                mhTable?.tableDynamics(from: self,
                                       operation: .delete(ip.row))
            }
        //
        @unknown default:
            ()
        }
    }
}
