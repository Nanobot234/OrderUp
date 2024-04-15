//
//  MainView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/3/23.
//

import SwiftUI


enum VendorTabsScreens {
    case itemsScreen
    case ordersScreen
}
/// Displays various screens for a vendor in a tab form.
struct VendorTabs: View {
    
    @State var selection: VendorTabsScreens

    var body: some View {
        //likley need to place the logic
        
       
        TabView(selection: $selection) {
            VendorHomeView().tabItem {
                Label("My Items", systemImage:"list.dash")
                
               // NavigationLink(destination: <#T##() -> View#>, label: <#T##() -> View#>)
            }
            .tag(VendorTabsScreens.itemsScreen)
            //add more tabs here to work with.
            OrdersView().tabItem {
                Label("Orders", systemImage: "rectangle.portrait.and.arrow.right")
            }
            .tag(VendorTabsScreens.ordersScreen)
            
        }     
    }
}


//struct MainView_Previews: PreviewProvider {
//    static var previews: some View {
//        VendorTabs()
//    }
//}
