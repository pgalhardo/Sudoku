//
//  Game.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 29/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import SwiftUI

public class Game {
	private var _rootView: RootView!
	private var _grid: Grid!
	
	init(viewRouter: ViewRouter) {
		_grid = Grid()
		_grid.fill()
		_rootView = RootView(gameView: GameView(grid: _grid,
												viewRouter: viewRouter),
							 grid: _grid, viewRouter: viewRouter)
	}
	
	func getRootView() -> RootView {
		return _rootView
	}
}
