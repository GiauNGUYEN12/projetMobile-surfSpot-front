//
//  DisplayPages.swift
//  surfSpot
//
//  Created by Giau Nguyen on 07/05/2025.
//

import SwiftUI

struct DisplayPages: View {
    @State private var tabSelection = 1

    var body: some View {
        TabView(selection: $tabSelection) {
            DestinationMenuView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Destinations")
                }
                .tag(1)
            AddNewSpotView(tabSelection: self.$tabSelection)
                .tabItem {
                    Image(systemName: "plus")
                    Text("Add")
                }
                .tag(2)
        }
    }
}

#Preview {
    DisplayPages()
}
