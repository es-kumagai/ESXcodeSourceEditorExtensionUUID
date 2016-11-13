//
//  SourceTextBuffer.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

import Foundation
import XcodeKit

final class SourceTextBuffer {
	
	let buffer: XCSourceTextBuffer
	private(set) var lines: Lines!
	
	init(buffer textBuffer: XCSourceTextBuffer) {
		
		buffer = textBuffer
		lines = Lines(owner: self)
	}
}

extension SourceTextBuffer {
	
	final class Lines {
		
		fileprivate unowned let owner: SourceTextBuffer
		
		init(owner: SourceTextBuffer) {
			
			self.owner = owner
		}
	}
}

extension SourceTextBuffer {
	
	convenience init(invocation: XCSourceEditorCommandInvocation) {
		
		self.init(buffer: invocation.buffer)
	}
	
	var selections: Array<XCSourceTextRange> {
		
		return buffer.selections.map { $0 as! XCSourceTextRange }
	}
}

extension SourceTextBuffer.Lines : BidirectionalCollection {
	
	var startIndex: Int {
		
		return 0
	}
	
	var endIndex: Int {
		
		return owner.buffer.lines.count
	}
	
	subscript (offset: Int) -> String {
		
		get {
			
			return owner.buffer.lines[offset] as! String
		}
		
		set {
			
			if newValue.isEmpty {
				
				owner.buffer.lines.removeObject(at: offset)
			}
			else {
				
				owner.buffer.lines[offset] = newValue
			}
		}
	}
	
	func index(after i: Int) -> Int {
		
		return i + 1
	}
	
	func index(before i: Int) -> Int {
		
		return i - 1
	}
}

extension SourceTextBuffer.Lines {
	
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
