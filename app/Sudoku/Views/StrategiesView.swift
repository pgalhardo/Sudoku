//
//  StrategiesView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 04/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct StrategiesView: View {
	
	@EnvironmentObject var viewRouter: ViewRouter
	
	var body: some View {
		ScrollView {
			VStack(spacing: 0) {
				GenericTopBarView(title: "main.strategies",
				destination: Pages.home)
				
				Spacer()
				Text("Soon...")
					.font(.custom("CaviarDreams-Bold", size: 15))
			}
		}
	}
}

struct StrategiesView_Previews: PreviewProvider {
	static var previews: some View {
		StrategiesView()
	}
}
