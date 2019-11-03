//
//  GridView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 27/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct GridView: View {
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
	@Binding var _isPaused: Bool
	
	var body: some View {
		ZStack {
			Group {
				VStack(spacing: -1) {
					ForEach(0 ..< 9) { row in
						HStack(spacing: -1) {
							ForEach(0 ..< 9) { col in
								self._grid.cellAt(row: row, col: col).toString()
									.frame(width: Screen.cellWidth,
										   height: Screen.cellWidth)
									.border(Color.black, width: 1)
									.padding(.all, 0)
									.background(self._grid.cellAt(row: row, col: col).getColor())
									.onTapGesture {
										self.update(row: row, col: col)
										self._grid.objectWillChange.send()
									}
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
				.opacity(_isPaused ? 0.5 : 1)
				.disabled(_isPaused)
				.blur(radius: _isPaused ? 5 : 0)
			
			if (_isPaused) {
				VStack {
					Text("Em pausa")
						.font(.custom("CaviarDreams-Bold", size: 50))
						.foregroundColor(.black)
						.shadow(radius: 10)
					Text(String(format: "%02d%% completo", arguments: [_grid.completion()]))
						.font(.custom("CaviarDreams-Bold", size: 20))
						.foregroundColor(.black)
						.shadow(radius: 10)
				}
			}
		}
			.frame(width: Screen.cellWidth * 9,
				   height: Screen.cellWidth * 9,
				   alignment: .center)
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
		
		if self._grid.cellAt(row: row, col: col).getColor() == Color.white {
			if (_settings._highlightAreas == true) {
				self.toggleLineColor(cell: cell, rowMode: true)
				self.toggleLineColor(cell: cell, rowMode: false)
			}
			_grid.cellAt(row: row, col: col).setColor(color: Colors.ActiveBlue)
		}
		else {
			for i in (0 ..< 9) {
				for j in (0 ..< 9) {
					_grid.cellAt(row: i, col: j).setColor(color: Color.white)
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
				_grid.cellAt(row: row, col: i).setColor(color: Colors.LightBlue)
			} else {
				_grid.cellAt(row: i, col: col).setColor(color: Colors.LightBlue)
			}
		}
	}
}
