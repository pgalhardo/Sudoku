//
//  Settings.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 03/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation

final class Settings: ObservableObject {
	@Published var highlightAreas: Bool! {
		didSet {
			UserDefaults.standard.set(highlightAreas,
									  forKey: "highlightAreas")
		}
	}
	@Published var highlightSimilar: Bool! {
		didSet {
			UserDefaults.standard.set(highlightSimilar,
									  forKey: "highlightSimilar")
		}
	}
	@Published var hideUsed: Bool! {
		didSet {
			UserDefaults.standard.set(hideUsed,
									  forKey: "highlightUsed")
		}
	}
	@Published var enableTimer: Bool! {
		didSet {
			UserDefaults.standard.set(enableTimer,
									  forKey: "enableTimer")
		}
	}
	@Published var fontSize: Float! {
		didSet {
			UserDefaults.standard.set(fontSize,
									  forKey: "fontSize")
		}
	}
	
	init() {
		highlightAreas = UserDefaults.standard.bool(forKey: "highlightAreas")
		highlightSimilar = UserDefaults.standard.bool(forKey: "highlightSimilar")
		hideUsed = UserDefaults.standard.bool(forKey: "highlightUsed")
		enableTimer = UserDefaults.standard.bool(forKey: "enableTimer")
		fontSize = UserDefaults.standard.float(forKey: "fontSize")
	}
}
