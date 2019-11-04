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
	var _userInput: Bool!
	var _cellColor: Color = Color.white
	var _labelColor: Color!
			
	init(value: Int) {
		_value = value
		
		if _value == 0 {
			_userInput = true
			_labelColor = Colors.DeepBlue
		} else {
			_userInput = false
			_labelColor = Colors.MatteBlack
		}
	}
	
	func getValue() -> Int {
		return _value
	}
	
	func getUserInput() -> Bool {
		return _userInput
	}
	
	func getColor() -> Color {
		return _cellColor
	}
	
	func setValue(value: Int) {
		_value = value
	}
	
	func setCellColor(cellColor: Color) {
		_cellColor = cellColor
	}
	
	func setUserInput(userInput: Bool) {
		_userInput = userInput
	}
		
	func toString() -> Text {
		if (_value != 0) {
			return Text("\(_value)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.foregroundColor(_labelColor)
		}
		return Text(" ")
	}
}
