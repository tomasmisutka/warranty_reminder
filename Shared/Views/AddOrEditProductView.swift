//
//  AddProductView.swift
//  WarrantyReminderSwiftUI
//
//  Created by Tomáš Mišutka on 03/01/2022.
//

import SwiftUI
import CoreData

struct AddOrEditProductView: View
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
    @State private var showNotificationAlert: Bool = false
    private var product: Product?
    private var isEditingMode: Bool
    private var usingNotification: Bool
    
    init(currenctProduct: Product?, isEditingMode: Bool = false, usingNotification: Bool)
    {
        //create on image string name
        let noImageName = "camera.viewfinder"
        
        //asigning values from constructor
        self.product = currenctProduct
        self.isEditingMode = isEditingMode
        self.usingNotification = usingNotification
        
        //setting data according to mode (adding or editing)
        self._productName = State(wrappedValue: isEditingMode ? (product?.name ?? "editing product") : "")
        
        self._selectedCategory = State(wrappedValue: isEditingMode ? (Utils.categoryFromString(valueString: product?.category ?? "HOME")) : .home)
        
        self._warrantyDate = State(wrappedValue: isEditingMode ? (product?.warrantyUntil ?? Date()) : Date())
        
        self._notifyMe = State(wrappedValue: isEditingMode ? (Utils.notificationFromString(valueInt: Int(product?.notificationBefore ?? 1))) : .day_before)
        
        self._uploadedImage = State(wrappedValue: isEditingMode ? Utils.getImageFromBinary(binaryValue: product?.image! ?? nil): Image(systemName: noImageName))
        
        //initiate inputImage to default image
        self._inputImage = State(wrappedValue: isEditingMode ? UIImage(data: product!.image!) : UIImage(systemName: noImageName))
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
                        .frame(width: 325, height: 325, alignment: .center)
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
            .alert("Notifications are disabled. Notifications won't be pushed to your device. Go to Settings and enable notifications!", isPresented: $showNotificationAlert)
            {
                Button("OK", role: .cancel, action: returnBackToPreviousView)
            }
        }
    }
    
    private func saveProduct()
    {
        let imageData = inputImage?.jpegData(compressionQuality: 0.8)
        let currentProduct = self.product == nil ? Product(context: viewContext) : self.product
        
        var remainingDays: Int = 0
        var daysFromExpiry: Int = 0
        
        if isEditingMode
        {
            viewContext.performAndWait
            {
                currentProduct!.name = productName
                currentProduct!.category = selectedCategory.rawValue
                currentProduct!.warrantyUntil = warrantyDate
                currentProduct!.notificationBefore = Int16(Transformer.transformDaysFromString(notification: notifyMe))
                currentProduct!.image = imageData
                remainingDays = Utils.getNumberOfDaysBetweenDates(currentProduct: currentProduct!, verifyStatus: true)
                //0 - active, 1 - expire soon, 2 - inactive
                
                do
                {
                    try viewContext.save()
                    print("product updated")
                } catch
                {
                    print("Error while updating product")
                    let nsError = error as NSError
                    fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                }
                
                //code to delete notification before update
                let productID = currentProduct!.id!.uuidString
                NotificationSender.deleteScheduledNotification(productID: productID)
            }
        } else
        {
            currentProduct!.id = UUID()
            currentProduct!.name = productName
            currentProduct!.category = selectedCategory.rawValue
            currentProduct!.warrantyUntil = warrantyDate
            currentProduct!.notificationBefore = Int16(Transformer.transformDaysFromString(notification: notifyMe))
            currentProduct!.image = imageData
            //0 - active, 1 - expire soon, 2 - inactive
            remainingDays = Utils.getNumberOfDaysBetweenDates(currentProduct: currentProduct!, verifyStatus: true)
            
            do
            {
                try viewContext.save()
                print("new product saved")
            } catch
            {
                print("Error while saving new product")
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
        
        //schedule new notification
//        if usingNotification
//        {
        daysFromExpiry = Int(Transformer.transformDaysFromString(notification: notifyMe))
        
        NotificationSender.scheduleNotification(product: currentProduct!, usingNotification: usingNotification, remaininDays: remainingDays, daysFromExpiry: daysFromExpiry)
//        }
//        else { showNotificationAlert = true } //alert about disabled notifications
        
        self.returnBackToPreviousView()            
    }
    
    private func loadImageFromGalery()
    {
        guard let inputImage = inputImage else { return }
        uploadedImage = Image(uiImage: inputImage)
    }
    
    private func returnBackToPreviousView()
    {
        self.presentationMode.wrappedValue.dismiss() //return back to previous view
    }
}

//struct AddProductView_Previews: PreviewProvider
//{
//    static var previews: some View
//    {
//        AddProductView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
