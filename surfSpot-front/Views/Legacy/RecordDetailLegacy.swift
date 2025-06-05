//
//  RecordDetailLegacy.swift
//  surfSpot
//
//  Created by Giau Nguyen on 06/05/2025.
//

import SwiftUI

struct LabelView: View {
    var label: String
    var value: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text("\(label):")
                .font(.title2)
                .fontWeight(.bold)
            Text(value)
                .font(.title2)
                .lineLimit(nil)
        }
    }
}

struct RecordDetailLegacy: View {
    @Binding var record: MyRecordLegacy
    var body: some View {
        VStack {
            AsyncImage(
                url: record.photoURLs.first,
                content: { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 300, height: 300)
                        .scaledToFill()
                        .imageScale(.small)
                        .clipShape(Circle())
                        .overlay {
                            Circle().stroke(.white, lineWidth: 4)
                        }
                        .shadow(radius: 7)
                },
                placeholder: {
                    ProgressView()
                }
            )
            .padding(.bottom, 50)
            
            VStack(alignment: .leading, spacing: 8){
                LabelView(label: "Destination", value: record.destination)
                LabelView(label: "Surf Break", value: record.surfBreak.joined(separator: ", "))
                LabelView(label: "Adresse", value: record.address)
                LabelView(label: "Difficulty Level", value: "\(record.difficultyLevel)")
            }
            Spacer()
        }.padding()
        
        
    }
}
