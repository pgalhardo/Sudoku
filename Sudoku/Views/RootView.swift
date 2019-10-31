//
//  RootView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 30/10/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    let objectWillChange = PassthroughSubject<ViewRouter, Never>()
    
	var _currentPage: Int = Pages.home {
        didSet {
            objectWillChange.send(self)
        }
    }
	
	func getCurrentPage() -> Int {
		return _currentPage
	}
	
	func setCurrentPage(page: Int) {
		_currentPage = page
	}
}

struct RootView: View {
	private var _gameView: GameView!
	private var _grid: Grid!
	
	@ObservedObject var _viewRouter: ViewRouter
	
	init(gameView: GameView, grid: Grid, viewRouter: ViewRouter) {
		_gameView = gameView
		_grid = grid
		_viewRouter = viewRouter
	}
	
	var body: some View {
		VStack {
			if _viewRouter.getCurrentPage() == Pages.home {
				MenuView(gameView: _gameView, viewRouter: _viewRouter)
					.transition(.scale)
			} else if _viewRouter.getCurrentPage() == Pages.game {
				GameView(grid: _grid, viewRouter: _viewRouter)
					.transition(.move(edge: .trailing))
			} else if _viewRouter.getCurrentPage() == Pages.pause {
				PauseView(viewRouter: _viewRouter)
					.transition(.scale)
			}
		}
	}
}

struct RootView_Previews: PreviewProvider {
	static var previews: some View {
		RootView(gameView: GameView(grid: Grid(),
									viewRouter: ViewRouter()),
				 grid: Grid(),
				 viewRouter: ViewRouter())
	}
}
