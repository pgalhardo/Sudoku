//
//  StrategiesView.swift
//  Sudoku
//
//  Created by Pedro Galhardo on 04/11/2019.
//  Copyright © 2019 Pedro Galhardo. All rights reserved.
//

import SwiftUI

struct StrategiesView: View {
    @EnvironmentObject var _viewRouter: ViewRouter
	
    var body: some View {
		VStack(spacing: 0) {
			GenericTopBarView(title: "Estratégias", destination: Pages.home)
			Spacer()
		}
    }
}

struct StrategiesView_Previews: PreviewProvider {
    static var previews: some View {
        StrategiesView()
    }
}
