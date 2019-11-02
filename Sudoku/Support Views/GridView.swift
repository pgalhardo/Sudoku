//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI
import Combine

struct GridView: View {
	@ObservedObject var _grid: Grid = Grid()
	
	var body: some View {
		VStack {
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
										self._grid.cellAt(row: row, col: col).toString()
									}
								)
									.frame(width: Screen.cellWidth,
										   height: Screen.cellWidth)
									.border(Color.black, width: 1)
									.padding(.all, 0)
									.background(self._grid.colors[row][col])
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
				
			}
				.frame(width: Screen.cellWidth * 9,
					   height: Screen.cellWidth * 9,
					   alignment: .center)
			
			Spacer()
			KeyboardView(grid: _grid)
			Spacer()
		}
	}
		
	func update(row: Int, col: Int) {
		_grid.setActive(row: row, col: col)
		
		let previous = _grid.getPrevious()
		let active = _grid.getActive()
		
		// double click, disable both
		if previous == active {
			self.toggleColor(cell: active)
			_grid.resetActive()
		}
		else {
			self.toggleColor(cell: previous)
			self.toggleColor(cell: active)
		}
	}
	
	func toggleColor(cell: [Int]?) {
		if (cell == nil) { return }
		let row = cell![0], col = cell![1]
		
		if _grid.colors[row][col] == Color.white {
			self.toggleLineColor(cell: cell, rowMode: true)
			self.toggleLineColor(cell: cell, rowMode: false)
			_grid.colors[row][col] = Colors.ActiveBlue
		}
		else {
			for i in (0 ..< 9) {
				for j in (0 ..< 9) {
					_grid.colors[i][j] = Color.white
				}
			}
		}
	}
		
	func toggleLineColor(cell: [Int]?, rowMode: Bool) {
		let row = cell![0], col = cell![1]
		
		for i in (0 ..< 9) {
			if (rowMode == false && i == row)
			|| (rowMode == true && i == col) {
				continue
			}
			else if rowMode == true {
				_grid.colors[row][i] = Colors.LightBlue
			} else {
				_grid.colors[i][col] = Colors.LightBlue
			}
		}
	}
}

struct GridView_Previews: PreviewProvider {
	static var previews: some View {
		GridView()
	}
}
