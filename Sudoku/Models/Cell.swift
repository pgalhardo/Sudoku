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
	private var _value: Int!
	private var _inputType: Int!
	private var _color: Color = Color.white
			
	init(value: Int) {
		_value = value
		
		if _value == 0 {
			_inputType = InputType.user
		} else {
			_inputType = InputType.system
		}
	}
	
	func getValue() -> Int {
		return _value
	}
	
	func getInputType() -> Int {
		return _inputType
	}
	
	func getColor() -> Color {
		return _color
	}
	
	func setValue(value: Int) {
		_value = value
	}
	
	func setInputType(inputType: Int) {
		_inputType = inputType
	}
	
	func setColor(color: Color) {
		_color = color
	}
			
	func toString() -> Text {
		if _value == 0 { return Text(" ") }
		
		if _inputType == InputType.system {
			return Text("\(_value)")
						.font(.custom("CaviarDreams-Bold",
									  size: Screen.cellWidth / 2))
						.foregroundColor(Colors.MatteBlack)
		} else if _inputType == InputType.user {
			
			return Text("\(_value)")
						.font(.custom("CaviarDreams-Bold",
									  size: Screen.cellWidth / 2))
						.foregroundColor(Colors.DeepBlue)
		}
		return Text("\(_value)")
					.font(.custom("CaviarDreams-Bold",
								  size: Screen.cellWidth / 2))
					.foregroundColor(Color.red)
	}
}
