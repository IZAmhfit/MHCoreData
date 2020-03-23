//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit

///
/// Kdokoli, kdo odpovi na "cell", je pouzitelny.
///
public protocol MHTableCell {
    //
    var cell: UITableViewCell { get }
}


///
///
///
public class MHRow<RightSide:UIView>: UITableViewCell, MHTableCell {
    //
    public var cell: UITableViewCell { self }
    
    //
    static public func Text(_ ltext: String, _ rtext: String? = nil) -> MHTableCell {
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
    
    
    //
    var ltext: UILabel!
    var rightSide: RightSide?
    
    //
    public init(_ leftText: String, right: RightSide?) {
        //
        super.init(style: .default, reuseIdentifier: nil)
        
        //
        let hstack = baseStack()
        
        //
        ltext = hstack.add(label: leftText)
        rightSide = right
        
        //
        selectionStyle = .none
        
        //
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
