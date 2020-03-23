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
public class MHLabel: UILabel {
    //
    private var _modelBinding: MHBinding<String>?
    
    //
    public init(text: String) {
        //
        super.init(frame: CGRect())
        
        //
        self.text = text
    }
    
    //
    public init(bind: MHBinding<String>) {
        //
        self._modelBinding = bind
        
        //
        super.init(frame: CGRect())
        
        //
        text = _modelBinding!.value
        
        //
        _modelBinding!.delegate = { str in self.text = str }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}


///
///
///
public class MHTextField: UITextField {
    //
    private var _modelBinding: MHBinding<String>?
    
    //
    @objc func __valueEvent() {
        //
        _modelBinding?.value = text ?? ""
    }
    
    //
    public init(bind: MHBinding<String>) {
        //
        self._modelBinding = bind
        
        //
        super.init(frame: CGRect())
        
        //
        addTarget(self, action: #selector(__valueEvent), for: .editingChanged)
        
        //
        text = _modelBinding!.value
        
        //
        _modelBinding?.delegate = { str in self.text = str }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}

/// --------------------------------------------------------------------
///
///
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
        if let _mb = _modelBinding {
            //
            _mb.delegate = {
                //
                self.setOn($0, animated: true)
            }
            
            //
            setOn(_mb.value, animated: false)
        }
    }
    
    //
    required init?(coder: NSCoder) {
        //
        fatalError("init(coder:) has not been implemented")
    }
}

