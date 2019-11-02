//
//  KeyboardView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct KeyboardView: View {
	private var _grid: Grid!
	
	init(grid: Grid) {
		_grid = grid
	}
	
	var body: some View {
		VStack {
			OptionsRowView()
			NumbersRowView(grid: _grid)
		}
	}
}

struct OptionsRowView: View {
	var body: some View {
		HStack {
			Spacer()
			Button(
				action: {

				},
				label: {
					VStack {
						Image(systemName: "gobackward")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
						Text("Anular")
							.font(.custom("CaviarDreams-Bold",
										  size: Screen.cellWidth / 2))
							
					}
						.foregroundColor(Colors.MatteBlack)
				}
			)
			
			Spacer()
			
			Button(
				action: {
					
				},
				label: {
					VStack {
						Image(systemName: "xmark.circle")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
							.foregroundColor(Colors.EraserPink)
						Text("Apagar")
							.font(.custom("CaviarDreams-Bold",
										  size: Screen.cellWidth / 2))
							.foregroundColor(Colors.MatteBlack)
					}
				}
			)
			
			Spacer()
		}
		.padding(.top)
		.padding(.bottom)
	}
}

struct NumbersRowView: View {
	private var _grid: Grid!
	
	init(grid: Grid) {
		_grid = grid
	}
	
	var body: some View {
		HStack {
			ForEach(1 ..< 10) { i in
				Spacer()
				Button(
					action: {
						print("clicked")
						let active = self._grid.getActive()
						print(active!)
						self._grid.setNumber(row: active![0],
											 col: active![1],
											 number: i)
					},
					label: {
						Text("\(i)")
							.foregroundColor(Colors.MatteBlack)
							.font(.custom("CaviarDreams-Bold",
										  size: Screen.cellWidth))
					}
				)
			}
			Spacer()
		}
		.padding(.top)
		.padding(.bottom)
		.padding(.leading, -5)
	}
}
