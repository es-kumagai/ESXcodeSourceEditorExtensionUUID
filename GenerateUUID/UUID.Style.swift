//
//  UUID.Style.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/15/16.
//
//

import Foundation

extension UUID {
	
	/// A expression style of UUID.
	enum ExpressionStyle {
		
		case simple
		case quoted(quatation: String)
	}
	
	/// A textual representation of the uuid using the specified style.
	func description(style: UUID.ExpressionStyle) -> String {
		
		return String(uuid: self, style: style)
	}
}

extension UUID.ExpressionStyle {
	
	/// Returns the appropriate expression style for the specified UTI.
	static func expressionStyle(for uti: UTI) -> UUID.ExpressionStyle {

		switch uti {
			
		case "public.source-code",
		     "com.apple.dt.playground",
		     "com.apple.dt.playgroundpage":
			return .quoted(quatation: "\"")
			
		default:
			return .simple
		}
	}
}

extension String {
	
	/// Creates a string that is a textual representation of `uuid` using `style`.
	init(uuid: UUID, style: UUID.ExpressionStyle = .simple) {
		
		switch style {
			
		case .simple:
			self = uuid.uuidString
			
		case .quoted(quatation: let quote):
			self = "\(quote)\(uuid.uuidString)\(quote)"
		}
	}
}
