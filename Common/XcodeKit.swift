//
//  XcodeKit.swift
//  ESXcodeSourceEditorExtensionUUID
//
//  Created by Tomohiro Kumagai on 11/13/16.
//
//

import XcodeKit

extension XCSourceTextPosition {
	
	// The number of line at end.
	var endLine: Int {
		
		switch column {
			
		case 0:
			return line
			
		default:
			return line + 1
		}
	}
}
