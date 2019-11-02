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
	@EnvironmentObject var _grid: Grid
	
	var body: some View {
		VStack {
			OptionsRowView()
			NumbersRowView()
		}
	}
}

struct OptionsRowView: View {
	@EnvironmentObject var _grid: Grid
		
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
					guard let active = self._grid.getActive() else { return }
					self._grid.cellAt(row: active[0],
									  col: active[1]).setValue(value: 0)
					self._grid.objectWillChange.send()
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
	@EnvironmentObject var _grid: Grid
			
	var body: some View {
		HStack {
			ForEach(1 ..< 10) { i in
				Spacer()
				Button(
					action: {
						guard let active = self._grid.getActive() else { return }
						self._grid.cellAt(row: active[0],
										  col: active[1]).setValue(value: i)
						self._grid.cellAt(row: active[0],
										  col: active[1]).setUserInput(userInput: true)
						self._grid.objectWillChange.send()
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
