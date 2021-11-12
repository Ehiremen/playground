//
//  ContentView.swift
//  ToDoList
//
//  Created by Ehiremen Ekore on 10/10/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        NavigationView{
            ListCategoriesView()
                .navigationBarTitle("", displayMode: .inline)
        }
    }
}
