//
//  FlowCollectionView.swift
//  CollectionView_SwiftUI
//
//  Created by humiao on 2019/9/4.
//  Copyright © 2019 syc. All rights reserved.
//

import SwiftUI

struct FlowCollectionView: View {
    
    init(data: [String], selectedItem: Binding<Int?>) {
        self.data = data
        self._selectedItem = selectedItem
        //need to set datatPostion with number of data entries
        //we will modify this according to the space we have
        let count = data.count - 1
        var myArray = [Int]()
        for i in 0 ... count {
            myArray.append(i)
        }
        self._dataPosition = State(initialValue: [myArray])
    }
    
    //Note: your can rewrite this be directly giving the collectionview the cells
     //add the preference to the cells:
     //.anchorPreference(key: MyAnchorPreferenceKey.self, value: .bounds, transform: {
     //[MyAnchorPreferenceData(viewIdx: self.idx, bounds: $0)] })
    
     var data: [String]  //given by parent view
     var viewArray: [CollectionViewCell] {
         var index: Int = 0
         var array = [CollectionViewCell]()
         for text in data {
             let view = CollectionViewCell(text: text, selectedItem: $selectedItem, index: index)
             array.append(view)
             index += 1
         }
         return array
     }
    
    @State var dataPosition: [[Int]]
    @Binding var selectedItem: Int?
    
    var body: some View {
        //need scrollview otherwise cellviews will be compressed
        ScrollView(.horizontal, showsIndicators: false) {
            VStack {
                ForEach(dataPosition, id: \.self) { (row)  in
                    
                    HStack{
                        ForEach(row, id: \.self) { item in
                            self.viewArray[item]
                        }
                    }
                }
            }
            
        }
            //this will get the preferences(including bounds of our cells) and call makeViewPositions
        .backgroundPreferenceValue(MyAnchorPreferenceKey.self) { preferences in
            return GeometryReader { geometry in
                    self.makeViewPosition(geometry, preferences)
            }
        }
    }
    
    func makeViewPosition(_ geometry: GeometryProxy, _ preferences: [MyAnchorPreferenceData]) -> some View {
      
        let widthOfWindow = geometry.size.width //the space we have avaliable
        
        var widthOfViews: CGFloat = 0  //helper store
        var flatArray = dataPosition.flatMap { $0 } // easier to reference as 1D
        var newArray = [[Int]]()
        
        for p in preferences {
            let bounds = geometry[p.bounds]  //gives size of each cell
            widthOfViews += bounds.size.width   //we add the cell widths together
            if widthOfViews > widthOfWindow {
                 //until they fill the whole screen width
                let new = flatArray.filter { $0 < p.viewIdx }
                newArray.append(new)  // creates a new row
                flatArray = flatArray.filter { $0 >= p.viewIdx } //only keep the not set cells for iteration
                widthOfViews = bounds.size.width
            }
        }
        newArray.append(flatArray)  // all the rest, these row will not be full screen width
        
        DispatchQueue.main.async {
            // we are calling this func in backgroundPreferenceValue
            //during with the views will be rendered, so we need to force a waitng
            //not a preety solution
            self.dataPosition = newArray
        }
        
        //return an empty view, but you could add whatever you want here use geometry and bounds of cells
        return Rectangle()
            .frame(width: 0, height: 0)
            .background(Color.clear)
        
    }
}

//struct FlowCollectionView_Previews: PreviewProvider {
//    static var previews: some View {
//        FlowCollectionView()
//    }
//}
