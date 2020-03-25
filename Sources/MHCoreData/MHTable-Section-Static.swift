//
//  File.swift
//  
//
//  Created by Martin Hruby on 24/03/2020.
//

import Foundation
import UIKit

// --------------------------------------------------------------------
// Section driver je zprostredkovatelem UITableViewDataSource
// --------------------------------------------------------------------
// 1) Staticky, je zodpovedny za alokaci TableViewCells
// 2) Dynamicky, musi zajistit pro tabulku prototyp bunky -- TODO
public class MHSectionDriver : NSObject {
    // ----------------------------------------------------------------
    //
    public enum DType {
        //
        case staticCells
        case dynamicCellPrototype
    }
    
    // ----------------------------------------------------------------
    // predpokladam okamziky, kdy driver bude chtit volat MHTable
    // (FRC.delegate -> Table)
    weak var mhTable: MHTable?
    
    // ----------------------------------------------------------------
    // ...
    let header: String?
    let style: DType
    
    // ----------------------------------------------------------------
    // staticka, tady si ukladam predem vygenerovane bunky
    private let contents: [MHTableCell]
    
    // ----------------------------------------------------------------
    // dynamicka, mam prototyp
    // Pozn.: tabulka si musi na tento cellPrototype registrovat
    // tridu bunky nebo NIB
    let cellPrototype: String?
    
    
    // ----------------------------------------------------------------
    // static
    public init(staticCells cells: [MHTableCell], header: String? = nil) {
        //
        self.header = header
        self.contents = cells
        self.style = .staticCells
        self.cellPrototype = nil
        
        //
        super.init()
    }
    
    // ----------------------------------------------------------------
    // dynamic. TODO: nejak zajistit prototyp
    public init(cellPrototype: String, header: String? = nil) {
        //
        self.header = header
        self.contents = []
        self.style = .dynamicCellPrototype
        self.cellPrototype = cellPrototype
        
        //
        super.init()
    }
    
    // ----------------------------------------------------------------
    // API, volani z MHTable:
    var count: Int { contents.count }
    
    // ----------------------------------------------------------------
    // API, MHTable
    // cellAt - bunka
    // objectAt - pro dynamickou, chci datovy objekt (model)
    // dynamicAt - dynamicka, chci bunku
    func cellAt(row: Int) -> MHTableCell {
        //
        return contents[row]
    }
    
    //
    func objectAt(row: Int) -> Any? {
        //
        return nil
    }
    
    //
    func dynamicAt(row: Int, table: UITableView) -> MHTableCell {
        //
        fatalError("Not implemented")
    }
}


public extension MHSectionDriver {
    //
    static func on<T:CustomStringConvertible>(_ inputs: [T], header: String? = nil) -> MHSectionDriver
    {
        //
        MHSectionDriver(staticCells: inputs.map { MHRow.Text($0.description) },
                        header: header)
    }
    
}
