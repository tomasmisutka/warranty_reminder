//
//  AddProductView.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI
import CoreData

struct AddProductView: View
{
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @Environment(\.managedObjectContext) private var viewContext
    
    @State private var productName: String
    @State private var selectedCategory: ProductCategory
    @State private var warrantyDate: Date
    @State private var notifyMe: Notification
    @State private var showImagePicker = false
    @State private var uploadedImage: Image?
    @State private var inputImage: UIImage?
    private var product: Product?
    private var isEditingMode: Bool
    
    init(currenctProduct: Product?, isEditingMode: Bool = false)
    {
        //create on image string name
        let noImageName = "camera.viewfinder"
        
        //asigning values from constructor
        self.product = currenctProduct
        self.isEditingMode = isEditingMode
        
        //setting data according to mode (adding or editing)
        self._productName = State(wrappedValue: isEditingMode ? (product?.name ?? "editing product") : "")
        
        self._selectedCategory = State(wrappedValue: isEditingMode ? (Utils.categoryFromString(valueString: product?.category ?? "HOME")) : .home)
        
        self._warrantyDate = State(wrappedValue: isEditingMode ? (product?.warrantyUntil ?? Date()) : Date())
        
        self._notifyMe = State(wrappedValue: isEditingMode ? (Utils.notificationFromString(valueInt: Int(product?.notificationBefore ?? 1))) : .day_before)
        
        self._uploadedImage = State(wrappedValue: isEditingMode ? Utils.getImageFromBinary(binaryValue: product?.image! ?? nil): Image(systemName: noImageName))
        
        //initiate inputImage to default image
        let uiImage = UIImage(systemName: noImageName)
        self._inputImage = State(wrappedValue: uiImage)
    }
    
    var body: some View
    {
        ScrollView
        {
            VStack(alignment: .leading, spacing: 20)
            {
                //navigation toolbar made on my own
                HStack
                {
                    Button(action: {
                        //code to move to previous view
                        self.presentationMode.wrappedValue.dismiss()
                        })
                    {
                        Image(systemName: "chevron.backward")
                        Text("Back")
                    }
                    Spacer()
                    Button(isEditingMode ? "Update" : "Save", action: saveProduct)
                }
                //Text describing screen view
                Text("\(isEditingMode ? "Edit" : "Add") product")
                    .font(.title)
                    .fontWeight(.heavy)
                //Textfield with Text to enter product name
                HStack
                {
                    Text("Product Name:")
                        .font(.headline)
                    TextField("name of product", text: $productName)
                }
                //picker for choosing product category
                HStack
                {
                    Text("Category:")
                        .font(.headline)
                    Picker("Choose category", selection: $selectedCategory)
                    {
                        ForEach(ProductCategory.allCases, id: \.self)
                        { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }
                }
                //date picker for choosing warranty date valid until
                DatePicker("Warranty valid to:",
                        selection: $warrantyDate,
                        in: Date.now...,
                        displayedComponents: .date)
                            .id(warrantyDate)
                            .font(.headline)
                //picker for choosing when you want to be informed about ending warranty
                HStack
                {
                    Text("Notify me:")
                        .font(.headline)
                    Picker("choose, when you want to be warned before ending warranty:", selection: $notifyMe)
                    {
                        ForEach(Notification.allCases, id: \.self)
                        { value in
                            Text(value.localizedName)
                                .tag(value)
                        }
                    }
                }
                //Text which open image picker after tap on
                HStack
                {
                    Spacer()
                    Text("\(isEditingMode ? "update" : "upload") image")
                        .foregroundColor(.blue)
                        .onTapGesture { showImagePicker = true }
                    Spacer()
                }
                //displaying default image or loaded from galery
                HStack
                {
                    Spacer()
                    uploadedImage?
                        .resizable()
                        .cornerRadius(15)
                        .frame(width: 300, height: 300, alignment: .center)
                    Spacer()
                }
                //final spacer to move everything up
                Spacer()
            }.padding(.horizontal, 15)
            .navigationBarHidden(true)
            .onChange(of: inputImage) { _ in loadImageFromGalery() }
            .sheet(isPresented: $showImagePicker)
            {
                ImagePicker(image: $inputImage)
            }
        }
    }
    
    private func saveProduct()
    {
        let imageData = inputImage?.jpegData(compressionQuality: 0.8)
        let currentProduct = self.product == nil ? Product(context: viewContext) : self.product
            
        currentProduct?.name = productName
        currentProduct?.category = selectedCategory.rawValue
        currentProduct?.warrantyUntil = warrantyDate
        currentProduct?.notificationBefore = Int16(Transformer.transformDaysFromString(notification: notifyMe))
        currentProduct?.image = imageData
        currentProduct?.status = 0 //0 - active, 1 - expire soon, 2 - inactive
            
        //saving logic
        do
        {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        //move back to previous view
        self.presentationMode.wrappedValue.dismiss()
    }
    
    private func loadImageFromGalery()
    {
        guard let inputImage = inputImage else { return }
        uploadedImage = Image(uiImage: inputImage)
    }
}

//struct AddProductView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        AddProductView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
