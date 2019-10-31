//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI
import UIKit

private var active: [Int] = [-1, -1]
private var previous: [Int] = [-1, -1]

struct GridView: View {
	let _grid: Grid!
	
	init(grid: Grid) {
		_grid = grid
	}
	
	@State private var colors: [[Color]] = Array(repeating:
		Array(repeating: Color.white, count: 9), count: 9)
	
	var body: some View {
		ZStack {
			VStack(spacing: -1) {
				ForEach(0 ..< 9) { row in
					HStack(spacing: -1) {
						ForEach(0 ..< 9) { col in
							Button(
								action: {
									self.update(row: row, col: col)
								},
								label: {
									self.buttonLabel(row: row, col: col)
								}
							)
							.frame(width: Screen.cellWidth, height: Screen.cellWidth)
							.border(Color.black, width: 1)
							.padding(.all, 0)
							.foregroundColor(.black)
							.background(self.colors[row][col])
						}
					}
				}
			}
			
			GeometryReader { geometry in
				Path { path in
					let hlines = 2
					let vlines = 2
					for index in 1 ... vlines {
						let vpos: CGFloat = CGFloat(index) * Screen.cellWidth * 3
						path.move(to: CGPoint(x: vpos, y: 4))
						path.addLine(to: CGPoint(x: vpos, y: geometry.size.height - 4))
					}
					for index in 1 ... hlines {
						let hpos: CGFloat = CGFloat(index) * Screen.cellWidth * 3
						path.move(to: CGPoint(x: 4, y: hpos))
						path.addLine(to: CGPoint(x: geometry.size.width - 4, y: hpos))
					}
				}
				.stroke(lineWidth: Screen.lineThickness)
			}
			
		}.frame(width: Screen.cellWidth * 9,
				height: Screen.cellWidth * 9,
				alignment: .center)
	}
	
	func buttonLabel(row: Int, col: Int) -> Text {
		
		let cell = _grid.cellAt(row: row, col: col)
		let number = cell.getNumber()
		if (number != 0) {
			return Text("\(number)")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
		}
		return Text(" ")
	}
	
	func update(row: Int, col: Int) {
		previous = active
		active = [row, col]

		// double click, disable both
		if previous == active {
			self.toggleColor(cell: active)
			previous = [-1, -1]
			active = [-1, -1]
		}
		else {
			self.toggleColor(cell: previous)
			self.toggleColor(cell: active)
		}
	}
	
	func toggleColor(cell: [Int]) {
		let row = cell[0], col = cell[1]
		
		if row < 0 || col < 0 || row > 8 || col > 8 {
			return
		}
		
		if colors[row][col] == Color.white {
			self.toggleLine(cell: cell, rowMode: true)
			self.toggleLine(cell: cell, rowMode: false)
			colors[row][col] = Colors.ActiveBlue
		}
		else {
			for i in (0 ..< 9) {
				for j in (0 ..< 9) {
					colors[i][j] = Color.white
				}
			}
		}
	}
		
	func toggleLine(cell: [Int], rowMode: Bool) {
		let row = cell[0], col = cell[1]
		
		for i in (0 ..< 9) {
			if (rowMode == false && i == row)
			|| (rowMode == true && i == col) {
				continue
			}
			else if rowMode == true {
				colors[row][i] = Colors.LightBlue
			} else {
				colors[i][col] = Colors.LightBlue
			}
		}
	}
}

struct GridView_Previews: PreviewProvider {
	static var previews: some View {
		GridView(grid: Grid())
	}
}
