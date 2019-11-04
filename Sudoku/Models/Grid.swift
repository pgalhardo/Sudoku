//
//  Grid.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

class Grid: ObservableObject {
	private var _active: [Int]?
	private var _previous: [Int]?
	
	@Published private var _numberFrequency: [Int] = Array(repeating: 0, count: 9)
	@Published private var _cells: [[Cell]] = [[Cell]]()
	
	init() {
		for i in (0 ..< 9) {
			_cells.append([])
			for _ in (0 ..< 9) {
				_cells[i].append(Cell(value: 0))
			}
		}
		self.fill()
	}
	
	init(puzzle: String) {
		self.load(puzzle: puzzle)
	}
	
	/*==========================================================================
		Grid's core functions
	==========================================================================*/
	
	func reset() {
		for i in (0 ..< 9) {
			for j in (0 ..< 9) {
				_cells[i][j].setValue(value: 0)
				_cells[i][j].setUserInput(userInput: false)
			}
		}
	}
	
	func isFull() -> Bool {
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if _cells[row][col].getValue() == 0 {
					return false
				}
			}
		}
		return true
	}
	
	func load(puzzle: String) {
		var str = puzzle
		
		for i in (0 ..< 9) {
			let row = str.prefix(9)
			_cells.append([])
			
			for j in row {
				// Substring -> String -> Int
				//TODO throw custom load exception
				guard let value = Int(String(j)) else { return }
				_cells[i].append(Cell(value: value))
				
				if (value > 0) {
					_numberFrequency[value - 1] += 1
				}
			}
			str = String(str.dropFirst(9))
		}
	}
	
	func store() -> String {
		var str = ""
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				str.append(String(_cells[row][col].getValue()))
			}
		}
		return str
	}
	
	func toString() {
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				print(_cells[row][col].getValue())
			}
		}
	}
	
	/*
		Approach: in order to place a given number in a given cell of the grid
		without breaking any of the Sudoku rules, we must first check
		for its presence on the same row, column and square.
	*/
	@discardableResult func fill() -> Bool {
		var row = 0, col = 0
		var numbers: [Int] = [1,2,3,4,5,6,7,8,9]
		
		for i in (0 ..< 81) {
			row = i / 9
			col = i % 9
			
			if _cells[row][col].getValue() == 0 {
				numbers = numbers.shuffled()
				
				for number in numbers {
					if !numberInRow(number: number, row: row)
						&& !numberInCol(number: number, col: col)
						&& !numberInSquare(number: number, row: row, col: col) {
					
						_cells[row][col].setValue(value: number)
						_numberFrequency[number] += 1
						if isFull() {
							return true
						}
						else {
							if fill() {
								return true
							}
						}
					}
				}
				break
			}
		}
		
		_cells[row][col].setValue(value: 0)
		return false
	}
	
	func completion() -> Int {
		var filledCells: Double = 0
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if _cells[row][col].getValue() != 0 {
					filledCells += 1
				}
			}
		}
		return Int(filledCells / 81 * 100)
	}
	
	func getNumberFrequency() -> [Int] {
		return _numberFrequency
	}
	
	/*==========================================================================
		Single cell actions
	==========================================================================*/
	
	func cellAt(row: Int, col: Int) -> Cell {
		return _cells[row][col]
	}
	
	//TODO throw custom set exception; base this on active
	func setValue(row: Int, col: Int, value: Int) -> Bool {
		let cell = _cells[row][col]
		
		if cell.getValue() != 0 && cell.getUserInput() == false {
			return false
		}
		else if cell.getValue() != 0 {
			_numberFrequency[cell.getValue() - 1] -= 1
		}
		
		if value > 0 {
			_numberFrequency[value - 1] += 1
		}
		cell.setValue(value: value)
		return true
	}
	
	func getActive() -> [Int]? {
		return _active
	}
	
	func getPrevious() -> [Int]? {
		return _previous
	}
	
	func setActive(row: Int, col: Int) {
		_previous = _active
		_active = [row, col]
	}
	
	func resetActive() {
		_previous = nil
		_active = nil
	}
		
	/*==========================================================================
		Groups of cells
	==========================================================================*/
	
	func getRow(row: Int) -> [Cell] {
		return _cells[row]
	}

	func getSquare(row: Int, col: Int) -> [[Int]] {
		// aim to the upper left corner of the desired square
		let row: Int = (row / 3) * 3, col: Int = (col / 3) * 3
		var square: [[Int]] = []
		
		for i in (row ..< row + 3) {
			square.append([_cells[i][col].getValue(),
						   _cells[i][col + 1].getValue(),
						   _cells[i][col + 2].getValue()])
		}
		return square
	}
	
	func numberInRow(number: Int, row: Int) -> Bool {
		for i in (0 ..< 9) {
			if _cells[row][i].getValue() == number {
				return true
			}
		}
		return false
	}

	func numberInCol(number: Int, col: Int) -> Bool {
		for i in (0 ..< 9) {
			if _cells[i][col].getValue() == number {
				return true
			}
		}
		return false
	}

	func numberInSquare(number: Int, row: Int, col: Int) -> Bool {
		let square:[[Int]] = getSquare(row: row, col: col)
		
		return (square[0].contains(number)
			|| square[1].contains(number)
			|| square[2].contains(number))
	}
}
