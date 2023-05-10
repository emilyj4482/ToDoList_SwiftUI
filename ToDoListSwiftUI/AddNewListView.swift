//
//  AddNewListView.swift
//  ToDoListSwiftUI
//
//  Created by EMILY on 2023/05/10.
//

import SwiftUI

struct AddNewListView: View {
    
    @State var listName: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    print("Cencel btn tapped")
                } label: {
                    Text("Cancel")
                }
                Spacer()
            }
            .padding()
            TextField("Untitled List", text: $listName)
                .font(.system(.largeTitle, weight: .black))
                .padding(.leading, 15)
            Spacer()
        }
        .navigationBarBackButtonHidden()
    }
}

struct AddNewListView_Previews: PreviewProvider {
    static var previews: some View {
        AddNewListView()
    }
}
