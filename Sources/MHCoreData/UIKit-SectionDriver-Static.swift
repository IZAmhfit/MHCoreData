//
//  File.swift
//  
//
//  Created by Martin Hruby on 24/03/2020.
//

import Foundation
import UIKit

///
/// DataSource pro jednu sekci.
/// Muze byt bud:
/// 1) static, pak bereme z pole
/// 2) FRC, dynamic
///
public class MHSectionDriver : NSObject {
    //
    public enum DType {
        //
        case staticCells
        case dynamicCellPrototype
    }
    
    //
    weak var mhTable: MHTable?
    
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
        self.style = .staticCells
        self.cellPrototype = nil
        
        //
        super.init()
    }
    
    //
    public init(cellPrototype: String, header: String? = nil) {
        //
        self.header = header
        self.contents = []
        self.style = .dynamicCellPrototype
        self.cellPrototype = cellPrototype
        
        //
        super.init()
    }
    
    //
    let header: String?
    let style: DType
    
    // static
    private let contents: [MHTableCell]
    
    // dynamic
    let cellPrototype: String?
    
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
