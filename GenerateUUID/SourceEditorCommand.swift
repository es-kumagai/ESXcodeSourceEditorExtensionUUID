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
		
		let uuid = UUID()		
		let sourceBuffer = SourceTextBuffer(invocation: invocation)

		for selection in sourceBuffer.selections {

			sourceBuffer.lines[range: selection] = uuid.description
		}
		
		completionHandler(nil)
	}
	
}
