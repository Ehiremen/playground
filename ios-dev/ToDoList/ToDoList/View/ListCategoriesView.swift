//
//  ListCategoriesView.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/24/21.
//

import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(context: UIViewRepresentableContext<Self>) -> UIVisualEffectView {
        UIVisualEffectView()
    }
    func updateUIView(_ uiView: UIVisualEffectView, context: UIViewRepresentableContext<Self>) {
        uiView.effect = effect
    }
}

struct ListCategoriesView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Category.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    private var categories: FetchedResults<Category>
    
    @State var isAddPresented = false
    @State var name: String = ""
    
    var body: some View {
        
        
        ZStack {
            VStack{
                List {
                    ForEach(categories, id:\.self) { category in
                        if let categoryName = category.name {
                            NavigationLink(destination: ItemsInCategoryView(category: category)) {
                                Text(categoryName)
                            }
                        }
                    }.onDelete(perform: removeItem)
                }
                
                .navigationBarItems(trailing: Button(action: {
                    self.isAddPresented = true
                }){
                    Image(systemName: "plus.circle")
                }
                )
                
            }
            
            if $isAddPresented.wrappedValue {
                VisualEffectView(effect: UIBlurEffect(style: .prominent))
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        dismiss()
                    }
                
                ZStack {
                    Color(UIColor.systemBackground)
                    VStack{
                        List {
                            TextField("New category", text: $name)
                                .autocapitalization(UITextAutocapitalizationType.none)
                        }
                        
                        Spacer()
                        
                        HStack {
                            Button(action: {
                                self.isAddPresented = false
                            }, label: {
                                Text("Cancel")
                            })
                            Spacer()
                            Button(action: {
                                self.createCategory()
                                self.isAddPresented = false
                            }, label: {
                                Text("Create")
                            })
                        }.padding(20)
                    }
                    
                }
                .border(Color.gray)
                .frame(width: 300, height: 200)            }
        }.navigationBarTitle("Categories", displayMode: .inline)
            .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: Button(action: {
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "arrow.left.circle")
            })
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let category = categories[index]
            PersistenceController.shared.delete(category)
        }
    }
    
    func createCategory() {
        print("creating category: \(name)")
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let maxCategoryNameLength = 50
        
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
        self.isAddPresented = false
    }
    
}
