//
//  StatisticsView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 02/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct StatisticsView: View {
	@EnvironmentObject var _viewRouter: ViewRouter
	
    var body: some View {
		VStack(spacing: 0) {
			GenericTopBarView(title: "Estatísticas", destination: Pages.home)
			Spacer()
		}
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
