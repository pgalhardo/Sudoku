//
//  GameView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

struct GameView: View {
	@State var _isPaused: Bool = false
	@State var _displayAlert: Bool = false
	@State var _alertText: String = ""
	
	@EnvironmentObject var _viewRouter: ViewRouter
	@EnvironmentObject var _grid: Grid
	@EnvironmentObject var _settings: Settings
		
	var body: some View {
		VStack {
			GameTopBarView(_isPaused: $_isPaused)
			
			ZStack {
				GridView(_isPaused: $_isPaused)
				Text(_alertText)
					.font(.custom("CaviarDreams-Bold", size: 15))
					.padding()
					.background(Colors.LightBlue)
					.cornerRadius(20)
					.overlay(RoundedRectangle(cornerRadius: 20)
					.stroke(Colors.MatteBlack, lineWidth: 2))
					.shadow(radius: 10)
					.blur(radius: _displayAlert ? 0 : 50)
					.opacity(_displayAlert ? 1 : 0)
					.animation(.spring())
					.onTapGesture {
						self._displayAlert = false
					}
			}
			
			Spacer()
			KeyboardView(_isPaused: $_isPaused,
						 _displayAlert: $_displayAlert,
						 _alertText: $_alertText)
			Spacer()
		}
	}
}

struct GameTopBarView: View {
	var _timerView = TimerView()
	
	@Binding var _isPaused: Bool
	
	@EnvironmentObject var _viewRouter: ViewRouter
	@EnvironmentObject var _settings: Settings
	@EnvironmentObject var _grid: Grid
		
	var body: some View {
		ZStack {
			HStack {
				Button(
					action: {
						withAnimation(.easeIn) {
							UserDefaults.standard.set(self._grid.store(),
													  forKey: "savedBoard")
							self._viewRouter.setCurrentPage(page: Pages.home)
						}
					},
					label: {
						Image(systemName: "return")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
						Text("Voltar")
							.font(.custom("CaviarDreams-Bold", size: 15))
					}
				)
					.foregroundColor(Colors.MatteBlack)
				Spacer()
			}
				.disabled(exit())
				.opacity(exit() ? 0 : 1)
			
			if (_settings._enableTimer == true) {
				HStack {
					Spacer()
					_timerView
					Spacer()
				}
			}
			
			if (_settings._enableTimer == true) {
				HStack {
					Spacer()
					Button(
						action: {
							withAnimation {
								self._isPaused.toggle()
								self._timerView.toggleTimer()
							}
						},
						label: {
							Image(systemName: self._isPaused
								? "play.fill"
								: "pause")
								.resizable()
								.frame(width: Screen.cellWidth / 3,
									   height: Screen.cellWidth / 3)
						}
					)
						.foregroundColor(Colors.MatteBlack)
				}
			}
		}
			.padding(.top)
			.padding(.leading)
			.padding(.trailing)
	}
	
	func exit() -> Bool {
		return _grid.completion() == 100
	}
}

struct ExitView: View {
	var body: some View {
		Text("TESTE")
	}
}

struct ExitView_Previews: PreviewProvider {
    static var previews: some View {
        ExitView()
    }
}
