//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation


// --------------------------------------------------------------------
// duveruj, ale proveruj...paranoiaLevel == .high
// --------------------------------------------------------------------
// Clovek si musi dobrovolne vybrat, jestli
// 1) bude pracovat u techto casti programu s predpokladem MainThread
// 2) nebo bude zamykat a SOUCASNE (!!!) zpravy preposilat pred MT
public func MTE() {
    //
    assert(Thread.isMainThread, "Main Thread Expected")
}


// --------------------------------------------------------------------
// Distribuce zprav pujde pres notifikacni centrum...mozna
public extension NSNotification {
    //
    static let pcBindings = NSNotification.Name("MHCoreData.pcBindings")
}

// --------------------------------------------------------------------
// Vztah na Wrapper a delegate na uzivatele napojeni
public class MHBinding<Value> {
    // univerzalni wrapper hodnoty, binding si na neho drzi referenci
    let wrapper: MHWrapper<Value>
    
    // uzivatel hodnoty dostane tuhle zpravu
    var delegate: ((Value)->())?
    
    // zapis do wrapperu, kontroluju si vlakno
    public var value: Value {
        //
        get { MTE(); return wrapper.value }
        set { MTE(); wrapper.value = newValue }
    }
    
    // zprava od wrapperu (povazuju za interni)
    func valueUpdated() {
        // preposilam do uzivatele
        delegate?(wrapper.value)
    }
    
    //
    public init(_ on: MHWrapper<Value>) {
        //
        self.wrapper = on
        
        // binding vznika, hlasi se
        wrapper.add(observer: self)
    }
    
    // binding zanika, odhlasi se
    deinit {
        //
        wrapper.remove(observer: self)
    }
}


// --------------------------------------------------------------------
// spojovnik mezi propertyWrapper a Binding
public class MHWrapper<Value> {
    // ----------------------------------------------------------------
    // seznam binding
    // !!! vedomy referencni cyklus:
    // 1) observers ma strong-ref na bindings
    // 2) bindings maji strong-ref na wrapper - predpokladam z jejich
    // strany se cyklus rozpoji
    // ----------------------------------------------------------------
    // observers je nutno bud 1) zamykat, nebo 2) MTE()
    var observers = [MHBinding<Value>]()
    
    // nekdo sem zapise, sirim na binding
    public var value: Value {
        //
        didSet {
            //
            MTE()
            
            //
            observers.forEach { $0.valueUpdated() }
        }
    }
    
    //
    func add(observer: MHBinding<Value>) {
        //
        MTE(); observers.append(observer)
    }
    
    //
    func remove(observer: MHBinding<Value>) {
        //
        MTE(); observers = observers.filter { ($0 === observer) == false }
    }
    
    //
    public init(i:Value) {
        //
        self.value = i
    }
}

// --------------------------------------------------------------------
// Property Wrapper nad hodnotou
@propertyWrapper public class MHPublished<Value> {
    // vytvori interni model
    let wrapper: MHWrapper<Value>
    
    //
    public var rowLabel = ""
    
    // rozhrani na wrapper
    public var wrappedValue: Value {
        //
        get { MTE(); return wrapper.value }
        set { MTE(); wrapper.value = newValue; }
    }
    
    // propertywrapper - $id
    public var projectedValue: MHBinding<Value> { MHBinding(wrapper) }
    
    //
    public init(wrappedValue: Value) {
        //
        self.wrapper = MHWrapper(i: wrappedValue)
    }
    
    //
    public init(label: String, defaultValue: Value) {
        //
        self.wrapper = MHWrapper(i: defaultValue)
        self.rowLabel = label
    }
}

// --------------------------------------------------------------------
//
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
