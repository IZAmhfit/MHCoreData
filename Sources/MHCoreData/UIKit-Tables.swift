//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit

///
///
///
public typealias MHTableCells = [MHTableCell]
public typealias MHAction = (UIViewController)->()
public typealias MHOnCellAction = (UIViewController, IndexPath)->()
public typealias MHOnObjectCellAction = (UIViewController, IndexPath, MHTableCell)->()


/// Konfigurace tabulky
///
public struct MHTableConfig {
    // groupped/plain
    public var style: UITableView.Style = .plain
    
    // akce na ruzne situace
    public var addButton: MHAction? = nil
    public var selectionIndexPath: MHOnCellAction? = nil
    public var selectionObjectIndexPath: MHOnObjectCellAction? = nil
    
    //
    public init() {
        //
        addButton = nil
        selectionIndexPath = nil
        selectionObjectIndexPath = nil
    }
}


///
///
///
open class MHAbstractTable : UITableViewController {
    ///
    let config: MHTableConfig
    
    //
    init(cfg: MHTableConfig) {
        //
        config = cfg; super.init(style: cfg.style)
    }
    
    //
    required public init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    @objc private func __addButtonAction() {
        //
        config.addButton?(self)
    }
    
    //
    override public func viewDidLoad() {
        //
        super.viewDidLoad()
        
        //
        if let _ = config.addButton {
            //
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(__addButtonAction))
        }
    }
    
    //
    func event(indexPathSelected: IndexPath) {
        //
        if let _act = config.selectionIndexPath {
            //
            _act(self, indexPathSelected)
        }
    }
    
    //
    override public func tableView(_ tableView: UITableView,
                                   didSelectRowAt indexPath: IndexPath)
    {
        //
        event(indexPathSelected: indexPath)
    }
}

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
    let sections: [MHSectionDriver]
    
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
    
    //
    override func event(indexPathSelected: IndexPath) {
        //
        if let _act = config.selectionObjectIndexPath {
            //
            _act(self, indexPathSelected, object(at: indexPathSelected))
        }
        
        //
        super.event(indexPathSelected: indexPathSelected)
    }
}
