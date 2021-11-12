//
//  ItemsInCategoryView.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/24/21.
//

import SwiftUI

struct ItemsInCategoryView: View {
    @Environment(\.managedObjectContext) private var managedObjectContext
    
    @FetchRequest(
        entity: Item.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.name, ascending: true)])
    private var items: FetchedResults<Item>
    
    @FetchRequest(
        entity: Category.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Category.name, ascending: true)])
    private var categories: FetchedResults<Category>
    
    let category: Category
    private let statuses: [String:Status] = Utils.statusDict
    private let dateFormatter = Utils.shortDateShortTime
    
    
    enum SortOptions: String, CaseIterable, Identifiable {
        case name
        case created
        case due
        case status
        
        var id: String { self.rawValue }
    }
    @State var sortBy: SortOptions = SortOptions.name
    
    enum FilterOptions: String, CaseIterable, Identifiable {
        case all
        case ns
        case ip
        case co
        case gu
        
        var id: String { self.rawValue }
    }
    let filterDict: [FilterOptions: String] = [
        .all : "all",
        .ns : "not started",
        .ip : "in progress",
        .co : "completed",
        .gu : "given up"
    ]
    @State var filterBy: FilterOptions = FilterOptions.all
    
    
    init(category: Category) {
        self.category = category
    }
    
    var body: some View {
        
        VStack {
            List {
                //                ForEach(items, id:\.self) { item in
                ForEach(items
                            .sorted(by: { item1, item2 in
                    switch sortBy {
                    case .name:
                        return item1.name! < item2.name!
                    case .created:
                        return item1.created! < item2.created!
                    case .due:
                        if item1.due != nil && item2.due != nil {
                            return item1.due! < item2.due!
                        }
                        else {
                            return item1.due != nil
                        }
                    case .status:
                        return item1.status! < item2.status!
                    }
                })
                            .filter({ item1 in
                    switch filterBy {
                    case .all:
                        return true
                    case .ns:
                        return item1.status == FilterOptions.ns.rawValue
                    case .ip:
                        return item1.status == FilterOptions.ip.rawValue
                    case .co:
                        return item1.status == FilterOptions.co.rawValue
                    case .gu:
                        return item1.status == FilterOptions.gu.rawValue
                    }
                })) { item in
                    if item.toCategory == category {
                        NavigationLink(destination: ItemDetailView(category: category, item: item)){
                            HStack {
                                Circle()
                                    .fill(statuses[item.status!]!.color)
                                    .frame(width: 20, height: 20)
                                
                                VStack (alignment: .leading, spacing: 5) {
                                    Text(item.name!)
                                        .fontWeight(.semibold)
                                        .lineLimit(1)
                                        .minimumScaleFactor(1)
                                    if item.due != nil {
                                        HStack{
                                            Image(systemName: "alarm")
                                            Text("\(dateFormatter.string(from: item.due!))")
                                                .font(.subheadline)
                                                .foregroundColor(.secondary)
                                        }
                                        
                                    }
                                }
                                
                            }
                            
                        }
                    }
                }.onDelete(perform: removeItem)
            }
        }
        
        Spacer()
        
        ZStack {
            HStack {
                HStack {
                    Image(systemName: "arrow.up.arrow.down")
                    Picker("", selection: $sortBy) {
                        ForEach (SortOptions.allCases) { key in
                            Text(key.rawValue.capitalized)
                                .tag(key)
                        }
                    }.pickerStyle(.menu)
                }
                
                Spacer()
                
                HStack {
                    Text("Show: ")
                    Picker("", selection: $filterBy) {
                        ForEach (FilterOptions.allCases) { key in
                            Text(filterDict[key]!.capitalized)
                                .tag(key)
                        }
                    }.pickerStyle(.menu)
                }
            }.padding(10)
            
        }
        
        
        
        .navigationBarItems(leading: NavigationLink(
            destination: ListCategoriesView()
        ){
            Text("Categories")
        }, trailing:
                                NavigationLink(destination: ItemDetailView(category: category)){
            Text("New item")
        }
        )
        
        .navigationBarTitle(category.name!, displayMode: .inline)
        .navigationBarBackButtonHidden(true)
        
    }
    
    func removeItem(at offsets: IndexSet) {
        for index in offsets {
            let item = items[index]
            PersistenceController.shared.delete(item)
        }
    }
}

