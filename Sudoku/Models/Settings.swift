//
//  Settings.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 03/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation

class Settings: ObservableObject {
	@Published var _highlightAreas: Bool = true
	@Published var _highlightSimilar: Bool = false
	@Published var _hideUsed: Bool = false
	@Published var _timer: Bool = true
	
	func setHighlightAreas(value: Bool) {
		_highlightAreas = value
	}
	
	func setHighlightSimilar(value: Bool) {
		_highlightSimilar = value
	}
	
	func setTimer(value: Bool) {
		_timer = value
	}
}
