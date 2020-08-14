//
//  AddTaskView.swift
//  studyfocus
//
//  Created by Jongmin Lee on 7/15/20.
//  Copyright © 2020 Jongmin Lee. All rights reserved.
//

import SwiftUI

struct AddTaskView: View {
    @State var toDo = []
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode
    
    @State private var newTitle = ""
    @State private var newDesc = ""
    @State private var newDay = Date()
    
    @State private var textHide = false
    
    var body: some View {
        ScrollView{
            
            VStack{
                VStack{
                    Text("Task Name").font(.system(size: 30)).bold()
                    TextField("Enter a task name..", text: $newTitle).frame(width: UIScreen.main.bounds.width-40, alignment: .center)
                    Divider().frame(width: UIScreen.main.bounds.width-40, height: 1, alignment: .center).background(Color(red: 255/255, green: 102/255, blue: 0/255))
                }.padding()
                
                VStack{
                    Text("Note").font(.system(size: 30)).bold()
                    TextField("Optional..", text: $newDesc).frame(width: UIScreen.main.bounds.width-40, alignment: .center)
                    Divider().frame(width: UIScreen.main.bounds.width-40, height: 1, alignment: .center).background(Color(red: 255/255, green: 102/255, blue: 0/255))
                }.padding()
                
                 
                Button(action:{
                    if self.newTitle == ""{
                        self.textHide = true
                    }else{
                        let newTask = Tasks(context: self.moc)
                        newTask.title = self.newTitle
                        newTask.desc = self.newDesc
                        newTask.dateAdded = Date()
                        
                        try? self.moc.save()
                        self.presentationMode.wrappedValue.dismiss()
                    }
                    
                }){
                    ZStack{
                        RoundedRectangle(cornerRadius: 15).frame(width: 200, height: 50, alignment: .center).foregroundColor(Color(red: 255/255, green: 102/255, blue: 0/255))
                        Text("Add").font(.system(size: 20)).bold().foregroundColor(Color(UIColor.systemBackground))
                    }
                

                }.padding()
                Text("Enter a task name, please").opacity(self.textHide ? 1 : 0)
                Spacer()
            }
        .navigationBarTitle("Add Task")
        }
    }
    

}

struct AddTaskView_Previews: PreviewProvider {
    static var previews: some View {
        AddTaskView()
    }
}
