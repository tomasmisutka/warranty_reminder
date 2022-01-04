//
//  ProductDetailView.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 04/01/2022.
//

import SwiftUI

struct ProductDetailView: View
{
    @State private var product: Product
    
    init(currentProduct: Product)
    {
        self.product = currentProduct
    }
    
    var body: some View
    {
        Text("Product name: \(product.name ?? "product name")")
    }
}

//struct ProductDetailView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        ProductDetailView(currentProduct: product)
//    }
//}
