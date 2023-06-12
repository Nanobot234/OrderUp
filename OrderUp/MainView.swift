//
//  MainView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/3/23.
//

import SwiftUI

struct MainView: View {
    var body: some View {
        TabView {
            HomeView().tabItem {
                Label("My Items", image: "list.dash")
                
            }
            //add more tabs here to work with
            
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
