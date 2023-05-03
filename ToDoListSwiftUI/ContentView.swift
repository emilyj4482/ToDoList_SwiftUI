//
//  ContentView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/01.
//

import SwiftUI

struct ContentView: View {
    
    var count: Int = 0
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    NavigationLink {
                        Text("Important")
                    } label: {
                        HStack {
                            Image(systemName: "star.fill")
                            Text("Important")
                        }
                    }
                }
                Text("You have \(count) custom list.")
                    .font(.system(size: 13))
                    .foregroundColor(.pink)
                    .padding(.bottom, 3)
                NavigationLink {
                    Text("Add a List")
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("New List")
                    }
                    .tint(.pink)
                }
            }
            .navigationTitle("ToDoList")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
