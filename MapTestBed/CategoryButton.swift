//
//  CategoryButton.swift
//  MapTestBed
//
//  Created by Joseph Jung on 11/16/22.
//

import SwiftUI

struct CategoryButton: View {
    
    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var appState: AppState

    var name:String
    
    @State var isPressed: Bool = false
    @Binding var search: String
    @Binding var showSearchResultsList: Bool
    @Binding var selectedCategory: String

    var body: some View {
        Button(name, action:
        {
            search = name
            appState.categoryOfInterest = name
            searchVM.search(query: search) {   landmarks in
                appState.landmarks = landmarks
            }
            showSearchResultsList = true
            selectedCategory = name
//            isPressed.toggle()
        })
        .textFieldStyle(RoundedBorderTextFieldStyle())
        .background(selectedCategory == name ? Color(#colorLiteral(red: 0.4982050061, green: 0.5490344763, blue: 0.5528618097, alpha: 1)) : Color(#colorLiteral(red: 0.9254772663, green: 0.9412199855, blue: 0.9449794888, alpha: 1)))
        .foregroundColor(selectedCategory == name ? Color.white: Color(#colorLiteral(red: 0.204610765, green: 0.2861392498, blue: 0.3685011268, alpha: 1)))
        .clipShape(RoundedRectangle(cornerRadius: 16.0, style: /*@START_MENU_TOKEN@*/.continuous/*@END_MENU_TOKEN@*/))

//        .cornerRadius(5)
//        .shadow(radius: 10)
    }
}

//struct CategoryButton_Previews: PreviewProvider {
//    static var previews: some View {
//        CategoryButton(name:"",isPressed: .constant(.false), search: <#T##Binding<String>#> )
//    }
//}
