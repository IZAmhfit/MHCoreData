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
    let style: UITableView.Style = .plain
    
    // akce na ruzne situace
    let addButton: MHAction?
    let selectionIndexPath: MHOnCellAction?
    let selectionObjectIndexPath: MHOnObjectCellAction?
    
    //
    public init() {
        //
        addButton = nil
        selectionIndexPath = nil
        selectionObjectIndexPath = nil
    }
    
    //
    public init(onIndexPath: @escaping MHOnCellAction) {
        //
        addButton = nil;
        selectionIndexPath = onIndexPath
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

///
/// DataSource pro jednu sekci.
/// Muze byt bud:
/// 1) static, pak bereme z pole
/// 2) FRC, dynamic
///
public class MHSectionDriver {
    //
    public enum DType {
        //
        case staticCells
        case frc
    }
    
    //
    static func on<T:CustomStringConvertible>(_ inputs: [T], header: String? = nil) -> MHSectionDriver
    {
        //
        MHSectionDriver(staticCells: inputs.map { MHRow.Text($0.description) },
                        header: header)
    }
    
    //
    public init(staticCells cells: [MHTableCell], header: String? = nil) {
        //
        self.header = header
        self.contents = cells
    }
    
    //
    let header: String?
    private let contents: [MHTableCell]
    let style: DType = .staticCells
    
    //
    var count: Int {
        //
        return contents.count
    }
    
    //
    func cellAt(row: Int) -> MHTableCell {
        //
        return contents[row]
    }
}

///
///
///
open class MHTable: MHAbstractTable {
    //
    let sections: [MHSectionDriver]
    
    ///
    public init(sections: [MHSectionDriver], cfg: MHTableConfig = MHTableConfig()) {
        //
        self.sections = sections
        
        //
        super.init(cfg: cfg)
    }
    
    ///
    required public init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    func object(at: IndexPath) -> MHTableCell {
        //
        return sections[at.section].cellAt(row: at.row)
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
        return object(at: indexPath)
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

///
public extension MHTable {
    //
    static func rdetail<Root>(on: Root, keys: [KeyPath<Root, String>]) -> MHTable
    {
        //
        let dr = keys.map { k in
            MHRow.Text("cosi", on[keyPath: k])
        }
        
        //
        return MHTable(sections: [MHSectionDriver(staticCells: dr)])
    }
    
    //
    static func table(on: [String]) -> MHTable {
        //
        let cfg = MHTableConfig { vc, idx in //
            //
            let sect = MHSectionDriver.on(["1","2","3"], header: "Cisla")
            let secta = MHSectionDriver.on(["a","b","c"], header: "Pismena")
            
            //
            let p = MHTable(sections: [sect, secta])
            
            //
            vc.navigationController?.pushViewController(p, animated: true)
        }
        
        //
        let cells = on.map { MHRow.Text($0) }
        let sect = MHSectionDriver(staticCells: cells)
        
        //
        return MHTable(sections: [sect], cfg: cfg)
    }
}

