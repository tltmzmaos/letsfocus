//
//  MainView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/12/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI
import Combine


struct MainView: View{

    @ObservedObject var newQuote = QuoteFetch()


    @State var images = [UIImage(named: "b1"),UIImage(named: "b2"),UIImage(named: "b3"),UIImage(named: "b4"),UIImage(named: "b5")
    ,UIImage(named: "b6"), UIImage(named: "b7"), UIImage(named: "b8"), UIImage(named: "b9"), UIImage(named: "b10"),
    UIImage(named: "b11"),UIImage(named: "b12"),UIImage(named: "b13"),UIImage(named: "b14"),UIImage(named: "b15")
    ,UIImage(named: "b16"), UIImage(named: "b17"), UIImage(named: "b18"), UIImage(named: "b19"), UIImage(named: "b20"),
    UIImage(named: "b21"),UIImage(named: "b22"),UIImage(named: "b23"),UIImage(named: "b24"),UIImage(named: "b25")
    ,UIImage(named: "b26"), UIImage(named: "b27"), UIImage(named: "b28"), UIImage(named: "b29"), UIImage(named: "b30"),
    UIImage(named: "b31"),UIImage(named: "b32"),UIImage(named: "b33"),UIImage(named: "b34"),UIImage(named: "b35")
    ,UIImage(named: "b36"), UIImage(named: "b37"), UIImage(named: "b38"), UIImage(named: "b39"), UIImage(named: "b40"),
    UIImage(named: "b41"),UIImage(named: "b42"),UIImage(named: "b43"),UIImage(named: "b44"),UIImage(named: "b45")
    ,UIImage(named: "b46"), UIImage(named: "b47"), UIImage(named: "b48"), UIImage(named: "b49"), UIImage(named: "b50")]
    
    @State var randomIndex = Int.random(in: 0..<10)
    
    var body: some View{
        ZStack{
            Image(uiImage: images[randomIndex]!).frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height).blur(radius: 1.5)
            VStack{
                Text(self.newQuote.quote.count > 0 ? "\(newQuote.quote[randomIndex].q)": "try again later").font(.system(size: 35)).italic().padding().multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
            Text("\(newQuote.quote[randomIndex].a)")
                }
            .onAppear(perform: randIndex)
        }.foregroundColor(Color.white)
    }
    
    func randIndex(){
        randomIndex = Int.random(in: 0..<newQuote.quote.count)
    }
    
}





