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
	private var _errorCount: Int = 0
	
	@Published private var _cells: [[Cell]] = [[Cell]]()
	@Published private var _numberFrequency: [Int] = Array(repeating: 0,
														   count: 9)
	@Published private var _filled: Double = 0
	
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
		Core functions
	==========================================================================*/
	
	func reset() {
		_active = nil
		_colored = [[Int]]()
		_cells = [[Cell]]()
		_numberFrequency = Array(repeating: 0, count: 9)
		_filled = 0
	}
	
	func load(puzzle: String) {
		var str = puzzle
		
		reset()
		for i in (0 ..< 9) {
			let row = str.prefix(9)
			_cells.append([])
			
			for j in row {
				// Substring -> String -> Int
				// consider throwing custom load exception
				guard let value = Int(String(j)) else { return }
				_cells[i].append(Cell(value: value))
				
				if (value > 0) {
					_numberFrequency[value - 1] += 1
					_filled += 1
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
	
	func getNumberFrequency() -> [Int] {
		return _numberFrequency
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
	
	func completion() -> Int {
		return Int(_filled / 81 * 100)
	}
	
	func getErrorCount() -> Int {
		return _errorCount
	}
			
	/*==========================================================================
		Single cell actions
	==========================================================================*/
	
	func cellAt(row: Int, col: Int) -> Cell {
		return _cells[row][col]
	}
	
	@discardableResult func setValue(row: Int, col: Int, value: Int) -> Bool {
		let cell = _cells[row][col]
		
		if cell.getInputType() == InputType.system {
			// consider throwing custom set exception
			return false
		}
		else if cell.getValue() != 0 {
			_numberFrequency[cell.getValue() - 1] -= 1
			_filled -= 1
		}
		
		if value > 0 {
			_numberFrequency[value - 1] += 1
			_filled += 1
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
			
			if areas {
				highlightRow(cell: _active)
				highlightCol(cell: _active)
			}
			if similar && _cells[row][col].getValue() != 0 {
				highlightSimilar(row: row, col: col)
			}
		}
	}
	
	func toggleColor(cell: [Int]?) {
		if cell == nil { return }

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
	
	func getCol(col: Int) -> [Cell] {
		return _cells.map { $0[col] }
	}

	func getSquare(row: Int, col: Int) -> [[Int]] {
		// this points to upper left corner
		let row = (row / 3) * 3, col = (col / 3) * 3
		var square = [[Int]]()
		
		for i in (row ..< row + 3) {
			square.append([_cells[i][col].getValue(),
						   _cells[i][col + 1].getValue(),
						   _cells[i][col + 2].getValue()])
		}
		return square
	}
		
	func numberInRow(number: Int, row: Int) -> Bool {
		return _cells[row].filter { $0.getValue() == number }.count > 0
	}
		
	func numberInCol(number: Int, col: Int) -> Bool {
		return _cells.filter { $0[col].getValue() == number }.count > 0
	}

	func numberInSquare(number: Int, row: Int, col: Int) -> Bool {
		let square = getSquare(row: row, col: col)
		
		return (square[0].contains(number)
			|| square[1].contains(number)
			|| square[2].contains(number))
	}
		
	func highlightRow(cell: [Int]?) {
		let row = cell![0], col = cell![1]
		
		for i in (0 ..< 9) {
			if i == col { continue }
			_cells[row][i].setColor(color: Colors.LightBlue)
			_colored.append([row, i])
		}
	}
	
	func highlightCol(cell: [Int]?) {
		let row = cell![0], col = cell![1]
		
		for i in (0 ..< 9) {
			if i == row { continue }
			_cells[i][col].setColor(color: Colors.LightBlue)
			_colored.append([i, col])
		}
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
	
	/*==========================================================================
		Generator
	==========================================================================*/
	
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
	
	/*==========================================================================
		Solver
	==========================================================================*/
	
	func solve() -> Bool {
		while !isFull() {
			objectWillChange.send()
			let possibles = updatePossibles()
			if checkSolved() > 0 { continue }
			if hiddenSingles(possibles: possibles) == 0 {
				print("Unsolvable with current techniques.")
				return false
			}
		}
		return true
	}
	
	func checkSolved() -> Int {
		var solved = 0
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				let possibles = _cells[row][col].getPossibles()
				if possibles.count == 1 {
					solved += 1
					setValue(row: row, col: col, value: possibles[0])
				}
			}
		}
		return solved
	}
		
	func updatePossibles() -> [[[Int]]] {
		func possibles_aux(row: Int, col: Int) -> [Int] {
			let cell = _cells[row][col]
			if cell.getValue() != 0 { return [] }
			
			var possibles = [Int]()
			for number in (1 ... 9) {
				if !numberInRow(number: number, row: row)
					&& !numberInCol(number: number, col: col)
					&& !numberInSquare(number: number, row: row, col: col) {
				
					possibles.append(number)
				}
			}
			cell.setPossibles(possibles: possibles)
			return possibles
		}
		
		var possibles = [[[Int]]]()
		for row in (0 ..< 9) {
			possibles.append([])
			for col in (0 ..< 9) {
				possibles[row].append([])
				possibles[row][col] = possibles_aux(row: row, col: col)
			}
		}
		return possibles
	}
	
	/*==========================================================================
		Basic solving tests : solve route
		---------------------------------
		#1 - Hidden Singles
	==========================================================================*/
	
	func hiddenSingles(possibles: [[[Int]]]) -> Int {
		let possibles = possibles
		var found = 0
		
		// detect hidden singles in rows
		for row in (0 ..< 9) {
			for value in (1 ... 9) {
				if uniqueRow(row: row,
						  value: value,
						  possibles: possibles[row]) {
					found += 1
				}
			}
		}
				
		// detect hidden singles in columns
		for col in (0 ..< 9) {
			for value in (1 ... 9) {
				if uniqueCol(col: col,
						  value: value,
						  possibles: possibles.map { $0[col] }) {
					found += 1
				}
			}
		}

		// detect hidden singles in boxes
		let delim = [0, 3, 6]
		for row in delim {
			for col in delim {
				for value in (1 ... 9) {
					if uniqueSquare(row: row,
								 col: col,
								 value: value,
								 possibles: possibles) {
						found += 1
					}
				}
			}
		}
		return found
	}
	
	func uniqueRow(row: Int, value: Int, possibles: [[Int]]) -> Bool {
		var count = 0, index = 0
		
		for col in (0 ..< 9) {
			for inner in (0 ..< possibles[col].count) {
				if possibles[col][inner] == value { count += 1; index = col }
			}
		}
		
		if count == 1 {
			setValue(row: row, col: index, value: value)
		}
		return count == 1
	}
	
	func uniqueCol(col: Int, value: Int, possibles: [[Int]]) -> Bool {
		var count = 0, index = 0
		
		for row in (0 ..< 9) {
			for inner in (0 ..< possibles[row].count) {
				if possibles[row][inner] == value { count += 1; index = row }
			}
		}
		
		if count == 1 {
			setValue(row: index, col: col, value: value)
		}
		return count == 1
	}
	
	func uniqueSquare(row: Int, col: Int, value: Int, possibles: [[[Int]]]) -> Bool {
		var square = [[Int]]()
		for i in (row ..< row + 3) {
			for j in (col ..< col + 3) {
				square.append(possibles[i][j])
			}
		}
		
		var count = 0, index = 0
		for outter in (0 ..< 9) {
			for inner in (0 ..< square[outter].count) {
				if square[outter][inner] == value { count += 1; index = outter }
			}
		}
		
		if count == 1 {
			let rowOffset = index / 3; let colOffset = index % 3
			setValue(row: row + rowOffset, col: col + colOffset, value: value)
		}
		return count == 1
	}
	
	/*==========================================================================
		#2 - Naked Pairs / Triples
	==========================================================================*/
	
}
