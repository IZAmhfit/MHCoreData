//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation


// --------------------------------------------------------------------
//
public func MTE() {
    //
    assert(Thread.isMainThread, "Main Thread Expected")
}


// --------------------------------------------------------------------
//
public extension NSNotification {
    //
    static let pcBindings = NSNotification.Name("MHCoreData.pcBindings")
}

// --------------------------------------------------------------------
// Vztah na Wrapper a delegate na uzivatele napojeni
public class MHBinding<Value> {
    // univerzalni wrapper hodnoty
    let wrapper: MHWrapper<Value>
    // uzivatel hodnoty
    var delegate: ((Value)->())?
    
    // zapis do wrapperu
    public var value: Value {
        //
        get { wrapper.value }
        set { wrapper.value = newValue }
    }
    
    // zprava od wrapperu
    func valueUpdated() {
        // preposilam do uzivatele
        delegate?(wrapper.value)
    }
    
    //
    public init(_ on: MHWrapper<Value>) {
        //
        self.wrapper = on
        
        //
        wrapper.add(observer: self)
    }
    
    deinit {
        //
        wrapper.remove(observer: self)
    }
}

// --------------------------------------------------------------------
// spojovnik mezi propertyWrapper a Binding
public class MHWrapper<Value> {
    // seznam binding
    var observers = [MHBinding<Value>]()
    
    // nekdo sem zapise, sirim na binding
    public var value: Value {
        //
        didSet {
            //
            observers.forEach { $0.valueUpdated() }
        }
    }
    
    //
    func add(observer: MHBinding<Value>) {
        //
        observers.append(observer)
    }
    
    //
    func remove(observer: MHBinding<Value>) {
        //
        observers = observers.filter { ($0 === observer) == false }
    }
    
    //
    public init(i:Value) {
        //
        self.value = i
    }
}

//
@propertyWrapper public class MHPublished<Value> {
    //
    let wrapper: MHWrapper<Value>
    
    public let rowLabel = "Ahoj"
    
    //
    public var wrappedValue: Value {
        //
        get { wrapper.value }
        set { wrapper.value = newValue; }
    }
    
    //
    public var projectedValue: MHBinding<Value> { MHBinding(wrapper) }
    
    //
    public init(wrappedValue: Value) {
        //
        self.wrapper = MHWrapper(i: wrappedValue)
    }
}

@propertyWrapper public class MHPublishedKey<Root, Value> {
    //
    let model: Root
    let key: ReferenceWritableKeyPath<Root, Value>
    
    //
    let wrapper: MHWrapper<Value>
    
    //
    public let rowLabel = "Ahoj"
    
    //
    public var wrappedValue: Value {
        //
        get { model[keyPath:key] }
        set { model[keyPath:key] = newValue; wrapper.value = newValue }
    }
    
    //
    public var projectedValue: MHBinding<Value> { MHBinding(wrapper) }
    
    //
    public init(model: Root, key: ReferenceWritableKeyPath<Root, Value>) {
        //
        self.model = model; self.key = key
        self.wrapper = MHWrapper(i: model[keyPath:key])
    }
}


// --------------------------------------------------------------------
//
public extension MHPublished where Value == Bool {
    //
    var asRow: MHRow<MHSwitch> {
        //
        MHRow(rowLabel, right: MHSwitch(bind: projectedValue))
    }
}

// --------------------------------------------------------------------
//
public extension MHPublished where Value == String {
    //
    var asRow: MHRow<MHLabel> {
        //
        MHRow(rowLabel, right: MHLabel(bind: projectedValue))
    }
    
    //
    var asERow: MHRow<MHTextField> {
        //
        MHRow(rowLabel, right: MHTextField(bind: projectedValue))
    }
}
