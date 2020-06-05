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
	
	@State private var displayAlert: Bool = false
	@State private var alertText: String = String()
	
	@EnvironmentObject var grid: Grid
	@EnvironmentObject var settings: Settings
	@EnvironmentObject var viewRouter: ViewRouter
	@EnvironmentObject var pauseHolder: PauseHolder
	@EnvironmentObject var timerHolder: TimerHolder
	
	private let labelSize: CGFloat = 15.0
	private let backButtonSize: CGFloat = Screen.cellWidth / 2
	private let pauseButtonSize: CGFloat = Screen.cellWidth / 3
	
	var body: some View {
		NavigationView {
			self.screen
				.navigationBarTitle("", displayMode: .inline)
				.navigationBarItems(leading: self.backButton,
									trailing: self.pauseButton)
        }
	}
	
	private var backButton: some View {
		Button(
			action: {
				withAnimation(.easeIn) {
					UserDefaults.standard.set(self.grid.toString(),
											  forKey: "savedBoard")
					self.timerHolder.storeCounterValue()
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
			.foregroundColor(Color(.label))
	}
		
	@ViewBuilder
	private var pauseButton: some View {
		if self.settings.enableTimer == true {
			Button(
				action: {
					withAnimation {
						self.pauseHolder.toggle()
						
						if self.pauseHolder.isPaused() {
							self.timerHolder.stop()
						} else {
							self.timerHolder.start()
						}
					}
				},
				label: {
					Image(systemName: self.pauseIconName())
						.resizable()
						.frame(width: self.pauseButtonSize,
							   height: self.pauseButtonSize)
				}
			)
				.foregroundColor(Color(.label))
		}
	}
	
	@ViewBuilder
	private var screen: some View {
		VStack(spacing: 0) {
			
			self.infoBar
				.padding(.top)
				.padding(.leading)
				.padding(.trailing)
	
			ZStack {
				GridView()
					.environmentObject(pauseHolder)
				
				VStack {
					Text("banners.pause.title")
						.font(.custom("CaviarDreams-Bold", size: 50))
					Text("banners.pause.stats: \(self.grid.completion())")
						.font(.custom("CaviarDreams-Bold", size: 20))
				}
					.foregroundColor(Color(.label))
					.shadow(radius: 10)
					.opacity(pauseHolder.isPaused() ? 1 : 0)
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
			KeyboardView(displayAlert: $displayAlert,
						 alertText: $alertText)
				.environmentObject(pauseHolder)
			Spacer()
		}
	}
	
	private var infoBar: some View {
		HStack {
			Text("game.errors: \(grid.getErrorCount())")
				.font(.custom("CaviarDreams-Bold", size: Screen.cellWidth / 3))
				
			Spacer()
			
			if self.settings.enableTimer == true {
				TimerView()
					.environmentObject(pauseHolder)
					.environmentObject(timerHolder)
			}
		}
		.blur(radius: self.pauseHolder.isPaused() || self.grid.full() ? 5 : 0)
		.animation(.spring())
	}
	
	func opacity() -> Double {
		return grid.full() ? 0.0 : 1.0
	}
	
	func pauseIconName() -> String {
		return self.pauseHolder.paused ? "play.fill" : "pause"
	}
	
	func safeAreaHeight() -> CGFloat {
		let window = UIApplication.shared.windows[0]
		let safeFrame = window.safeAreaLayoutGuide.layoutFrame
		return safeFrame.minY
	}
}
