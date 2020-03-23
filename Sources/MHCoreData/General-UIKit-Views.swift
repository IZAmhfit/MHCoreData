//
//  File.swift
//  
//
//  Created by Martin Hruby on 23/03/2020.
//

import Foundation
import UIKit

//
public extension UIView {
    //
    func baseStack(_ pin: CGFloat = 20) -> UIStackView {
        //
        let hstack = UIStackView()
        
        //
        addSubview(hstack)
        
        //
        hstack.translatesAutoresizingMaskIntoConstraints = false
        hstack.axis = .horizontal
        
        //
        hstack.leftAnchor.constraint(equalTo: leftAnchor,
                                     constant: pin).isActive = true
        hstack.rightAnchor.constraint(equalTo: rightAnchor,
                                      constant: -pin).isActive = true
        hstack.topAnchor.constraint(equalTo: topAnchor,
                                    constant: pin).isActive = true
        hstack.bottomAnchor.constraint(equalTo: bottomAnchor,
                                       constant: -pin).isActive = true
        
        //
        return hstack
    }
}

//
public extension UIStackView {
    //
    func addSpacing(_ sp: CGFloat = 5) {
        //
        spacing = sp
    }
    
    //
    func minHeight(_ val: CGFloat) {
        //
        heightAnchor.constraint(greaterThanOrEqualToConstant: val).isActive = true
    }
    
    //
    func hstack() -> UIStackView {
        //
        let h = UIStackView()
        
        //
        h.axis = .horizontal
        h.translatesAutoresizingMaskIntoConstraints = false
        
        //
        addArrangedSubview(h)
        
        //
        return h
    }
    
    //
    func vstack() -> UIStackView {
        //
        let h = UIStackView()
        
        //
        h.axis = .vertical
        h.translatesAutoresizingMaskIntoConstraints = false
        
        //
        addArrangedSubview(h)
        
        //
        return h
    }
    
    //
    func add(inView: UIView) {
        //
        addArrangedSubview(inView)
        
        //
        inView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    //
    func add(label cont: String = "") -> UILabel
    {
        let ltext = UILabel()
        
        //
        addArrangedSubview(ltext)
        
        //
        ltext.translatesAutoresizingMaskIntoConstraints = false
        ltext.textAlignment = .left
        ltext.text = cont
        
        //
        return ltext
    }
    
    //
    func add(image cont: UIImage?, size: CGSize?) -> UIImageView
    {
        let ima = UIImageView(image: cont)
        
        //
        addArrangedSubview(ima)
        
        //
        ima.translatesAutoresizingMaskIntoConstraints = false
        
        //
        if let _size = size {
            //
            ima.widthAnchor.constraint(equalToConstant: _size.width).isActive = true
            ima.heightAnchor.constraint(equalToConstant: _size.height).isActive = true
        }
        
        //
        return ima
    }
}



