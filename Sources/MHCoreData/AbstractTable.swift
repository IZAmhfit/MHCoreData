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
    case selectionFromElements
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
    
    //
    public init(forPurpose: MHTablePurpose) {
        //
        self.purpose = forPurpose
        
        //
        switch forPurpose {
        case .listOfElements:
            //
            buttonAdd = true
            
        case .detailOnObject:
            //
            buttonAdd = false
            
        case .selectionFromElements:
            //
            buttonAdd = false
        }
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
    public var config: MHTableConfig
    
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
    @objc open func buttonAddAction() {
        //
        config.addButton?(self)
    }
    
    // ----------------------------------------------------------------
    //
    @objc open func buttonOKAction() {
        //
    }
    
    // ----------------------------------------------------------------
    //
    @objc open func buttonCancelAction() {
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
    override open func didMove(toParent parent: UIViewController?) {
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
        buttonOKAction()
    }
}

