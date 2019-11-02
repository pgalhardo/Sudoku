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
	private var _grid: Grid!
	
	init() {
		_grid = Grid()
		_grid.fill()
	}
	
	func getGrid() -> Grid {
		return _grid
	}
}
