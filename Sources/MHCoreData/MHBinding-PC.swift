//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation


// --------------------------------------------------------------------
//
extension NSNotification {
    //
    static let pcBindings = NSNotification.Name("MHCoreData.pcBindings")
}

// --------------------------------------------------------------------
// vazba na nejaky druh producenta
public class Binding<Value> {
    // producent, prima vazna strong (producent ne-referencuje konzumenta)
    let source: Producer<Value>
    public  var delegate: ((Value)->())?
    
    //
    var value: Value {
        //
        get { source._wrappedValue }
        set { source._wrappedValue = newValue }
    }
    
    // akce pro NotifC
    @objc func action(_ notif: Notification) {
        //
        print(source._wrappedValue)
    }
    
    // volani do producenta
    func setValue(_ v: Value) {
        //
        source._wrappedValue = v;
    }
    
    //
    public init(to: Producer<Value>) {
        //
        self.source = to
        
        //
        NotificationCenter.default.addObserver(self, selector: #selector(action(_:)), name: NSNotification.pcBindings, object: to)
    }
    
    deinit {
        //
        NotificationCenter.default.removeObserver(self)
    }
}


// --------------------------------------------------------------------
//
public class Producer<Element> {
    //
    func ping() {
        //
        NotificationCenter.default.post(.init(name: NSNotification.pcBindings, object: self, userInfo: nil))
    }
    
    //
    public var _wrappedValue: Element {
        //
        didSet {
            //
            ping()
        }
    }
    
    //
    public var rawLabel = ""
    
    //
    init(i:Element, rawLabel: String = "") {
        //
        _wrappedValue = i
        
        //
        self.rawLabel = rawLabel
    }
}

// --------------------------------------------------------------------
//
@propertyWrapper public class MHPublishedT<Value> : Producer<Value> {
    //
    public var wrappedValue: Value {
        //
        get { _wrappedValue }
        set { _wrappedValue = newValue }
    }
    
    //
    public var projectedValue: Binding<Value> { Binding(to: self) }
    
    //
    public init(wrappedValue: Value) {
        //
        super.init(i: wrappedValue)
    }
    
    //
    public init(label: String, defaultValue: Value) {
        //
        super.init(i: defaultValue, rawLabel: label)
    }
}

// --------------------------------------------------------------------
//
public class OtherProducer<Root, Element> : Producer<Element> {
    //
    let key: ReferenceWritableKeyPath<Root, Element>
    let model: Root
    
    override public var _wrappedValue: Element {
        //
        get { model[keyPath:key] }
        set { model[keyPath:key] = newValue; ping() }
    }
    
    //
    public init(_ root: Root, key: ReferenceWritableKeyPath<Root, Element>) {
        //
        model = root; self.key = key
        
        //
        super.init(i: model[keyPath:key])
    }
}

