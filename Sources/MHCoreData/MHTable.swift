//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit


// --------------------------------------------------------------------
// interni zalezitost komunikace MHSectionDriver -> MHTable
// pokyny pro dynamicke prekreslovani Tabulky
enum MHTableDynamics {
    //
    case beginUpdates, endUpdates
    case insert(Int), delete(Int), update(Int)
    case move(Int, Int)
}

// --------------------------------------------------------------------
// Univerzalni tabulka rizena section-drivery
// --------------------------------------------------------------------
open class MHTable: MHAbstractTable {
    // ----------------------------------------------------------------
    // seznam section drivers
    var sections: [MHSectionDriver]
    
    // ----------------------------------------------------------------
    //
    public init(sections: [MHSectionDriver],
                cfg: MHTableConfig = MHTableConfig())
    {
        //
        self.sections = sections
        
        //
        super.init(cfg: cfg)
        
        // ... uz smim pouzivat self ...
        sections.forEach { $0.mhTable = self; }
    }
    
    // ----------------------------------------------------------------
    //
    public func add(section: MHSectionDriver, callReload: Bool = false) {
        //
        section.mhTable = self
        
        //
        sections.append(section)
        
        //
        if callReload { tableView.reloadData() }
    }
    
    ///
    required public init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
    
    // ----------------------------------------------------------------
    // cislo sekce, odpovidajici tomuto driveru
    // pokud se ptam na neregistrovany driver, slitni
    func sectionIndex(ofDriver: MHSectionDriver) -> Int {
        //
        guard let _idx = sections.firstIndex(of: ofDriver)
            //
            else { fatalError("Neregistrovany MHTable section driver") }
        
        //
        return _idx
    }
    
    //
    func object(at: IndexPath) -> MHTableCell {
        //
        return sections[at.section].cellAt(row: at.row)
    }
    
    // ----------------------------------------------------------------
    // driver komanduje moji tabulku, ok...
    func tableDynamics(from: MHSectionDriver, operation: MHTableDynamics) {
        // sekce tohodle driveru
        let _section = sectionIndex(ofDriver: from)
        
        // pokud driver mysli IndexPath.row, pak je to v jeho sekci:
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
    
    // ----------------------------------------------------------------
    // DataSource tabulky, 1) pocet sekci je jasny
    override public func numberOfSections(in tableView: UITableView) -> Int {
        // predavam na driver
        return sections.count
    }
    
    // DataSource tabulky, 2) hlavicka
    override public func tableView(_ tableView: UITableView,
                                   titleForHeaderInSection section: Int) -> String?
    {
        // predavam na driver
        return sections[section].header
    }
    
    // DataSource tabulky, 3) ... evidentni
    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int
    {
        // predavam na driver
        return sections[section].count
    }
    
    // ----------------------------------------------------------------
    // DataSource, dotaz predavam na driver s rozlisenim
    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        //
        let _sec = sections[indexPath.section]
        
        //
        switch _sec.style {
            // statik...vrati mi svoji interne ulozenou bunku
        case .staticCells:
            //
            return _sec.cellAt(row: indexPath.row)
            
            // dynamic, predpokladam instanciaci dequeue na pozadani
            // -- musi byt jasny cellPrototype
            // -- tabulka musi mit predem cellPrototype registrovany
        case .dynamicCellPrototype:
            //
            return _sec.dynamicAt(row: indexPath.row, table: tableView)
        }
    }
    
    // ----------------------------------------------------------------
    // generuju udalost na stisk bunky statickeho driveru
    // (predpokladam on si to prebere podle sveho interniho modelu)
    open func event(selected: MHSectionDriver, ip: IndexPath) {
        //
    }
    
    // ----------------------------------------------------------------
    // ... dynamickeho driveru, kdy se hodi i informace o datovem
    // objektu na pozici
    open func event(selectedObject: Any?, section:MHSectionDriver,
                    ip: IndexPath)
    {
        //
    }
    
    // ----------------------------------------------------------------
    // zde tableView.delegate==self, tudiz zpravu dostavam ja, zde
    override public func tableView(_ tableView: UITableView,
                                   didSelectRowAt indexPath: IndexPath)
    {
        //
        let _sec = sections[indexPath.section]
        
        // rozlisim driver a podle toho generuju interni udalost
        switch _sec.style {
            //
        case .staticCells:
            //
            event(selected: _sec, ip: indexPath)
            //
        case .dynamicCellPrototype:
            //
            event(selectedObject: _sec.objectAt(row: indexPath.row),
                  section: _sec, ip: indexPath)
        }
    }
}


// --------------------------------------------------------------------
// Mirne hacknuta tabulka pro potreby MHTable s detailem na objekt
open class MHDetailTable: MHTable {
    // predpokladm si navazujici trida ujasni sekce
    open var definedSections: [MHSectionDriver] { return [] }
    
    // tuto zpravu poslu po viewDidLoad
    // bunky tabulky se naplni daty
    open func detailStarted() {}
    
    //
    open override func viewDidLoad() {
        // dodatecne si nahrabu ovladace sekci
        definedSections.forEach { add(section: $0) }
        
        // ...
        super.viewDidLoad()
        
        // zkonfiguruj se
        detailStarted()
    }
}
