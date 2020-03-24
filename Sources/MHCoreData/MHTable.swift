//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit


//
enum MHTableDynamics {
    //
    case beginUpdates, endUpdates
    case insert(Int), delete(Int), update(Int)
    case move(Int, Int)
}

///
///
///
open class MHTable: MHAbstractTable {
    //
    var sections: [MHSectionDriver]
    
    ///
    public init(sections: [MHSectionDriver],
                cfg: MHTableConfig = MHTableConfig())
    {
        //
        self.sections = sections
        
        //
        super.init(cfg: cfg)
        
        //
        for i in self.sections {
            //
            i.mhTable = self
        }
    }
    
    //
    public func add(section: MHSectionDriver) {
        //
        section.mhTable = self
        
        //
        sections.append(section)
    }
    
    ///
    required public init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func sectionIndex(ofDriver: MHSectionDriver) -> Int {
        //
        guard let _idx = sections.firstIndex(of: ofDriver)
            else { fatalError() }
        
        //
        return _idx
    }
    
    //
    func object(at: IndexPath) -> MHTableCell {
        //
        return sections[at.section].cellAt(row: at.row)
    }
    
    //
    func tableDynamics(from: MHSectionDriver, operation: MHTableDynamics) {
        //
        let _section = sectionIndex(ofDriver: from)
        
        //
        func ip(_ i: Int) -> IndexPath {
            //
            return IndexPath(row: i, section: _section)
        }
        
        //
        switch operation {
        case .beginUpdates:
            //
            tableView.beginUpdates()
            
        case .endUpdates:
            //
            tableView.endUpdates()
            
        case .insert(let _R):
            //
            tableView.insertRows(at: [ip(_R)], with: .fade)
            
        case let .move(_F, _T):
            //
            tableView.moveRow(at: ip(_F), to: ip(_T))
            
        case .delete(let _R):
            //
            tableView.deleteRows(at: [ip(_R)], with: .fade)
            
        case .update(let _R):
            //
            tableView.reloadRows(at: [ip(_R)], with: .fade)
        }
    }
    
    //
    override public func numberOfSections(in tableView: UITableView) -> Int {
        //
        return sections.count
    }
    
    //
    override public func tableView(_ tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String?
    {
        //
        return sections[section].header
    }
    
    //
    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int
    {
        //
        return sections[section].count
    }
    
    //
    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //
        let _sec = sections[indexPath.section]
        
        //
        switch _sec.style {
            //
        case .staticCells:
            //
            return _sec.cellAt(row: indexPath.row)
            
            //
        case .dynamicCellPrototype:
            //
            return _sec.dynamicAt(row: indexPath.row, table: tableView)
        }
    }
    
    // ----------------------------------------------------------------
    //
    open func event(selected: MHSectionDriver, row: Int) {
        //
    }
    
    // ----------------------------------------------------------------
    //
    open func event(selectedObject: Any?, section:MHSectionDriver, row: Int) {
        //
    }
    
    // ----------------------------------------------------------------
    //
    override public func tableView(_ tableView: UITableView,
                                   didSelectRowAt indexPath: IndexPath)
    {
        //
        let _sec = sections[indexPath.section]
        
        //
        switch _sec.style {
            //
        case .staticCells:
            //
            event(selected: _sec, row: indexPath.row)
            //
        case .dynamicCellPrototype:
            //
            event(selectedObject: _sec.objectAt(row: indexPath.row),
                  section: _sec, row: indexPath.row)
        }
    }
}


//
open class MHDetailTable: MHTable {
    //
    open var definedSections: [MHSectionDriver] { return [] }
    
    //
    open func detailStarted() {}
    
    //
    open override func viewDidLoad() {
        //
        definedSections.forEach { add(section: $0) }
        
        //
        super.viewDidLoad()
        
        //
        detailStarted()
    }
}
