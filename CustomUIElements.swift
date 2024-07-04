//
//  CustomUIElements.swift
//  OrderUp
//
//  Created by Nana Bonsu on 11/7/23.
//

import SwiftUI

struct ConfirmationButton: View {
    
    var title:String
    var action: () -> Void
    var body: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: 50)
            .background(Color.blue)
            .foregroundColor(Color.white)
            .cornerRadius(20)
            .padding(.horizontal,40)
    }
    
}

//struct RoundedNavButton:View {
//    var text:String
//    var viewToGo: String //the string descriving where the view is shown
//    var body: some View {
//      
//    }
//}

//
//struct CustomUIElements_Previews: PreviewProvider {
//    static var previews: some View {
//        CustomUIElements()
//    }
//}
