//
//  Grid.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

final class Grid: ObservableObject {
	private var active: [Int]?
	private var colored: [[Int]] = [[Int]]()
	private var solutions: Int = 0
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
	
	/*==========================================================================
		Core functions
	==========================================================================*/
	
	func reset() -> Void {
		self.active = nil
		//self.errorCount = 0
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
	
	func load(puzzle: String) -> Void {
		var str: String = puzzle
		var count: Int = 0
		var user: Bool = false
		var error: Bool = false
		
		while !str.isEmpty {
			let row: Int = count / 9
			let col: Int = count % 9
			let char: Character = str.removeFirst()
			
			if "0" <= char && char <= "9" {
				let char2String: String = String(char)
				let value: Int = Int(char2String) ?? 0
				
				self.grid[row][col] = value
				
				if user == true {
					self.inputType[row][col] = InputType.user
				} else if error == true {
					self.inputType[row][col] = InputType.error
				} else {
					self.inputType[row][col] = InputType.system
				}
				
				user = false
				error = false
				count += 1
				if (value > 0) {
					numberFrequency[value - 1] += 1
				}
			}
				
			else if char == "u" {
				user = true
			} else if char == "e" {
				error = true
			}
		}
	}
	
	func loadFromSeed() -> Void {
		let randPuzzle: Int = Int.random(in: 0 ..< Puzzles.easy.count)
		
		var str: String = Puzzles.easy[randPuzzle]
		var count: Int = 0
		
		while !str.isEmpty {
			let row: Int = count / 9
			let col: Int = count % 9
			let char: Character = str.removeFirst()
			
			if "0" <= char && char <= "9" {
				let char2String: String = String(char)
				let value: Int = Int(char2String) ?? 0
				
				self.grid[row][col] = value
				if value != UNDEFINED {
					self.inputType[row][col] = InputType.system
				} else {
					self.inputType[row][col] = InputType.user
				}
				
				count += 1
			}
		}
	}
	
	func toString() -> String {
		var str = String()
		
		for row: Int in (0 ..< 9) {
			for col: Int in (0 ..< 9) {
				if (self.inputType[row][col] == InputType.user) {
					str.append("u")
				}
					
				else if (self.inputType[row][col] == InputType.error) {
					str.append("e")
				}
				str.append(String(grid[row][col]))
			}
		}
		return str
	}
	
	func getNumberFrequency() -> [Int] {
		return self.numberFrequency
	}
	
	func full() -> Bool {
		for row: Int in (0 ..< 9) {
			for col: Int in (0 ..< 9) {
				if self.grid[row][col] == UNDEFINED {
					return false
				}
			}
		}
		return true
	}
	
	func completion() -> Int {
		var filled: Int = 0
		
		for row: Int in (0 ..< 9) {
			for col: Int in (0 ..< 9) {
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
		}
			
		else if grid[row][col] == value {
			return true
		}
			
		else if value != UNDEFINED
			&& !possible(number: value, row: row, col: col) {
			
			inputType[row][col] = InputType.error
			errorCount += 1
		}
			
		else {
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
	
	func setActive(row: Int, col: Int, areas: Bool, similar: Bool) -> Void {
		let previous: [Int]? = active
		active = [row, col]
		
		for i: Int in (0 ..< colored.count) {
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
	
	func toggleColor(cell: [Int]?) -> Void {
		if cell == nil { return }
		
		let row: Int = cell![0]
		let col: Int = cell![1]
		
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
		let row: Int = (row / 3) * 3
		let col: Int = (col / 3) * 3
		var square: [[Int]] = [[Int]]()
		
		for i: Int in (row ..< row + 3) {
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
		let square: [[Int]] = getSquare(row: row, col: col)
		
		return (square[0].contains(number)
			|| square[1].contains(number)
			|| square[2].contains(number))
	}
	
	func highlightRow(cell: [Int]?) -> Void {
		let row: Int = cell![0]
		let col: Int = cell![1]
		
		for i: Int in (0 ..< 9) {
			if i == col { continue }
			color[row][i] = Colors.LightBlue
			colored.append([row, i])
		}
	}
	
	func highlightCol(cell: [Int]?) -> Void {
		let row: Int = cell![0]
		let col: Int = cell![1]
		
		for i: Int in (0 ..< 9) {
			if i == row { continue }
			color[i][col] = Colors.LightBlue
			colored.append([i, col])
		}
	}
	
	func highlightSimilar(row: Int, col: Int) -> Void {
		let value: Int = grid[row][col]
		var found: Int = 0
		
		for i: Int in (0 ..< 9) {
			if i == row { continue }
			
			for j: Int in (0 ..< 9) {
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
	
	func render(row: Int, col: Int, fontSize: CGFloat) -> Text {
		
		let value: Int = grid[row][col]
		let type: Int = inputType[row][col]
		
		if value == UNDEFINED { return Text(" ") }
		
		if type == InputType.system {
			return Text("\(value)")
				.font(.custom("CaviarDreams-Bold",
							  size: fontSize))
				.foregroundColor(Colors.MatteBlack)
		} else if type == InputType.user {
			return Text("\(value)")
				.font(.custom("CaviarDreams-Bold",
							  size: fontSize))
				.foregroundColor(Colors.DeepBlue)
		}
		return Text("\(value)")
			.font(.custom("CaviarDreams-Bold",
						  size: fontSize))
			.foregroundColor(Color.red)
	}
	
	/*==========================================================================
		Generator
	==========================================================================*/

	func generate() -> Void {
		loadFromSeed()
		//randomize()
		self.errorCount = 0
		
		computeTokenFrequency()
	}
	
	func computeTokenFrequency() -> Void {
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
	
	func solve() -> Int {
		solutions = 0
		
		basicTechniques()
		if full() {
			solutions = 1
		}
		else {
			backtrack(prev: -1, pos: nextEmptyPos(ref: -1))
		}
		
		return solutions
	}
	
	
	func basicTechniques() -> Void {
		func nakedSingles(possibles: [[[Int]]]) -> Int {
			var solved: Int = 0
			
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
		
		func hiddenSingles(possibles: [[[Int]]]) -> Int {
			
			func uniqueRow(row: Int, value: Int, possibles: [[Int]]) -> Bool {
				var count: Int = 0
				var index: Int = 0
				
				for col in (0 ..< 9) {
					for inner in (0 ..< possibles[col].count) {
						if possibles[col][inner] == value {
							count += 1
							index = col
						}
					}
				}
				
				if count == 1 {
					grid[row][index] = value
				}
				return count == 1
			}
			
			func uniqueCol(col: Int, value: Int, possibles: [[Int]]) -> Bool {
				var count: Int = 0
				var index: Int = 0
				
				for row in (0 ..< 9) {
					for inner in (0 ..< possibles[row].count) {
						if possibles[row][inner] == value {
							count += 1
							index = row
						}
					}
				}
				
				if count == 1 {
					grid[index][col] = value
				}
				return count == 1
			}
			
			func uniqueSquare(row: Int, col: Int, value: Int,
							  possibles: [[[Int]]]) -> Bool {
				
				var square: [[Int]] = [[Int]]()
				for i in (row ..< row + 3) {
					for j in (col ..< col + 3) {
						square.append(possibles[i][j])
					}
				}
				
				var count: Int = 0
				var index: Int = 0
				for outter in (0 ..< 9) {
					for inner in (0 ..< square[outter].count) {
						if square[outter][inner] == value {
							count += 1
							index = outter
						}
					}
				}
				
				if count == 1 {
					let rowOffset: Int = index / 3
					let colOffset: Int = index % 3
					grid[row + rowOffset][col + colOffset] = value
				}
				return count == 1
			}
			
			var found: Int = 0
			
			// detect hidden singles in rows
			for row: Int in (0 ..< 9) {
				for value: Int in (1 ... 9) {
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
			let delim: [Int] = [0, 3, 6]
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
		
		while true {
			let possibles: [[[Int]]] = computeGridPossibles()
			
			if nakedSingles(possibles: possibles) > 0 { continue }
			else if hiddenSingles(possibles: possibles) > 0 { continue }
			
			break
		}
	}
	
	
	@discardableResult func backtrack(prev: Int, pos: Int) -> Bool {
		let row: Int = pos / 9
		let col: Int = pos % 9
		
		var possibles: [Int] = getPossibles(row: row, col: col)
		
		while possibles.count > 0 {
			let first: Int = possibles.removeFirst()
			grid[row][col] = first
			
			let nextpos: Int = nextEmptyPos(ref: pos)
			if nextpos == -1 {
				
				// Solution found. We must check if it is the only one (so far).
				solutions += 1
				if solutions > 1 {
					return false
				}
			}
			else {
				backtrack(prev: pos, pos: nextpos)
				if solutions > 1 {
					return false
				}
			}
			
			// If we got here, everything after us failed.
			// We need to try another possible number.
		}
		
		grid[row][col] = UNDEFINED
		return false
	}
	
	
	func nextEmptyPos(ref: Int) -> Int {
		var nextpos: Int = ref + 1
		
		while true {
			let nextrow: Int = nextpos / 9
			let nextcol: Int = nextpos % 9
			if nextpos > 80 {
				// Board is filled
				return -1
			}
			else if grid[nextrow][nextcol] == UNDEFINED {
				return nextpos
			}
			nextpos += 1
		}
	}
	
	
	func getPossibles(row: Int, col: Int) -> [Int] {
		var possibles: [Int] = []
		
		for i in (1 ... 9) {
			if possible(token: i, row: row, col: col) {
				possibles.append(i)
			}
		}
		return possibles
	}
	
	
	func computeGridPossibles() -> [[[Int]]] {
		var possibles: [[[Int]]] = Array(repeating: Array(repeating: [],
														  count: 9),
										 count: 9)
		
		for row in (0 ..< 9) {
			for col in (0 ..< 9) {
				if grid[row][col] == UNDEFINED {
					possibles[row][col] = getPossibles(row: row, col: col)
				}
			}
		}
		return possibles
	}
	
	func possible(token: Int, row: Int, col: Int) -> Bool {
		return !tokenInRow(token: token, row: row)
			&& !tokenInCol(token: token, col: col)
			&& !tokenInSquare(token: token, row: row, col: col)
	}
	
	func tokenInRow(token: Int, row: Int) -> Bool {
		return grid[row].filter { $0 == token }.count > 0
	}
	
	
	func tokenInCol(token: Int, col: Int) -> Bool {
		return grid.filter { $0[col] == token }.count > 0
	}
	
	
	func tokenInSquare(token: Int, row: Int, col: Int) -> Bool {
		let square: [[Int]] = getSquare(row: row, col: col)
		
		return square[0].contains(token)
			|| square[1].contains(token)
			|| square[2].contains(token)
	}
}
