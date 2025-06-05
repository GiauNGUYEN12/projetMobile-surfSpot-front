//
//  DestinationMenuView.swift
//  surfSpot-front
//
//  Created by Giau Nguyen on 20/05/2025.
//

import SwiftUI

struct DestinationMenuView: View {

    @State private var records: [MyRecord] = []

    var body: some View {
        NavigationStack {
            List($records) { record in
                NavigationLink {
                    RecordDetailView(record: record)
                } label: {
                    HStack {

                        AsyncImage(url: URL(string: record.wrappedValue.photo_url))
                        { result in
                            result.image?
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 50, height: 50)
                        }
                        .padding(.leading,5)
                        VStack(alignment: .leading) {
                            Text(record.wrappedValue.destination)
                                .font(.title3)
                                .fontWeight(.bold)
                            
                            Text(record.wrappedValue.country)
                        }.padding(10)
                    }
                }
                
            }
            .onAppear {
                Task {
                    await fetchData()
                }
            }
            .navigationTitle("Destinations 🏄🏼‍♀️")
        }
    }

    func fetchData() async {
        guard let url = URL(string: "http://localhost:4000/surfSpots") else {
            print("URL invalide")
            return
        }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            print(String(decoding: data, as: UTF8.self))
            let decoded = try JSONDecoder().decode([MyRecord].self, from: data)
            self.records = decoded
            print("Spots décodés :", decoded.count)
        } catch {
            print("Erreur de chargement: \(error)")
        }
    }
}

#Preview {
    DestinationMenuView()
}

