//
//  Cell.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 28/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

class Cell {
	var _value: Int!
	var _userInput: Bool = false
	var _color: Color = Color.white
		
	init() {
		_value = 0
	}
	
	init(value: Int) {
		_value = value
	}
	
	func getValue() -> Int {
		return _value
	}
	
	func getUserInput() -> Bool {
		return _userInput
	}
	
	func getColor() -> Color {
		return _color
	}
	
	func setValue(value: Int) {
		_value = value
	}
	
	func setColor(color: Color) {
		_color = color
	}
	
	func setUserInput(userInput: Bool) {
		_userInput = userInput
	}
		
	func toString() -> Text {
		if (_value != 0 && _userInput) {
			return Text("\(_value)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.foregroundColor(Colors.DeepBlue)
		} else if (_value != 0) {
			return Text("\(_value)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.foregroundColor(Colors.MatteBlack)
		}
		return Text(" ")
	}
}
