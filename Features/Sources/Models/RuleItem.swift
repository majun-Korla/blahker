//
//  RuleItem.swift
//  Features
//
//  Created by Mason Ma on 2024/9/24.
//
import Foundation

public struct RuleItem: Equatable, Identifiable, Decodable {
    public var domain: String
    public var selectors: [String]
    public var id: String {
        domain
    }

    public init(domain: String, selectors: [String]) {
        self.domain = domain
        self.selectors = selectors
    }
}
