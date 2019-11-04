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
	@State private var _deleteAlert = false
	@State private var _overwriteAlert = false
	
	@Binding var _isPaused: Bool
	
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
	
	var body: some View {
		VStack {
			if (_deleteAlert) {
				Spacer()
				Text("Impossível remover valor pré-definido")
					.font(.custom("CaviarDreams-Bold", size: 15))
				Spacer()
			} else if (_overwriteAlert) {
				Spacer()
				Text("Impossível sobrescrever valor pré-definido")
					.font(.custom("CaviarDreams-Bold", size: 15))
				Spacer()
			}
			
			KeyboardOptionsView(_deleteAlert: $_deleteAlert)
			KeyboardNumbersView(_overwriteAlert: $_overwriteAlert)
		}
			.blur(radius: _isPaused ? 5 : 0)
			.opacity(_isPaused ? 0.7 : 1)
			.disabled(_isPaused)
			.animation(.spring())
	}
}

struct KeyboardOptionsView: View {
	@EnvironmentObject var _grid: Grid
	@Binding var _deleteAlert: Bool
	
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
					guard let active = self._grid.getActive()
					else { return }
					
					if self._grid.setValue(row: active[0],
										   col: active[1],
										   value: 0) == false {
						
						// display error message
						self._deleteAlert = true
						DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
							self._deleteAlert = false
						}
						
						// haptic feedback
						let generator = UINotificationFeedbackGenerator()
						generator.notificationOccurred(.error)
						
					} else {
						self._grid.objectWillChange.send()
					}
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

struct KeyboardNumbersView: View {
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
	@Binding var _overwriteAlert: Bool
	
	var body: some View {
		HStack {
			ForEach(1 ..< 10) { i in
				if (self._grid.getNumberFrequency()[i - 1] < 9
					&& self._settings._hideUsed) {
					Spacer()
					Button(
						action: {
							guard let active = self._grid.getActive()
							else { return }
							
							if self._grid.setValue(row: active[0],
												   col: active[1],
												   value: i) == false {
								
								// display error message
								self._overwriteAlert = true
								DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
									self._overwriteAlert = false
								}
								
								// haptic feedback
								let generator = UINotificationFeedbackGenerator()
								generator.notificationOccurred(.error)
								
							} else {
								self._grid.objectWillChange.send()
							}
						},
						label: {
							Text("\(i)")
								.foregroundColor(Colors.MatteBlack)
								.font(.custom("CaviarDreams-Bold",
											  size: Screen.cellWidth))
						}
					)
				}
			}
			Spacer()
		}
			.padding(.top)
			.padding(.bottom)
			.padding(.leading, -5)
	}
}
