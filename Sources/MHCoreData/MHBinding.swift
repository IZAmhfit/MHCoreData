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
// Publikovana hodnota je objekt drzici reference (strong) na observery
// Observer je povinnen se pri deint odhlasit (koncept NotifCenter)
// --------------------------------------------------------------------
//
@propertyWrapper public class MHPublished<Value> {
    //
    public typealias Binding = MHBinding<Value>
    
    // ----------------------------------------------------------------
    // ocekavam MainThread
    public var wrappedValue: Value {
        //
        didSet {
            //
            MTE()
            
            // posilam zpravu observerum, ti ji predaji svym delegatum
            observers.forEach { $0.valueUpdate(wrappedValue) }
        }
    }
    
    // ----------------------------------------------------------------
    // vytvor bind wrapper nad published...self
    public var projectedValue: Binding { MTE(); return MHBinding(self) }
    
    // ----------------------------------------------------------------
    // pole strong referenci. Tady dochazi zamerne referencni vazbe
    private var observers = [Binding]()
    
    // ----------------------------------------------------------------
    // ocekavam MainThread
    public func addObserver(_ o: Binding) { MTE(); observers.append(o) }
    
    // ----------------------------------------------------------------
    // ocekavam MainThread
    public func remObserver(_ o: Binding) {
        //
        MTE()
        
        //
        observers = observers.filter { ($0 === o) == false }
    }
    
    // ----------------------------------------------------------------
    //
    public init(wrappedValue: Value) {
        //
        self.wrappedValue = wrappedValue
    }
}


// --------------------------------------------------------------------
// MTE
public class MHBinding<Value> {
    //
    private let him: MHPublished<Value>
    public  var delegate: ((Value)->())?
    
    // wrap nad hodnotou
    public  var value: Value {
        //
        get { MTE(); return him.wrappedValue }
        set { MTE(); him.wrappedValue = newValue }
    }
    
    // zprava od Published strany, preposilam delegatovi
    func valueUpdate(_ v: Value) {
        //
        MTE()
        
        //
        delegate?(v)
    }
    
    //
    public init(_ with: MHPublished<Value>) {
        //
        him = with;
        
        //
        with.addObserver(self)
    }
    
    //
    deinit {
        //
        him.remObserver(self)
    }
}
