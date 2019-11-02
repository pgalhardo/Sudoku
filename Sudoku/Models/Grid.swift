//
//  Grid.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

class Grid {
	private var _cells = [[Cell]]()
	private var _view: GridView!
	
	init() {
		for i in (0 ..< 9) {
			_cells.append([])
			for _ in (0 ..< 9) {
				_cells[i].append(Cell(number: 0, userInput: false))
			}
		}
		_view = GridView(grid: self)
	}
	
	func cellAt(row: Int, col: Int) -> Cell {
		return _cells[row][col]
	}
	
	func numberAt(row: Int, col: Int) -> Int {
		return _cells[row][col].getNumber()
	}
	
	func setNumber(row: Int, col: Int, number: Int) {
		let cell = cellAt(row: row, col: col)
		cell.setNumber(number: number)
	}
	
	func getRow(row: Int) -> [Cell] {
		return _cells[row]
	}
	
	/*
		Approach: in order to place a given number in a given cell of the grid,
		without breaking any of the Sudoku rules, we must first check its presence
		on the same row, column and square.
	*/
	@discardableResult func fill() -> Bool {
		var row = 0, col = 0
		var numbers: [Int] = [1,2,3,4,5,6,7,8,9]
		
		for i in (0 ..< 81) {
			row = i / 9
			col = i % 9
			
			if _cells[row][col].getNumber() == 0 {
				numbers = numbers.shuffled()
				
				for number in numbers {
					if !numberInRow(number: number, row: row)
						&& !numberInCol(number: number, col: col)
						&& !numberInSquare(number: number, row: row, col: col) {
					
						_cells[row][col].setNumber(number: number)
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
		
		_cells[row][col].setNumber(number: 0)
		return false
	}

	func numberInRow(number: Int, row: Int) -> Bool {
		for i in (0 ..< 9) {
			if _cells[row][i].getNumber() == number {
				return true
			}
		}
		return false
	}

	func numberInCol(number: Int, col: Int) -> Bool {
		for i in (0 ..< 9) {
			if _cells[i][col].getNumber() == number {
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

	func getSquare(row: Int, col: Int) -> [[Int]] {
		// aim to the upper left corner of the desired square
		let row: Int = (row / 3) * 3
		let col: Int = (col / 3) * 3
		var square: [[Int]] = []
		
		for i in (row ..< row + 3) {
			square.append([_cells[i][col].getNumber(),
						   _cells[i][col + 1].getNumber(),
						   _cells[i][col + 2].getNumber()])
		}
		return square
	}

	func isFull() -> Bool {
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if _cells[row][col].getNumber() == 0 {
					return false
				}
			}
		}
		return true
	}
}
