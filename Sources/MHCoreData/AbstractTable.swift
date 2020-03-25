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
// Ucely daneho VC. Ovlivnuje jeho chovani pri nekterych akcich
// - selekce bunky (tabulka)
// - ukoncovani VC
public enum MHTablePurpose {
    // tabulka slouzi jako seznam bunek. Lze navazat pohledem na
    // detail bunky
    case listOfElements
    
    // tabulka je vyberovy picker. Pri selekci bunky se VC ukoncuje
    case selectionFromElements
    
    // tabulka je detailnim pohledem na konkretni objekt
    case detailOnObject
}

// --------------------------------------------------------------------
// Zatim neprilis usporadany soubor nastaveni pro objekt typu MHTable
// --------------------------------------------------------------------
// Poznamka: asi by vsechny atributy mely byt "let"...
public struct MHTableConfig {
    // ----------------------------------------------------------------
    // groupped/plain
    public var style: UITableView.Style = .plain
    // purpose: pro jake ucely byl tento VC konstruovan
    public var purpose: MHTablePurpose = .listOfElements
    
    // ----------------------------------------------------------------
    // konfigurace automaticky vytvarenuch UIBarButtonItem na NavVC
    public var buttonAdd = false
    public var buttonOK = false
    public var buttonCancel = false
    
    // ----------------------------------------------------------------
    // akce na ruzne situace. TODO: zatim nepouzivano. Smyslem
    // je napojit externi akce na tlacitka
    public var addButton: MHAction? = nil
    public var selectionIndexPath: MHOnCellAction? = nil
    public var selectionObjectIndexPath: MHOnObjectCellAction? = nil
    
    //
    public init() {
        //
    }
    
    //
    public init(forPurpose: MHTablePurpose = .listOfElements) {
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
// Navratova hodnota pri delegacni komunikaci VC
public enum MHVCDelegationReturn {
    // koncim a akceptuju vysledek
    case ended
    // pokud bylo potreba schvalit vysledek, pak rikam NE
    case cancel
    // vysledkem je zvoleny objekt (typicky pri purpose=.selectionFromElements)
    case selected(Any?)
}

// --------------------------------------------------------------------
// Delegacni komunikace VC -> parent VC
public protocol MHVCDelegation {
    // nejak si zarid existenci reference na parent delegate
    var vcDelegate: MHVCDelegation? { get }
    
    // metoda na strane prijmu zpravy
    func vcDelegationMessage(from: MHVCDelegation, arg: MHVCDelegationReturn)
}

// --------------------------------------------------------------------
// Odeslani zpravy
public extension MHVCDelegation {
    // ...
    func vcDelegationSend(arg: MHVCDelegationReturn) {
        //
        if let _del = vcDelegate {
            //
            DispatchQueue.main.async {
                //
                _del.vcDelegationMessage(from: self, arg: arg)
            }
        }
    }
}

// --------------------------------------------------------------------
// Abstraktni funkcionalita nad VC typu tabulka
// - ucel
// - udalosti
// - ovladaci prvky (tlacitka)
open class MHAbstractTable : UITableViewController, MHVCDelegation {
    // ----------------------------------------------------------------
    // Externe zadana konfigurace tabulky
    public var config: MHTableConfig
    public var vcDelegate: MHVCDelegation?
    
    // ----------------------------------------------------------------
    // pokud VC pri sve cinnosti sestavi vysledek pro delegata,
    // pak se tento vysledek pouzije pri jeho ukoncovani automaticky
    public var _vcMessageForDelegate: MHVCDelegationReturn?
    
    // ----------------------------------------------------------------
    // ...
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
    
    // ----------------------------------------------------------------
    //
    lazy var __buttonAdd = UIBarButtonItem(barButtonSystemItem: .add,
                                           target: self,
                                           action: #selector(buttonAddAction))
    
    //
    lazy var __buttonOK = UIBarButtonItem(barButtonSystemItem: .save,
                                           target: self,
                                           action: #selector(buttonOKAction))
    
    //
    lazy var __buttonCancel = UIBarButtonItem(barButtonSystemItem: .cancel,
                                              target: self,
                                              action: #selector(buttonCancelAction))
    
    // ----------------------------------------------------------------
    // interni funkce pro zachyceni akce od BarButtonItem
    // (musi byt @objc), tlacitko .add
    @objc open func buttonAddAction() {
        //
        config.addButton?(self)
    }
    
    // ----------------------------------------------------------------
    // tlacitko .save
    @objc open func buttonOKAction() {
        //
    }
    
    // ----------------------------------------------------------------
    // tlacitko .cancel
    @objc open func buttonCancelAction() {
        //
    }
    
    // ----------------------------------------------------------------
    //
    open override func viewDidLoad() {
        //
        super.viewDidLoad()
        
        //
        var _rButtons = [UIBarButtonItem]()
    
        //
        if config.buttonAdd { _rButtons.append(__buttonAdd) }
        if config.buttonOK { _rButtons.append(__buttonOK) }
        if config.buttonCancel { _rButtons.append(__buttonCancel) }
        
        //
        navigationItem.rightBarButtonItems = _rButtons
    }
    
    // ----------------------------------------------------------------
    // VC se rozhodne sam sebe ukoncit. Pokud byla vyplnena zprava
    // pro delegata, pak se pouzije (vizte "didMove(:))
    open func quitMe() {
        // pokud jsem zabaleny do NAV, pak pop
        if let _nav = navigationController {
            //
            _nav.popViewController(animated: true)
        } else {
            // zrejme jsem byl prezentovan modalne, pak:
            // TODO: overit, zda-li didMove dostanu, ikdyz jsem
            // byl prezentovan modalne
            dismiss(animated: true) { self.eventEnding() }
        }
    }
    
    // ----------------------------------------------------------------
    // VC se rozhodne sam sebe ukoncit a k tomu prilozi zpravu
    open func quitMe(responseToDelegate: MHVCDelegationReturn?) {
        //
        _vcMessageForDelegate = responseToDelegate
        
        //
        quitMe()
    }
    
    // ----------------------------------------------------------------
    // tuto zpravu VC obdrzi tento VC, kdyz je manipulovan z pohledu
    // kontejneroveho VC (typicky NAV)
    override open func didMove(toParent parent: UIViewController?) {
        //
        super.didMove(toParent: parent)
        
        // != nil, dostavam rodicovsky vc
        // == nil, berou mi rodicovsky vc, tj. rodic me odmontovava
        if parent == nil {
            //
            eventEnding()
        }
    }
    
    // ----------------------------------------------------------------
    // pokud ma VC ukonceni pod svoji kontrolou, pak zajisti, aby
    // se spustilo tohle. Chci, aby se to spustilo, az tento VC
    // zmizi z obrazovky
    // TODO: mozna vic rozpracovat vzhledem k purpose
    func eventEnding() {
        // implicitni chovani
        buttonOKAction()
        
        // je nejaka zprava pro delegata, pak posilam
        if let _msg = _vcMessageForDelegate {
            //
            vcDelegationSend(arg: _msg)
        }
    }
    
    // ----------------------------------------------------------------
    // prijeti zpravy od delegata
    // predpoklada se pretizeni u navazujicich VC
    open func vcDelegationMessage(from: MHVCDelegation,
                                  arg: MHVCDelegationReturn)
    {
        //
    }
}

