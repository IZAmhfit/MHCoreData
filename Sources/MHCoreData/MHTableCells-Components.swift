//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit

// --------------------------------------------------------------------
// System komponent pro MHTableCell napojitelnych na model (binding)
// --------------------------------------------------------------------
// Lze pouzit bud volne nebo napojene

// --------------------------------------------------------------------
// UILabel,
public class MHLabel: UILabel {
    // napojeni na model, string
    private var _modelBinding: MHBinding<String>?
    
    // volne pouziti
    public init(text: String) {
        //
        super.init(frame: CGRect())
        
        //
        self.text = text
    }
    
    // pouzi s binding,,,,
    public init(bind: MHBinding<String>) {
        //
        self._modelBinding = bind
        
        //
        super.init(frame: CGRect())
        
        // pocatecni hodnota
        text = _modelBinding!.value
        
        // kdyz se model modifikuje, pres binding dostanu zpravu
        // toto je akce na obsluhu te zpravy
        _modelBinding!.delegate = { str in self.text = str }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}


// --------------------------------------------------------------------
//
public class MHTextField: UITextField {
    //
    private var _modelBinding: MHBinding<String>?
    
    // udalost od UITextField
    @objc func __valueEvent() {
        // preposilam pres binding do modelu
        _modelBinding?.value = text ?? ""
    }
    
    //
    public init(bind: MHBinding<String>) {
        //
        self._modelBinding = bind
        
        //
        super.init(frame: CGRect())
        
        // registruju akci na udalost
        addTarget(self, action: #selector(__valueEvent), for: .editingChanged)
        
        //
        text = _modelBinding!.value
        textAlignment = .right
        widthAnchor.constraint(greaterThanOrEqualToConstant: 100).isActive = true
        
        //
        _modelBinding?.delegate = { str in self.text = str }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}

// --------------------------------------------------------------------
//
public class MHSwitch: UISwitch {
    //
    private var _modelBinding: MHBinding<Bool>?
    
    //
    @objc func __valueEvent() {
        //
        _modelBinding?.value = isOn
    }
    
    //
    public init(bind: MHBinding<Bool>) {
        //
        self._modelBinding = bind
        
        //
        super.init(frame: CGRect())
        
        //
        addTarget(self, action: #selector(__valueEvent), for: .valueChanged)
        
        //
        _modelBinding!.delegate = { self.setOn($0, animated: true) }
        
        //
        setOn(_modelBinding!.value, animated: false)
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}

