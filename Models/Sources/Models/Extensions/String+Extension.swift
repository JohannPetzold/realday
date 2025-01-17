//
//  String+Extension.swift
//  Models
//
//  Created by Johann Petzold on 17/01/2025.
//

import Foundation

extension String {
    
    private func validate(regex: String) -> Bool {
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        return predicate.evaluate(with: self)
    }
    
    public func isValidEmail() -> Bool {
        return validate(regex: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}")
    }
    
    public func isValidFirstName() -> Bool {
        return validate(regex: "^[A-Za-zÀ-ÖØ-öø-ÿ' -]{1,50}$")
    }

    public func isValidLastName() -> Bool {
        return validate(regex: "^[A-Za-zÀ-ÖØ-öø-ÿ' -]{1,100}$")
    }
}
