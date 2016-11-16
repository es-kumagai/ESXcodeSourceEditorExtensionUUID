//
//  SourceTextBuffer.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

import Foundation
import XcodeKit

/// A wrapper type of XCSourceTextBuffer that supplies additional features.
///
/// - attention: At first I attempted to implement features with type extension,
///   but the application crashed when the features is called from Xcode Source
///   Editor Extension running with Objective-C runtime.
///   Because these features implemented by this class.
final class SourceTextBuffer {
	
	/// Current Source Text Buffer.
	let rawBuffer: XCSourceTextBuffer
	
	/// Source Text Lines managed by SourceTextBuffer.Lines class.
	private(set) var lines: Lines!
	
	/// Creates an instance containing `textBuffer` passed in the argument.
	init(buffer textBuffer: XCSourceTextBuffer) {
		
		rawBuffer = textBuffer
		lines = Lines(owner: self)
	}
}

extension SourceTextBuffer {
	
	/// The type to manage Source Text Lines of `owner`.
	final class Lines {
		
		/// The parent instance that owns this instance.
		fileprivate unowned let owner: SourceTextBuffer
		
		/// Creates an instance with this owner.
		init(owner: SourceTextBuffer) {
			
			self.owner = owner
		}
	}
}

extension SourceTextBuffer {
	
	/// Creates an instance containing the source text buffer that `invocation` have.
	convenience init(invocation: XCSourceEditorCommandInvocation) {
		
		self.init(buffer: invocation.buffer)
	}
	
	/// The text selections in the buffer.
	var selections: Array<XCSourceTextRange> {
		
		return rawBuffer.selections.map { $0 as! XCSourceTextRange }
	}
	
	/// Returns the Unique Type Identifier (UTI) of the content in the buffer.
	var contentUTI: UTI {
		
		return UTI(string: rawBuffer.contentUTI)
	}
}

extension SourceTextBuffer.Lines {
	
	/// Accesses the lines specified by the text range.
	subscript (range range: XCSourceTextRange) -> String {
		
		get {
			
			switch (range.start, range.end) {
				
			case let (start, end) where start.line == end.line:
				
				let text = self[start.line]
				let range = text.indicesOf(start: start.column, end: end.column)
				
				return text.substring(with: range)
				
			case let (start, end):
				
				let texts = self[start.line ..< end.line]
				
				let startText = texts.first!.substring(fromOffset: start.column)
				let lastText = texts.last!.substring(fromOffset: end.column)
				
				let results = [[startText], Array(texts.dropLast().dropFirst()), [lastText]].flatMap { $0 }
				
				return results.joined()
			}
		}
		
		set {
			
			func updateSelection() {
				
				range.end.line = range.start.line
				range.end.column = range.start.column + newValue.characters.count
			}
			
			defer {
				
				updateSelection()
			}
			
			switch (range.start, range.end) {
				
			case let (start, end) where start.line == end.line:
				
				let line = start.line
				let text = self[line]
				let textIndices = text.indicesOf(start: start.column, end: end.column)
				
				self[line] = text.replacingCharacters(in: textIndices, with: newValue)
				
			case let (start, end):
				
				let startText = self[start.line]
				let lastText = self[end.line]
				
				self[start.line] = startText.substring(toOffset: start.column) + newValue + lastText.substring(fromOffset: end.column)
				
				for line in (start.line + 1 ... end.line).reversed() {
					
					self[line] = ""
				}
			}
		}
	}
}

// MARK: - Collection
extension SourceTextBuffer.Lines : BidirectionalCollection {
	
	/// The position of the first line in a nonempty collection.
	var startIndex: Int {
		
		return 0
	}

	/// The position one greater than the last line.
	///
	/// If the collection is empty, this is equal to `startIndex`.
	var endIndex: Int {
		
		return owner.rawBuffer.lines.count
	}
	
	/// Accesses the lines specified by the offset, If a line number that is not exists is specified, returns an empty string or inserts empty lines.
	///
	/// When editting the last line or the previous line of the last line, The source buffer is not contains the last line.
	/// For that reason, assumes to empty line is exist there.
	///
	/// - Parameter offset: The number of offset to specify a line.
	/// - Parameter newValue: The string for set. If it is empty, the line will remove.
	/// - Returns: The string specified by the offset. This includes a new line character at the end of the line.
	subscript (offset: Int) -> String {
		
		get {
			
			switch offset < owner.rawBuffer.lines.count {
				
			case true:
				return owner.rawBuffer.lines[offset] as! String
				
			case false:
				return ""
			}
		}
		
		set (newValue) {
			
			let countOfLines = owner.rawBuffer.lines.count
			
			if offset >= countOfLines {

				let emptyLines = Array(repeating: "", count: offset - countOfLines + 1)
				
				owner.rawBuffer.lines.addObjects(from: emptyLines)
			}
			
			if newValue.isEmpty {
				
				owner.rawBuffer.lines.removeObject(at: offset)
			}
			else {
				
				owner.rawBuffer.lines[offset] = newValue
			}
		}
	}
	
	/// Returns an index that immediately after the given index.
	///
	/// - Parameter i: A valid index of this collection.
	/// - Returns: The index value immediately after `i`.
	/// - Precondition: `i` must be less than `endIndex`.
	func index(after i: Int) -> Int {
		
		return i + 1
	}
	
	/// Returns an index that immediately before the given index.
	///
	/// - Parameter i: A valid index of this collection.
	/// - Returns: The index value immediately before `i`.
	/// - Precondition: `i` must be greater than `startIndex`.
	func index(before i: Int) -> Int {
		
		return i - 1
	}
}

