//
//  ContentView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/12/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @State var selection = 0
    var body: some View {
        TabView(selection: $selection){
            
            TimerView().tabItem{
                Image(systemName: "timer")
                Text("Timer")
            }.tag(0)
            
            MainView().tabItem{
                Image(systemName: "quote.bubble")
                Text("Quote")
            }.tag(1)
            
            TaskView().tabItem{
                Image(systemName: "checkmark")
                Text("ToDo")
            }.tag(2)
            

            SettingView().tabItem{
                Image(systemName: "ellipsis")
                Text("More")
            }.tag(3)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
