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
	private var _colored: [[Int]] = [[Int]]()
	
	@Published private var _cells: [[Cell]] = [[Cell]]()
	@Published private var _numberFrequency: [Int] = Array(repeating: 0,
														   count: 9)
	
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
				// TODO throw custom load exception
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
						_numberFrequency[number - 1] += 1
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
	
	func highlightSimilar(row: Int, col: Int) {
		let value = _cells[row][col].getValue()
		var found = 0
		
		for i in (0 ..< 9) {
			if i == row { continue }
			
			for j in (0 ..< 9) {
				if j == col { continue }
				
				if _cells[i][j].getValue() == value {
					_cells[i][j].setColor(color: Colors.LightBlue)
					_colored.append([i, j])
					found += 1
				}
				
				if found == _numberFrequency[value - 1] { return }
			}
		}
	}
	
	func possibilities() -> [[[Int]]] {
		var possibilities = [[[Int]]]()
		
		for i in (0 ..< 9) {
			possibilities.append([])
			
			for j in (0 ..< 9) {
				possibilities[i].append([])
				let value = _cells[i][j].getValue()

				if value != 0 {
					possibilities[i][j] = [value]
				} else {
					possibilities[i][j] = cellPossibilities(row: i, col: j)
				}
			}
		}
		return possibilities
	}
			
	func cellPossibilities(row: Int, col: Int) -> [Int] {
		var numbers = [Int]()
		
		for number in (1 ..< 10) {
			if !numberInRow(number: number, row: row)
				&& !numberInCol(number: number, col: col)
				&& !numberInSquare(number: number, row: row, col: col) {
			
				numbers.append(number)
			}
		}
		return numbers
	}
	
	func unique(value: Int, list: [[Int]]) -> Int {
		var count = 0, index = 0
		
		for i in (0 ..< 9) {
			for j in (0 ..< list[i].count) {
				if list[i][j] == value { count += 1; index = i }
				if count > 1 { return 0 }
			}
		}
		return count == 1 ? index : 0
	}
	
	func hiddenSingles() {
		let poss = possibilities()
		var singles = [[Int]]()
				
		print("detecting hidden singles in rows")
		for i in (0 ..< 9) {
			for j in (0 ..< 9) {
				let index = unique(value: j, list:  poss[i])
				if index != 0 && _cells[i][index].getValue() == 0 {
					print(j, " @ ", i, ":", index)
					singles.append([i, index])
				}
			}
		}
				
		print("detecting hidden singles in columns")
		// TODO
		
		print("detecting hidden singles in boxes")
		// TODO
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
		
		if cell.getInputType() == InputType.system {
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
		
	func setActive(row: Int, col: Int, areas: Bool, similar: Bool) {
		let previous = _active
		_active = [row, col]
		
		for i in (0 ..< _colored.count) {
			toggleColor(cell: _colored[i])
		}
		_colored.removeAll()
		
		if previous == _active {
			_active = nil
		}
		else {
			toggleColor(cell: _active)
			toggleLineColor(cell: _active, rowMode: true)
			toggleLineColor(cell: _active, rowMode: false)
			if _cells[row][col].getValue() != 0 && similar {
				highlightSimilar(row: row, col: col)
			}
		}
	}
	
	func toggleColor(cell: [Int]?) {
		if (cell == nil) { return }
		let row = cell![0], col = cell![1]
		
		if _cells[row][col].getColor() == Color.white {
			_cells[row][col].setColor(color: Colors.ActiveBlue)
			_colored.append([row, col])
		}
		else {
			_cells[row][col].setColor(color: Color.white)
		}
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
	
	func toggleLineColor(cell: [Int]?, rowMode: Bool) {
		let row = cell![0], col = cell![1]
		
		for i in (0 ..< 9) {
			if (rowMode == false && i == row)
			|| (rowMode == true && i == col) {
				continue
			}
			else if rowMode == true {
				_cells[row][i].setColor(color: Colors.LightBlue)
				_colored.append([row, i])
			} else {
				_cells[i][col].setColor(color: Colors.LightBlue)
				_colored.append([i, col])
			}
		}
	}
}
