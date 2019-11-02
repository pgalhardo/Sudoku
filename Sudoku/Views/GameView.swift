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
	let _grid: Grid!
	
	@State var _isPaused: Bool = false
	@EnvironmentObject var _viewRouter: ViewRouter
	
	init(grid: Grid) {
		_grid = grid
	}
	
	var body: some View {
		VStack {
			HStack {
				Button(
					action: {
						withAnimation(.easeIn) {
							self._viewRouter.setCurrentPage(page: Pages.home)
						}
					},
					label: {
						Image(systemName: "stop.fill")
							.resizable()
							.frame(width: 30, height: 30)
							.foregroundColor(Color(red: 31 / 255,
												   green: 31 / 255,
												   blue: 36 / 255))
					}
				)
				Spacer()
				
				TimerView()
				
				Spacer()
				Button(
					action: {
						/*
						withAnimation(.easeIn) {
							self._viewRouter.setCurrentPage(page: Pages.pause)
						}
						*/
					},
					label: {
						Image(systemName: "pause.fill")
							.resizable()
							.frame(width: 30, height: 30)
							.foregroundColor(Color(red: 31 / 255,
												   green: 31 / 255,
												   blue: 36 / 255))
					}
				)
			}
				.padding()
				
			Spacer()
			GridView(grid: _grid)
			Spacer()
			KeyboardView()
			Spacer()
		}
	}
}
