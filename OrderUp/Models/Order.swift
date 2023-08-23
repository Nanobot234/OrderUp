//
//  Order.swift
//  OrderUp
//
//  Created by Nana Bonsu on 7/26/23.
//

import Foundation


struct OrderItem {
    
    let itemPrice: String
    let itemDescription: String
    let itemName: String
    let itemImage: Data
}

//this will be the order that the customer has made
struct Order {
    
    let items: [OrderItem]
    let orderID: String
}
