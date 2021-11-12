//
//  ItemDetailView.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/31/21.
//

import SwiftUI


struct ItemDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(entity: Item.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)])
    private var items: FetchedResults<Item>
    
    let category: Category
    let statuses: [String:Status] = Utils.statusDict
    enum Statuses: String, CaseIterable, Identifiable {
        case ns
        case ip
        case co
        case gu
        
        var id: String { self.rawValue }
    }
    
    var item: Item?
    
    
    @State var name: String = ""
    @State var details: String = ""
    @State var status: Statuses = Statuses.ns
    
    let created: Date
    @State var due: Date = Date()
    
    let isNewItem: Bool
    @State var hasDueDate = false
    private let dateFormatter = Utils.longDateShortTime
    
    init(category: Category) {
        self.isNewItem = true
        self.created = Date()
        self.category = category
    }
    
    
    init(category: Category, item: Item) {
        self.isNewItem = false
        self.item = item
        
        self.created = item.created ?? Date()
        self.category = item.toCategory ?? category
        
        _name = .init(initialValue: item.name ?? "")
        _details = .init(initialValue: item.details ?? "")
        
        _status = .init(initialValue: Statuses(rawValue: item.status!)!)
        if item.due != nil {
            _hasDueDate = .init(initialValue: true)
            _due = .init(initialValue: item.due!)
        }
        
    }
    
    var body: some View {
        List {
            
            TextField("Title", text: $name)
                .autocapitalization(UITextAutocapitalizationType.none)
            Text("Created \(dateFormatter.string(from: self.created))")
            ZStack {
                TextEditor(text: $details).autocapitalization(.none)
                if (details.count == 0) {
                    Text("Description").opacity(30).padding(.all, 1)
                }
                else {
                    Text(details).opacity(0).padding(.all, 8)
                }
                
            }
            .shadow(radius: 1)
            
            HStack{
                Text("Current status:")
                Picker("", selection: $status) {
                    ForEach (Statuses.allCases) { key in
                        Text(statuses[key.rawValue]!.name.capitalized)
                            .tag(key)
                    }
                }.pickerStyle(.menu)
                
            }
            
            LazyHStack{
                Toggle(isOn: $hasDueDate) {
                    
                }.toggleStyle(.switch)
                if (!hasDueDate) {
                    Text("No due date")
                }
                else {
                    DatePicker(
                        "Due",
                        selection: $due,
                        in: created...,
                        displayedComponents: [.date, .hourAndMinute]
                    )
                }
            }
            
            Spacer()
        }
        .navigationBarItems(trailing: Button(action: {
            updateItem()
        }){
            Text("Done")
        }
        )
        .navigationBarBackButtonHidden(true)
        .navigationBarItems(leading: Button(action: {
            self.presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "arrow.left")
            Text("Cancel")
        }
        )
    }
    
    func updateItem() {
        print ("creating item: \(name)")
        let item: Item = self.item ?? Item(context: managedObjectContext)
        
        let mutatedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let mutatedDetails = details.trimmingCharacters(in: .whitespacesAndNewlines)
        let mutatedStatus = status.rawValue
        
        
        guard !mutatedName.isEmpty else {
            print("empty name given... fail")
            dismiss()
            return
        }
        item.name = mutatedName
        if !mutatedDetails.isEmpty {
            item.details = mutatedDetails
        }
        item.status = mutatedStatus
        if isNewItem {
            item.created = created
        }
        if hasDueDate {
            item.due = due
        }
        else {
            item.due = nil
        }
        item.toCategory = category
        
        PersistenceController.shared.save()
        print("sucessfully created item: \(mutatedName)")
        dismiss()
        return
        
    }
    
    func dismiss() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

