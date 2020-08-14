//
//  ProgressView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/25/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI
import CoreData

struct ProgressView: View {
    
    @FetchRequest(entity: Rounds.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Rounds.roundDate, ascending: false)]) var roundData: FetchedResults<Rounds>
    @FetchRequest(entity: Days.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Days.dayDate, ascending: false)]) var dayData: FetchedResults<Days>
    
    @State var totalDays = [String]()
    @State var totalDay = 0
    @State var todayRound = 0
    @State var averageRound = 0.0
    
    var dateFormatter : DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        return formatter
    }
    
    var body: some View {

        VStack{
            VStack{
                HStack(spacing: 10){
                    VStack{
                        Text("Today").font(.title).bold()
                        Text("\(self.todayRound)").font(.title).bold().padding()
                    }.padding()
                    
                    VStack{
                        Text("Average").font(.title).bold()
                        if self.totalDays.count == 0 {
                            Text("\(self.roundData.count)").font(.title).bold().padding()
                        }else{
                            Text(String(format: "%.1f", self.averageRound)).font(.title).bold().padding()
                        }
                    }.padding()
                }
                
                ZStack{

                    todayCircle(rounds: CGFloat(todayRound))
                    avgCircle(rounds: CGFloat(self.averageRound))

                    
                }.frame(height: UIScreen.main.bounds.height/3)
                
                
                HStack{
                    Capsule().fill(Color(red: 255/255, green: 102/255, blue: 0/255)).frame(width: 5, height: 5)
                    Text("Today")
                    
                    Capsule().fill(Color.green).frame(width: 5, height: 5)
                    Text("Avg.")
                }
                Spacer()
            }
           
        }
        .navigationBarTitle("Progress")
        .onAppear(perform: getTodayRounds)
    }
    
    func getTodayRounds(){
        let today = self.dateFormatter.string(from: Date())

        for i in self.dayData{
            if !self.totalDays.contains(self.dateFormatter.string(from: i.dayDate!)){
                self.totalDays.append(self.dateFormatter.string(from: i.dayDate!))
                self.totalDay += 1
            }
        }

        for i in self.roundData{
            if self.dateFormatter.string(from: i.roundDate!) == today{
                self.todayRound += 1
            }
        }
        self.totalDay =  self.totalDays.count
        self.averageRound = Double(self.roundData.count) / Double(self.totalDay)


    }
}

struct todayCircle: View{
    var rounds: CGFloat = 0
    
    var body: some View{
        ZStack{
            Circle().trim(from: 0, to: 1)
                .stroke(Color(red: 255/255, green: 102/255, blue: 0/255).opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
            .frame(width: 200, height: 200).aspectRatio(contentMode: .fit)
            
            Circle().trim(from: 0, to: rounds/50)
                .stroke(Color(red: 255/255, green: 102/255, blue: 0/255), style: StrokeStyle(lineWidth: 15, lineCap: .round)).rotationEffect(.degrees(-90))
            .frame(width: 200, height: 200).aspectRatio(contentMode: .fit)
        }
    }
}

struct avgCircle: View{
    var rounds : CGFloat = 0
    
    var body: some View{
        ZStack{
            Circle().trim(from: 0, to: 1)
                .stroke(Color.green.opacity(0.2), style: StrokeStyle(lineWidth: 15, lineCap: .round))
            .frame(width: 160, height: 160).aspectRatio(contentMode: .fit)
            
            Circle().trim(from: 0, to: rounds/50)
                .stroke(Color.green, style: StrokeStyle(lineWidth: 15, lineCap: .round)).rotationEffect(.degrees(-90))
            .frame(width: 160, height: 160).aspectRatio(contentMode: .fit)
        }
    }
}



struct ProgressView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressView()
    }
}
