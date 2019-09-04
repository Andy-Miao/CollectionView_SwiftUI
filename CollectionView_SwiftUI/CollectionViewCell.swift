//
//  CollectionViewCell.swift
//  CollectionView_SwiftUI
//
//  Created by humiao on 2019/9/4.
//  Copyright © 2019 syc. All rights reserved.
//

import SwiftUI

struct CollectionViewCell: View {
    var text: String
    @Binding var selectedItem: Int?
    let index: Int
    
    var isSelected: Bool {
        if let selectedItem = selectedItem, selectedItem == index {
            return true
        }else {
            return false
        }
    }
    
    var body: some View {
         Button(action: {
                   self.selectedItem = self.index
               }) {
                   Text(self.text)
                       .lineLimit(1)
                       .foregroundColor(self.isSelected ? Color.white : Color.blue)
                       .padding(.horizontal, 20)
                       .padding(.vertical, 10)
                       .border(Color.blue, width: 1)
                       .anchorPreference(key: MyAnchorPreferenceKey.self, value: .bounds, transform: {
                           [MyAnchorPreferenceData(viewIdx: self.index, bounds: $0)] })
               }.background(self.isSelected ? Color.blue : Color.white)
    }
}

//MARK: - Helper with Preferences
struct MyAnchorPreferenceData: Equatable {
    static func == (lhs: MyAnchorPreferenceData, rhs: MyAnchorPreferenceData) -> Bool {
        return lhs.viewIdx == rhs.viewIdx
    }
    let viewIdx: Int
    let bounds: Anchor<CGRect>
}


struct MyAnchorPreferenceKey: PreferenceKey {
    typealias Value = [MyAnchorPreferenceData]
    
    static var defaultValue: [MyAnchorPreferenceData] = []
    
    static func reduce(value: inout [MyAnchorPreferenceData], nextValue: () -> [MyAnchorPreferenceData]) {
        value.append(contentsOf: nextValue())
    }
}


//struct CollectionViewCell_Previews: PreviewProvider {
//    static var previews: some View {
//        CollectionViewCell()
//    }
//}
