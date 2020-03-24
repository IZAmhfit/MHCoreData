//
//  File.swift
//  
//
//  Created by Martin Hruby on 24/03/2020.
//

import Foundation
import UIKit

// --------------------------------------------------------------------
//
public typealias MHTableCells = [MHTableCell]
public typealias MHAction = (UIViewController)->()
public typealias MHOnCellAction = (UIViewController, IndexPath)->()
public typealias MHOnObjectCellAction = (UIViewController, IndexPath, MHTableCell)->()


// --------------------------------------------------------------------
//
public enum MHTablePurpose {
    //
    case listOfElements
    case detailOnObject
}

// --------------------------------------------------------------------
//
//
public struct MHTableConfig {
    // groupped/plain
    public var style: UITableView.Style = .plain
    public var purpose: MHTablePurpose = .listOfElements
    
    //
    public var buttonAdd = false
    public var buttonOK = false
    public var buttonCancel = false
    
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


// --------------------------------------------------------------------
// Abstraktni funkcionalita nad VC typu tabulka
// - ucel
// - udalosti
// - ovladaci prvky (tlacitka)
open class MHAbstractTable : UITableViewController {
    // ----------------------------------------------------------------
    // Externe zadana konfigurace tabulky
    let config: MHTableConfig
    
    // ----------------------------------------------------------------
    //
    init(cfg: MHTableConfig) {
        //
        config = cfg;
        
        // plain/grouped
        super.init(style: cfg.style)
    }
    
    //
    required public init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    lazy var __buttonAdd = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(buttonAddAction))
    
    //
    lazy var __buttonOK = UIBarButtonItem(barButtonSystemItem: .save,
                                           target: self,
                                           action: #selector(buttonOKAction))
    
    // ----------------------------------------------------------------
    // interni funkce pro zachyceni akce od BarButtonItem
    // (musi byt @objc)
    @objc public func buttonAddAction() {
        //
        config.addButton?(self)
    }
    
    // ----------------------------------------------------------------
    //
    @objc public func buttonOKAction() {
        //
    }
    
    // ----------------------------------------------------------------
    //
    @objc public func buttonCancelAction() {
        //
    }
    
    // ----------------------------------------------------------------
    //
    open override func viewDidLoad() {
        //
        super.viewDidLoad()
        
        //
        if config.buttonAdd {
            //
            navigationItem.rightBarButtonItem = __buttonAdd
        }
    }
    
    // ----------------------------------------------------------------
    //
    open override func didMove(toParent parent: UIViewController?) {
        //
        super.didMove(toParent: parent)
        
        //
        if parent == nil {
            //
            eventEnding()
        }
    }
    
    // ----------------------------------------------------------------
    //
    open func eventEnding() {
        //
        if config.purpose == .detailOnObject {
            //
            buttonOKAction()
        }
    }
    
    // ----------------------------------------------------------------
    //
    open func event(indexPathSelected: IndexPath) {
        //
        if let _act = config.selectionIndexPath {
            //
            _act(self, indexPathSelected)
        }
    }
    
    // ----------------------------------------------------------------
    //
    override public func tableView(_ tableView: UITableView,
                                   didSelectRowAt indexPath: IndexPath)
    {
        //
        event(indexPathSelected: indexPath)
    }
}

