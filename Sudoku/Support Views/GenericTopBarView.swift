//
//  GenericTopBarView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 03/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct GenericTopBarView: View {
	private var _title: String!
	private var _destination: Int!
	
	@EnvironmentObject var _viewRouter: ViewRouter
	
	init(title: String, destination: Int) {
		_title = title
		_destination = destination
	}
	
	var body: some View {
		ZStack {
			Text(_title)
				.font(.custom("CaviarDreams-Bold", size: 20))
			
			HStack {
				Button(
					action: {
						withAnimation(.easeIn) {
							self._viewRouter.setCurrentPage(page: self._destination)
						}
					},
					label: {
						Image(systemName: "return")
							.resizable()
							.frame(width: Screen.cellWidth / 2,
								   height: Screen.cellWidth / 2)
						Text(NSLocalizedString("main.back", comment: ""))
							.font(.custom("CaviarDreams-Bold", size: 15))

					}
				)
					.foregroundColor(Colors.MatteBlack)
				Spacer()
			}
		}
			.padding(.top)
			.padding(.leading)
			.padding(.trailing)
	}
}
