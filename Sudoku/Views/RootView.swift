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
	@EnvironmentObject var _viewRouter: ViewRouter
		
	var body: some View {
		VStack {
			if _viewRouter.getCurrentPage() == Pages.home {
				MenuView()
					.transition(.scale)
			} else if _viewRouter.getCurrentPage() == Pages.game {
				GameView()
					.transition(.move(edge: .trailing))
					.environmentObject(Grid())
			}
		}
	}
}
