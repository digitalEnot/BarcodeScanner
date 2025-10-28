//
//  TagsView.swift
//  BarcodeScanner
//
//  Created by Evgeni Novik on 28.10.2025.
//

import SwiftUI

struct TagsView: View {
    
    let tags: [String]
    @State var tagRows: [[String]] = []
    
    var body: some View {
        GeometryReader { geometry in
            VStack(alignment: .leading) {
                ForEach(tagRows, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(row, id: \.self) { tag in
                            Text(tag)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background {
                                    Capsule()
                                        .fill(.gray.opacity(0.3))
                                }
                                .fixedSize()
                        }
                    }
                }
            }
            .padding(.vertical, 8)
            .onAppear {
                calculateRows(for: geometry.size.width)
            }
        }
    }
    
    private func calculateRows(for availableWidth: CGFloat) {
        tagRows = []
        var currentRow: [String] = []
        var currentRowWidth: CGFloat = 0
        for tag in tags {
            let tagWidth = tag.calculateWidth(usingFont: .systemFont(ofSize: 16)) + 16
            if currentRowWidth + tagWidth <= availableWidth {
                currentRow.append(tag)
                currentRowWidth += tagWidth
            } else {
                tagRows.append(currentRow)
                currentRow = [tag]
                currentRowWidth = tagWidth
            }
        }
        
        if !currentRow.isEmpty {
            tagRows.append(currentRow)
        }
    }
}

extension String {
    func calculateWidth(usingFont font: UIFont) -> CGFloat {
        let textWidth = (self as NSString).size(withAttributes: [.font: font]).width
        let paddingWidth = 24
        return textWidth + CGFloat(paddingWidth)
    }
}

#Preview {
    TagsView(tags: ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten"])
}
