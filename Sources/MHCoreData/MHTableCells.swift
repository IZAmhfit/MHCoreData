//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit

// --------------------------------------------------------------------
// Jednotici typ bunek pro MHTable. Potrebuju selfConfig
open class MHTableCell : UITableViewCell {
    // a fakt nema smysl se prilis babrat se sablonovymi typy ;)
    // clovek ma jenom jedno mladi... ;)
    // ... takze parametr je Any, at si ho as? pretypuji ...
    open func selfConfig(with: Any) {
        //
    }
}

// --------------------------------------------------------------------
// Typizovany radek tabulky s jednoduchym formatem:
// UILabel...UI-neco (UILabel/TextField/Switcher/...)
// --------------------------------------------------------------------
// ... ty bunky to chce vic prostudovat v dokumentaci, TODO
public class MHRow<RightSide:UIView>: MHTableCell {
    // ----------------------------------------------------------------
    // demo konstrukce LText-RText
    // Pozn: v podstate UITableViewCell(style: detail...)
    static public func Text(_ ltext: String,
                            _ rtext: String? = nil) -> MHTableCell
    {
        //
        if let _rtext = rtext {
            //
            let _r = MHLabel(text: _rtext)
            
            //
            return MHRow<MHLabel>(ltext, right: _r)
        } else {
            //
            return MHRow<UIView>(ltext, right: nil)
        }
    }
    
    
    // ----------------------------------------------------------------
    //
    var ltext: UILabel!
    var rightSide: RightSide?
    
    // ----------------------------------------------------------------
    // ...
    public init(_ leftText: String, right: RightSide?) {
        // kaslu na style...
        super.init(style: .default, reuseIdentifier: nil)
        
        // na celou bunku udelam horizontalni StackView
        let hstack = baseStack()
        
        // cpu do HStack, zleva:
        ltext = hstack.add(label: leftText)
        rightSide = right
        
        // ... TODO, vic rozpracovat
        selectionStyle = .none
        
        // pokud existuje prava strana, vloz do HStacku
        if let _right = right {
            //
            hstack.add(inView: _right)
        }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}
