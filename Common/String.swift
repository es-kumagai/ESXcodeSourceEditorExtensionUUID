//
//  String.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

extension String {
	
	func index(offsetBy n: IndexDistance) -> Index {
		
		return index(startIndex, offsetBy: n)
	}
	
	func indicesOf(start: Int, end: Int) -> Range<String.Index> {
		
		return index(offsetBy: start) ..< index(offsetBy: end)
	}
	
	func substring(fromOffset offset: Int) -> String {
		
		return substring(from: index(offsetBy: offset))
	}
	
	func substring(toOffset offset: Int) -> String {
		
		return substring(to: index(offsetBy: offset))
	}
}
