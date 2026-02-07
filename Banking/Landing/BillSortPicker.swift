//
//  BillSortPicker.swift
//  Banking
//
//  Created by John Endres on 2/7/26.
//

import SwiftUI

/// A menu for selecting how to sort bills.
struct BillSortPicker: View {
    /// The currently selected sort option.
    @Binding var sortOption: BillSortOption
    
    /// Whether to sort in ascending order.
    @Binding var ascending: Bool
    
    var body: some View {
        Menu {
            ForEach(BillSortOption.allCases) { option in
                Button {
                    if sortOption == option {
                        ascending.toggle()
                    } else {
                        sortOption = option
                        ascending = true
                    }
                } label: {
                    Label {
                        HStack {
                            Text(option.rawValue)
                            
                            if sortOption == option {
                                Spacer()
                                Image(systemName: ascending ? "chevron.up" : "chevron.down")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    } icon: {
                        if sortOption == option {
                            Image(systemName: "checkmark")
                        } else {
                            Image(systemName: option.icon)
                        }
                    }
                }
            }
            
            Divider()
            
            Button {
                ascending.toggle()
            } label: {
                Label(ascending ? "Ascending" : "Descending", systemImage: ascending ? "chevron.up" : "chevron.down")
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down.circle")
        }
    }
}

#Preview {
    @Previewable @State var sortOption = BillSortOption.dueDate
    @Previewable @State var ascending = true
    
    NavigationStack {
        List {
            Text("Sample Content")
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                BillSortPicker(sortOption: $sortOption, ascending: $ascending)
            }
        }
    }
}
