//
//  String.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

extension String {
	
	/// Returns an index that is the specified distance from the start index.
	///
	/// - Parameter n: The distance to offset the start index.
	/// - Returns: An index offset by `n` from the start index.
	func index(offsetBy n: IndexDistance) -> Index {
		
		return index(startIndex, offsetBy: n)
	}

	/// Returns indices expressed by String.Index.
	///
	/// - Parameters:
	///		- start: The start offset.
	///		- end: The end offset.
	/// - Returns: An range represented by String.Index.
	func indicesOf(start: Int, end: Int) -> Range<String.Index> {
		
		return index(offsetBy: start) ..< index(offsetBy: end)
	}
	
	/// Returns a substring from `offset` to the end.
	///
	/// - Parameter offset: An offset to specify the start position.
	/// - Returns: A sliced string specified by `offset`.
	func substring(fromOffset offset: Int) -> String {
		
		return substring(from: index(offsetBy: offset))
	}

	/// Returns a substring from the start to `offset`.
	///
	/// - Parameter offset: An offset to specify the end position.
	/// - Returns: A sliced string specified by `offset`.
	func substring(toOffset offset: Int) -> String {
		
		return substring(to: index(offsetBy: offset))
	}
}
