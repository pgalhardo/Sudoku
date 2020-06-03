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
	@State var displayAlert: Bool = false
	@State var alertText: String = String()

	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
		
	var body: some View {
		VStack {
			GameTopBarView(isPaused: $_isPaused)

			ZStack {
				GridView(isPaused: $_isPaused)

				VStack {
					Text("banners.pause.title")
						.font(.custom("CaviarDreams-Bold", size: 50))
					Text("banners.pause.stats: \(self.grid.completion())")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
					.foregroundColor(.black)
					.shadow(radius: 10)
					.opacity(_isPaused ? 1 : 0)
					.animation(.spring())
							
				VStack {
					Text("banners.congrats.title")
						.font(.custom("CaviarDreams-Bold", size: 50))
					Text("banners.congrats.stats: \(self.grid.getErrorCount())")
						.font(.custom("CaviarDreams-Bold", size: 20))

					Button(
						action: {
							withAnimation(.easeIn) {
								UserDefaults.standard.set(nil,
														  forKey: "savedBoard")
								UserDefaults.standard.set(nil,
														  forKey: "time")
								self.viewRouter.setCurrentPage(page: Pages.home)
							}
						},
						label: {
							HStack {
								Spacer()
								Text("button.leave")
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
					.opacity(self.grid.full() ? 1 : 0)
					.animation(.spring())
				
				Text(LocalizedStringKey(alertText))
					.font(.custom("CaviarDreams-Bold", size: 15))
					.padding()
					.background(Colors.LightBlue)
					.cornerRadius(20)
					.overlay(RoundedRectangle(cornerRadius: 20)
					.stroke(Colors.MatteBlack, lineWidth: 2))
					.shadow(radius: 10)
					.blur(radius: displayAlert ? 0 : 50)
					.opacity(displayAlert ? 1 : 0)
					.animation(.spring())
					.onTapGesture {
						self.displayAlert = false
					}
			}

			Spacer()
			Text("game.errors: \(grid.getErrorCount())")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 2))
				.blur(radius: _isPaused || self.grid.full() ? 5 : 0)
				.animation(.spring())
			
			Spacer()
			KeyboardView(isPaused: $_isPaused,
						 displayAlert: $displayAlert,
						 alertText: $alertText)
			Spacer()
		}
	}
}

struct GameTopBarView: View {
	private var timerView: TimerView!

	@Binding var isPaused: Bool
	
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var grid: Grid
		
	init(isPaused: Binding<Bool>) {
		_isPaused = isPaused
		self.timerView = TimerView(isPaused: isPaused)
	}
	
	private let labelSize: CGFloat = 15.0
	private let backButtonSize: CGFloat = Screen.cellWidth / 2
	private let pauseButtonSize: CGFloat = Screen.cellWidth / 3

	var body: some View {
		ZStack {
			HStack {
				Button(
					action: {
						withAnimation(.easeIn) {
							UserDefaults.standard.set(self.grid.toString(),
													  forKey: "savedBoard")
							self.viewRouter.setCurrentPage(page: Pages.home)
						}
					},
					label: {
						Image(systemName: "arrow.left")
							.resizable()
							.frame(width: backButtonSize,
								   height: backButtonSize)
						Text("main.back")
							.font(.custom("CaviarDreams-Bold", size: labelSize))
					}
				)
					.foregroundColor(Colors.MatteBlack)
				Spacer()
			}
				.disabled(grid.full())
				.opacity(opacity())

			if self.settings.enableTimer == true {
				HStack {
					Spacer()
					self.timerView
					Spacer()
				}
			}
			
			if self.settings.enableTimer == true {
				HStack {
					Spacer()
					Button(
						action: {
							withAnimation {
								self.isPaused.toggle()
							}
						},
						label: {
							Image(systemName: self.pauseIconName())
								.resizable()
								.frame(width: self.pauseButtonSize,
									   height: self.pauseButtonSize)
						}
					)
						.foregroundColor(Colors.MatteBlack)
				}
					.disabled(self.grid.full())
					.opacity(self.opacity())
			}
		}
			.padding(.top)
			.padding(.leading)
			.padding(.trailing)
	}
	
	func opacity() -> Double {
		return grid.full() ? 0.0 : 1.0
	}

	func pauseIconName() -> String {
		return self.isPaused ? "play.fill" : "pause"
	}
}
