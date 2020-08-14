//
//  TaskView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/12/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import Foundation
import SwiftUI
import UIKit


//MARK:- Task View
struct TaskView: View {

    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Tasks.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \Tasks.dateAdded, ascending: false)]) var tasks: FetchedResults<Tasks>
    
    
    var body: some View{
        NavigationView{
            ZStack{
                List{
                    ForEach(tasks, id: \.self){ task in
                        CustomRow(task: task)
                    }
                .onDelete(perform: deleteTask)
                }
                
                VStack{
                    Spacer()
                    HStack{
                        Spacer()
                        NavigationLink(destination: AddTaskView()){
                            Image(systemName: "plus.circle.fill").font(.system(size: 35)).foregroundColor(Color(#colorLiteral(red: 1, green: 0.4712187888, blue: 0.1095939164, alpha: 1))).imageScale(.large).padding(20)
                                .shadow(color: Color.gray, radius: 3, y:1)
                        }
                    }
                }
            }

            .animation(.easeOut)
            .onAppear{
                UITableView.appearance().separatorStyle = .none
            }
            .navigationBarTitle("Tasks")
        }
    }
    
    func deleteTask(at index: IndexSet){
        for i in index{
            let task = tasks[i]
            moc.delete(task)
        }
        try? moc.save()
    }
}

// MARK:- Custom Row View

struct CustomRow: View{
    @Environment(\.managedObjectContext) var moc
    var task: Tasks
    static let dateFormate: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()

    
    var body: some View{
                
        HStack{
            VStack(alignment: .leading){
                Text(task.title!).font(.system(size: 25)).lineLimit(1)
                Text(task.desc!).font(.system(size: 20)).lineLimit(1).foregroundColor(Color.gray)
                Text("\(task.dateAdded!, formatter: Self.dateFormate)").font(.system(size: 15)).foregroundColor(Color.gray)
                Divider()
            }
            Spacer()

            Image(systemName: "circle").imageScale(.large).onTapGesture {
                self.moc.delete(self.task)
                try? self.moc.save()
            }
        }.padding(.bottom, 8)
        
    }
}


