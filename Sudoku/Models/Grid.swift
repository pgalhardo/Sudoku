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
	private var active: [Int]?
	private var colored: [[Int]] = [[Int]]()
	private var errorCount: Int = 0
	
	@Published private var grid: [[Int]] = [[Int]]()
	@Published private var color: [[Color]] = [[Color]]()
	@Published private var inputType: [[Int]] = [[Int]]()
	@Published private var numberFrequency: [Int] = [Int]()
	init() {
		self.grid = Array(
			repeating:Array(repeating: UNDEFINED, count: 9),
			count: 9
		)
		self.color = Array(
			repeating: Array(repeating: Color.white, count: 9),
			count: 9
		)
		self.inputType = Array(
			repeating: Array(repeating: InputType.user, count: 9),
			count: 9
		)
		self.numberFrequency = Array(repeating: 0, count: 9)
	}
	
	init(puzzle: String) {
		self.load(puzzle: puzzle)
	}
	
	/*==========================================================================
		Core functions
	==========================================================================*/
	
	func reset() {
		self.active = nil
		self.colored = [[Int]]()
		self.numberFrequency = Array(repeating: 0, count: 9)
		
		self.grid = Array(
			repeating: Array(repeating: UNDEFINED, count: 9),
			count: 9
		)
		self.color = Array(
			repeating: Array(repeating: Color.white, count: 9),
			count: 9
		)
		self.inputType = Array(
			repeating: Array(repeating: InputType.user, count: 9),
			count: 9
		)
	}
		
	func load(puzzle: String) {
		var str = puzzle, user = false, count = 0
		
		reset()
		
		while str != "" {
			let row = count / 9
			let col = count % 9
			let char = str[0]
			str.remove(at: str.startIndex)
			
			if "0" <= char && char <= "9" {
				guard let value = Int(char)
				else { self.reset(); return }
				
				self.grid[row][col] = value

				user == true
					? (self.inputType[row][col] = InputType.user)
					: (self.inputType[row][col] = InputType.system)
								
				user = false
				count += 1
				if (value > 0) {
					numberFrequency[value - 1] += 1
				}
			}
			else if char == "u" {
				user = true
			}
		}
	}
		
	func store() -> String {
		var str = ""
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if (self.inputType[row][col] == InputType.user) {
					str.append("u")
				}
				str.append(String(grid[row][col]))
			}
		}
		return str
	}
	
	func getNumberFrequency() -> [Int] {
		return self.numberFrequency
	}
	
	func isFull() -> Bool {
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if self.grid[row][col] == UNDEFINED {
					return false
				}
			}
		}
		return true
	}
	
	func completion() -> Int {
		var filled = 0
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if grid[row][col] != UNDEFINED {
					filled += 1
				}
			}
		}
		return filled * 100 / 81
	}
	
	func getErrorCount() -> Int {
		return self.errorCount
	}
			
	/*==========================================================================
		Single cell actions
	==========================================================================*/
	
	func valueAt(row: Int, col: Int) -> Int {
		return grid[row][col]
	}
	
	func colorAt(row: Int, col: Int) -> Color {
		return color[row][col]
	}
	
	@discardableResult func setValue(row: Int, col: Int, value: Int) -> Bool {
				
		if inputType[row][col] == InputType.system {
			return false
		} else if grid[row][col] == value {
			return true
		} else if !possible(number: value, row: row, col: col) {
			inputType[row][col] = InputType.error
		} else {
			inputType[row][col] = InputType.user
			
			if grid[row][col] > 0 {
				numberFrequency[grid[row][col] - 1] -= 1
			}
			
			if value > 0 {
				numberFrequency[value - 1] += 1
			}
		}
				
		grid[row][col] = value
		return true
	}
	
	func getActive() -> [Int]? {
		return active
	}
		
	func setActive(row: Int, col: Int, areas: Bool, similar: Bool) {
		let previous = active
		active = [row, col]
		
		for i in (0 ..< colored.count) {
			toggleColor(cell: colored[i])
		}
		colored.removeAll()
		
		if previous == active {
			active = nil
		}
		else {
			toggleColor(cell: active)
			
			if areas {
				highlightRow(cell: active)
				highlightCol(cell: active)
			}
			if similar && grid[row][col] != UNDEFINED {
				highlightSimilar(row: row, col: col)
			}
		}
	}
	
	func toggleColor(cell: [Int]?) {
		if cell == nil { return }

		let row = cell![0], col = cell![1]
		if color[row][col] == Color.white {
			color[row][col] = Colors.ActiveBlue
			colored.append([row, col])
		}
		else {
			color[row][col] = Color.white
		}
	}
					
	/*==========================================================================
		Groups of cells
	==========================================================================*/
	
	func getSquare(row: Int, col: Int) -> [[Int]] {
		// this points to upper left corner
		let row = (row / 3) * 3, col = (col / 3) * 3
		var square = [[Int]]()
		
		for i in (row ..< row + 3) {
			square.append([grid[i][col],
						   grid[i][col + 1],
						   grid[i][col + 2]])
		}
		return square
	}
		
	func numberInRow(number: Int, row: Int) -> Bool {
		return grid[row].filter { $0 == number }.count > 0
	}
		
	func numberInCol(number: Int, col: Int) -> Bool {
		return grid.filter { $0[col] == number }.count > 0
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
			color[row][i] = Colors.LightBlue
			colored.append([row, i])
		}
	}
	
	func highlightCol(cell: [Int]?) {
		let row = cell![0], col = cell![1]
		
		for i in (0 ..< 9) {
			if i == row { continue }
			color[i][col] = Colors.LightBlue
			colored.append([i, col])
		}
	}
	
	func highlightSimilar(row: Int, col: Int) {
		let value = grid[row][col]
		var found = 0
		
		for i in (0 ..< 9) {
			if i == row { continue }
			
			for j in (0 ..< 9) {
				if j == col { continue }
				
				if grid[i][j] == value {
					color[i][j] = Colors.LightBlue
					colored.append([i, j])
					found += 1
				}
				
				if found == numberFrequency[value - 1] { return }
			}
		}
	}
	
	func possible(number: Int, row: Int, col: Int) -> Bool {
		return !numberInRow(number: number, row: row)
			&& !numberInCol(number: number, col: col)
			&& !numberInSquare(number: number, row: row, col: col)
	}
	
	func render(row: Int, col:Int, fontSize: Int) -> Text {
		
		let value = grid[row][col]
		let type = inputType[row][col]
		
		if value == UNDEFINED { return Text(" ") }
		
		if type == InputType.system {
			return Text("\(value)")
						.font(.custom("CaviarDreams-Bold",
									  size: CGFloat(fontSize)))
						.foregroundColor(Colors.MatteBlack)
		} else if type == InputType.user {
			return Text("\(value)")
						.font(.custom("CaviarDreams-Bold",
									  size: CGFloat(fontSize)))
						.foregroundColor(Colors.DeepBlue)
		}
		return Text("\(value)")
					.font(.custom("CaviarDreams-Bold",
								  size: CGFloat(fontSize)))
					.foregroundColor(Color.red)
	}
	
	/*==========================================================================
		Generator
	==========================================================================*/
	
	/*
		Approach: in order to place a given number in a given cell of the grid
		without breaking any of the Sudoku rules, we must first check
		for its presence on the same row, column and square.
	*/
	func generate() {
		fill()
		removeNumbers()
		computeTokenFrequency()
	}
	
	@discardableResult func fill() -> Bool {
		var row = 0, col = 0
		var numbers: [Int] = [1, 2, 3, 4, 5, 6, 7, 8, 9]
		
		for i in (0 ..< 81) {
			row = i / 9
			col = i % 9
			
			if grid[row][col] == UNDEFINED {
				numbers = numbers.shuffled()
				
				for number in numbers {
					if possible(number: number, row: row, col: col) {
					
						grid[row][col] = number
						inputType[row][col] = InputType.system
						
						if isFull() {
							return true
						}
						else if fill() {
								return true
						}
					}
				}
				break
			}
		}
		grid[row][col] = UNDEFINED
		return false
	}
	
	func removeNumbers() {
		var pos = Array(0 ..< 81)
		pos = pos.shuffled()
		
		while pos.count > 0 {
			let nextpos = pos.removeFirst()
			let row = nextpos / 9
			let col = nextpos % 9
			
			let prev = self.grid
			
			grid[row][col] = UNDEFINED
			let solvable = solve()
			
			grid = prev
						
			if (!solvable) { continue }
			
			inputType[row][col] = InputType.user
			grid[row][col] = UNDEFINED
		}
	}
	
	func computeTokenFrequency() {
		for row in grid {
			for val in row {
				if val != UNDEFINED {
					numberFrequency[val - 1] += 1
				}
			}
		}
	}
		
	/*==========================================================================
		Solver
	==========================================================================*/
	
	func solve() -> Bool {
		while !isFull() {
			objectWillChange.send()
			let possibles = getPossibles()
			
			if      nakedSingles(possibles: possibles)  > 0 { continue }
			//else if hiddenSingles(possibles: possibles) > 0 { continue }
			
			// Unsolvable with current techniques.
			return false
		}
		return true
	}
	
	func getPossibles() -> [[[Int]]] {
		func possibles_aux(row: Int, col: Int) -> [Int] {
			if grid[row][col] != UNDEFINED { return [] }
			
			var possibles = [Int]()
			for number in (1 ... 9) {
				if !numberInRow(number: number, row: row)
					&& !numberInCol(number: number, col: col)
					&& !numberInSquare(number: number, row: row, col: col) {
				
					possibles.append(number)
				}
			}
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
		#1 - Naked Singles
	==========================================================================*/
	
	func nakedSingles(possibles: [[[Int]]]) -> Int {
		var solved = 0
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if possibles[row][col].count == 1 {
					solved += 1
					grid[row][col] = possibles[row][col][0]
				}
			}
		}
		return solved
	}
	
	/*==========================================================================
		#2 - Hidden Singles
	==========================================================================*/
	
	func hiddenSingles(possibles: [[[Int]]]) -> Int {
		let possibles = possibles
		var found = 0
		
		// detect hidden singles in rows
		for row in (0 ..< 9) {
			for value in (1 ... 9) {
				if uniqueRow(row: row,
							 value: value,
							 possibles: possibles[row]
					) {
					found += 1
				}
			}
		}
				
		// detect hidden singles in columns
		for col in (0 ..< 9) {
			for value in (1 ... 9) {
				if uniqueCol(col: col,
							 value: value,
							 possibles: possibles.map { $0[col] }
					) {
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
									possibles: possibles
						) {
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

/*
	Extension to allow usage of: str[i]
*/
extension String {
	subscript (i: Int) -> String {
		return self[i ..< i + 1]
	}

	subscript (r: Range<Int>) -> String {
		let range = Range(uncheckedBounds: (lower: max(0, min(count, r.lowerBound)),
											upper: min(count, max(0, r.upperBound))))
		let start = index(startIndex, offsetBy: range.lowerBound)
		let end = index(start, offsetBy: range.upperBound - range.lowerBound)
		return String(self[start ..< end])
	}
}
