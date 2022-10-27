//
//  ButtonUIStack.swift
//  MapTestBed
//
//  Created by Joseph Jung on 10/26/22.
//

import SwiftUI

struct ButtonUIStack: View {
    
    @EnvironmentObject var searchVM: SearchResultsViewModel
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings
    
    @State var search: String = ""
    @State var showSearchResultsList = false
    
    var body: some View {
        Text("button stack")
    }
}

struct ButtonUIStack_Previews: PreviewProvider {
    static var previews: some View {
        ButtonUIStack()
    }
}
