//
//  CustomerSearchandItemDisplayView.swift
//  OrderUp
//
//  Created by Nana Bonsu on 10/21/23.
//

import SwiftUI

/// Implements an entry feil to enter a code to search for vendor, then displays the relevant items fetched.
struct CustomerSearchandItemDisplayView: View {
    @State private var vendorCode = ""
    var body: some View {
        VStack(alignment: .center, spacing: 40) {
            //Textfeild. Then when enter code, shows a grid layout of items(might have search box
            Text("Enter The Vendor Code")
            
            Spacer()
            //Text feild here
            TextField("Type code here", text: $vendorCode)
                .font(.system(size: 50))
                .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.blue, lineWidth: 2) // Border color and width
                        )
            
            Spacer()
            Button("Continue") {
                
            }
                .padding()
                .background(Color.blue)
                .foregroundColor(Color.white)
                .cornerRadius(15)
                .onSubmit {
                    
                }
            
    
        }
        .frame(width: .infinity, height: 200)  //maybe will need to check the distance from the safe area actually!
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

struct CustomerSearchandItemDisplayView_Previews: PreviewProvider {
    static var previews: some View {
        CustomerSearchandItemDisplayView()
    }
}


