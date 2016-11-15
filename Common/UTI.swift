//
//  UTI.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/15/16.
//
//

import Foundation

/// A wrapper type that handles an Unique Type Identifier (UTI)
public struct UTI {
	
	/// The UTI that this instance has.
	public var string: String
	
	/// Creates the instance handles the UTI specified by `string`.
	public init(string: String) {
		
		self.string = string
	}
}

extension UTI {
	
	/// Returns a boolean value whether this uti conforms to `uti`.
	public func conforms(to uti: UTI) -> Bool {
		
		return UTTypeConformsTo(string as CFString, uti.string as CFString)
	}
	
	/// Returns a boolean value whether `value` conforms to other uti specified by `pattern`.
	static func ~= (pattern: UTI, value: UTI) -> Bool {
		
		return value.conforms(to: pattern)
	}
}

extension UTI : CustomStringConvertible {

	/// A textual representation of this instance.
	public var description: String {
		
		return string
	}
}

extension UTI : ExpressibleByStringLiteral {
	
	public init(stringLiteral value: String) {
		
		self.init(string: value)
	}
	
	public init(extendedGraphemeClusterLiteral value: String) {
		
		self.init(string: value)
	}
	
	public init(unicodeScalarLiteral value: String) {
		
		self.init(string: value)
	}
}
