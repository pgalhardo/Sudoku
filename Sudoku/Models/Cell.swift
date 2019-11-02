//
//  Cell.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 28/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI
import Combine

class Cell {
	var _number: Int!
	var _userInput:Bool!

	init(number: Int, userInput: Bool) {
		self._number = number
		_userInput = userInput
	}
		
	func getNumber() -> Int {
		return _number
	}
	
	func setNumber(number: Int) {
		_number = number
	}
	
	func setUserInput(userInput: Bool) {
		_userInput = userInput
	}
		
	func toString() -> Text {
		if (_number != 0 && _userInput) {
			return Text("\(_number)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.foregroundColor(Colors.DeepBlue)
		} else if (_number != 0) {
			return Text("\(_number)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.foregroundColor(Colors.MatteBlack)
		}
		return Text(" ")
	}
}
