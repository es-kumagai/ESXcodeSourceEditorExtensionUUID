//
//  SourceEditorCommand.swift
//  GenerateUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
	
	func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void ) -> Void {
		
		let sourceBuffer = SourceTextBuffer(invocation: invocation)
		let uuidString = UUID().description(style: .expressionStyle(for: sourceBuffer.contentUTI))

		for selection in sourceBuffer.selections {
			
			sourceBuffer.lines[range: selection] = uuidString
		}
		
		completionHandler(nil)
	}
}
