//
//  CreateCategoryView.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/17/21.
//

import SwiftUI
import CoreData

struct CreateCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var showPopUp = true
    @State var name: String = ""
    let maxCategoryNameLength = 50
    
    @Environment(\.managedObjectContext) private var managedObjectContext
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    private var categories: FetchedResults<Category>
    
    //    @State private var isActionSheetPresented = false
    //    @State private var isAlertPresented = false
    
    
    var body: some View {
        if $showPopUp.wrappedValue {
            ZStack {
                Color.white
                VStack {
                    TextField("Name", text: $name)
                        .border(Color.black)
                    Spacer()
                    HStack {
                        Button(action: {
                            self.showPopUp = false
                        }, label: {
                            Text("Cancel")
                        })
                        
                        Button(action: {
                            self.createCategory()
                            self.showPopUp = false
                        }, label: {
                            Text("Create")
                        })
                    }
                    
                }.padding()
            }
            .frame(width: 300, height: 200)
            .cornerRadius(20).shadow(radius: 20)
        }
        
        /*
         Group{
         VStack (spacing: 20) {
         TextField("Name", text: $name)
         .border(Color.black)
         
         Button(action: {
         self.createCategory()
         }) {
         Text("Create!")
         .font(.largeTitle)
         }
         }.font(.title)
         .navigationBarTitle("Create category")
         Spacer()
         }.padding()
         */
    }
    
    func createCategory() {
        print("creating category: \(name)")
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            print("failed to create nameless category")
            dismiss()
            return
        }
        
        if trimmedName.count > maxCategoryNameLength {
            print("failed to create category: name length > 50 characters")
            dismiss()
            return
        }
        
        if categories.contains(where: {$0.name?.lowercased() == trimmedName.lowercased()}) {
            print("failed to create duplicate category: \(trimmedName)")
            dismiss()
            return
        }
        
        let category = Category(context: managedObjectContext)
        category.name = trimmedName
        PersistenceController.shared.save()
        
        print("category successfully created: \(trimmedName)")
        dismiss()
    }
    
    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}



struct CreateCategoryView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCategoryView()
    }
}
