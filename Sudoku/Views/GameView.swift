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
			GameTopBarView(isPaused: $_isPaused)
			
			ZStack {
				GridView(_isPaused: $_isPaused)
				
				VStack {
					Text("Em pausa")
						.font(.custom("CaviarDreams-Bold", size: 50))
					Text(String(format: "%02d%% completo", _grid.completion()))
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
					.foregroundColor(.black)
					.shadow(radius: 10)
					.opacity(_isPaused ? 1 : 0)
					.animation(.spring())
							
				VStack {
					Text("Parabéns!")
						.font(.custom("CaviarDreams-Bold", size: 50))
					Text(String(format: "Terminado com %d erros", _grid.getErrorCount()))
						.font(.custom("CaviarDreams-Bold", size: 20))
					
					Button(
						action: {
							withAnimation(.easeIn) {
								UserDefaults.standard.set(nil,
														  forKey: "savedBoard")
								UserDefaults.standard.set(nil,
														  forKey: "time")
								self._viewRouter.setCurrentPage(page: Pages.home)
							}
						},
						label: {
							HStack {
								Spacer()
								Text("Sair")
									.font(.custom("CaviarDreams-Bold", size: 20))
								Spacer()
							}
						}
					)
						.frame(width: Screen.width * 0.55,
							   height: 50)
						.background(Colors.MatteBlack)
						.cornerRadius(40)
						.padding(.all, 7)
						.foregroundColor(.white)
						.shadow(radius: 20)
						.padding(.top, 20)
				}
					.shadow(radius: 10)
					.opacity(exit() ? 1 : 0)
					.animation(.spring())
				
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
			Text(String(format: "Erros: %d / 3", _grid.getErrorCount()))
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.blur(radius: _isPaused || exit() ? 5 : 0)
				.animation(.spring())
			
			Spacer()
			KeyboardView(_isPaused: $_isPaused,
						 _displayAlert: $_displayAlert,
						 _alertText: $_alertText)
			Spacer()
		}
	}
	
	func exit() -> Bool {
		return _grid.completion() == 100
	}
}

struct GameTopBarView: View {
	private var _timerView: TimerView!
	
	@Binding var isPaused: Bool
	
	@EnvironmentObject var _viewRouter: ViewRouter
	@EnvironmentObject var _settings: Settings
	@EnvironmentObject var _grid: Grid
		
	init(isPaused: Binding<Bool>) {
		_isPaused = isPaused
		_timerView = TimerView(isPaused: isPaused)
	}
	
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
								self.isPaused.toggle()
							}
						},
						label: {
							Image(systemName: self.isPaused
								? "play.fill"
								: "pause")
								.resizable()
								.frame(width: Screen.cellWidth / 3,
									   height: Screen.cellWidth / 3)
						}
					)
						.foregroundColor(Colors.MatteBlack)
				}
					.disabled(exit())
					.opacity(exit() ? 0 : 1)
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
