//
//  ContentView.swift
//  CollectionView_SwiftUI
//
//  Created by humiao on 2019/9/4.
//  Copyright © 2019 syc. All rights reserved.
//  swiftUI 教程：https://developer.apple.com/tutorials/swiftui/creating-and-combining-views

import SwiftUI

/// MARK: listCell
struct ListCell: View {
    var text: String
    let index: Int
    @Binding var selectedItem: Int?
    var isSelcted: Bool {
        if let selectedItem = selectedItem, selectedItem == index  {
            return true
        }
        return false
    }
    
    
    var body: some View {
        Button(action: {
            self.selectedItem = self.index
        }) {
            Text(text)
            .lineLimit(1)
//            .font(.system(size: 15))
            .foregroundColor(isSelcted ? Color.white : Color.blue)
            .padding(.horizontal, 5)
            .padding(.vertical, 10)
            .border(Color.blue, width: 1)
        }.background(isSelcted ? Color.blue : Color.white)
    }
    
    
}

struct CollectionView: View {
    var data: [String]
    var numberOfColumns: Int
    
    @Binding var selectedItem: Int?
    @State var dataPosition: [[Int]] //view ownes the layout
    
    init(data: [String], numberOfColumns: Int, selectedItem: Binding<Int?>) {
        self.data = data
        self.numberOfColumns = numberOfColumns
        self._selectedItem = selectedItem
        //need to set datatPostion with number of data entries
        let count = data.count - 1
        var myArray = [[Int]]()
        var dummyArray = [Int]()
        var index = 0
        
        for i in 0 ..< count {
            if (index < numberOfColumns) {
                dummyArray.append(i)
                index += 1
            } else {
                myArray.append(dummyArray)
                dummyArray = [i]
                index = 1
            }
        }
        myArray.append(dummyArray) //finishing last one
        
        self._dataPosition = State(initialValue: myArray)
    }
    
    var body: some View {
            VStack(alignment: .center){
                
                ForEach(dataPosition, id: \.self) { row  in
                    HStack {
                        ForEach(row, id: \.self) { item in
                            ListCell(text: self.data[item], index: item, selectedItem:
                                self.$selectedItem)
                            
                        }
                    }
                }
            }
        }
}

struct ContentView: View {
    
    var data: [String] = {
        return ["string 1","string 2","string 3","string 4","string 5","string 6","string 7", "string 8","string 9","string 10"]
    }()

  @State var selectedItem: Int? = nil
  @State var selectedCollectionItem: Int? = nil
  @State var selectedCollectionItem2: Int? = nil
    
    var body: some View {
        VStack( spacing: 5) {
            HStack {
                //MARK: CollectionView with fixed column number
                VStack {
                    Text("you selected: \(data[selectedItem ?? 0])")
                    CollectionView(data: data, numberOfColumns: 2, selectedItem: $selectedItem)
                }.padding().border(Color.gray)
                
                ScrollView(.vertical) {
                    Text("scrollable area")
                    CollectionView(data: data, numberOfColumns: 2, selectedItem: $selectedItem)
                }.frame(width: 300, height: 100, alignment: .center).padding().border(Color.gray)
                //use flexible frame to use all space like
                //                    //   .frame(minWidth: 0, idealWidth: 200, maxWidth: .infinity, minHeight: 0, idealHeight: 200, maxHeight: 200, alignment: .center)

            }
            //MARK: Flowlayout
            HStack {
                VStack {
                    Text("FlowLayout will update when rotated ")
                    Text("because of flexible bounds")
                    if selectedCollectionItem != nil {
                        Text("you selected: \(data[selectedCollectionItem!])")
                    }
                    FlowCollectionView(data: data, selectedItem: $selectedCollectionItem).padding()
                }.border(Color.gray)
                
                VStack{
                    Text("FlowLayout with fixed frame")
                    if selectedCollectionItem2 != nil {
                        Text("you selected: \(data[selectedCollectionItem2!])")
                    }
                    
                    FlowCollectionView(data: data, selectedItem: $selectedCollectionItem2).padding()
                        .frame(width: 350, height: 300, alignment: .center)
                        .border(Color.gray)
                }  .border(Color.gray)
            }
        }.padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
