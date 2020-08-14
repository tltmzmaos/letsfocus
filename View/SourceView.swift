//
//  SourceView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/20/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI

struct SourceView: View {
    var body: some View {
        ScrollView{
            //Text("Source").font(.largeTitle).bold()
            VStack{
                Button(action:{
                    UIApplication.shared.open(URL(string: "https://en.wikipedia.org/wiki/Pomodoro_Technique")!)
                }){
                    Image(uiImage: UIImage(named: "wikilogo")!)
                }
                
                Divider().frame(width: UIScreen.main.bounds.width/3)
                
                Button(action:{
                    UIApplication.shared.open(URL(string: "https://zenquotes.io/")!)
                }){
                    Text("ZenQuotes").font(.system(size: 30))
                }.padding()
                
                Divider().frame(width: UIScreen.main.bounds.width/3)
                
                Button(action:{
                    UIApplication.shared.open(URL(string: "https://pixabay.com/")!)
                }){
                    Image(uiImage: UIImage(named: "pixalogo")!)
                }.padding()
                
                Divider().frame(width: UIScreen.main.bounds.width/3)
                
                Button(action:{
                    UIApplication.shared.open(URL(string: "https://www.flaticon.com/")!)
                }){
                    Text("flaticon").font(.system(size: 30))
                }.padding()
                
                Spacer()
            }
        .navigationBarTitle("Source")
        }
    }
}

struct SourceView_Previews: PreviewProvider {
    static var previews: some View {
        SourceView()
    }
}
