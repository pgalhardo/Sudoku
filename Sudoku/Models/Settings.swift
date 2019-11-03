//
//  Settings.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 03/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation

class Settings: ObservableObject {
	@Published var _highlightAreas: Bool! {
		didSet {
			UserDefaults.standard.set(_highlightAreas,
									  forKey: "highlightAreas")
		}
	}
	@Published var _highlightSimilar: Bool! {
		didSet {
			UserDefaults.standard.set(_highlightSimilar,
									  forKey: "highlightSimilar")
		}
	}
	@Published var _hideUsed: Bool! {
		didSet {
			UserDefaults.standard.set(_hideUsed,
									  forKey: "highlightUsed")
		}
	}
	@Published var _enableTimer: Bool! {
		didSet {
			UserDefaults.standard.set(_enableTimer,
									  forKey: "enableTimer")
		}
	}

	init() {
		_highlightAreas = UserDefaults.standard.bool(forKey: "highlightAreas")
		_highlightSimilar = UserDefaults.standard.bool(forKey: "highlightSimilar")
		_hideUsed = UserDefaults.standard.bool(forKey: "highlightUsed")
		_enableTimer = UserDefaults.standard.bool(forKey: "enableTimer")
	}
}
