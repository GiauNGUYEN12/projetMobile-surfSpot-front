//
//  ContentView.swift
//  surfSpot
//
//  Created by Giau Nguyen on 05/05/2025.
//

import SwiftUI
struct RecordsDTO: Codable{
    let records: [RecordDTO]
}

struct RecordDTO: Identifiable, Codable {
    let id: String
    let fields: FieldsDTO

}

struct FieldsDTO: Codable {
    let destination: String
    let address: String
    let surfBreak: [String]
    let difficultyLevel: Int
    let country: String
    let photos: [PhotosDTO]
    
    enum CodingKeys: String, CodingKey {
        case destination = "Destination"
        case address = "Address"
        case surfBreak = "Surf Break"
        case difficultyLevel = "Difficulty Level"
        case photos = "Photos"
        case country = "Destination State/Country"
    }
}

struct PhotosDTO: Codable {
    let url: String
    
    enum CodingKeys: String, CodingKey {
        case url = "url"
    }
}


struct DestinationsMenuLegacy: View {
    @State var records: [MyRecordLegacy] = []
    var body: some View {
        NavigationStack {
            //HStack {
                List (self.$records){ record in
                    NavigationLink {
                        RecordDetailLegacy(record: record)
                    } label: {
                        HStack {
                            AsyncImage(url: record.wrappedValue.photoURLs.first!)
                            { result in
                                result.image?
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 50, height: 50)
                                    //.scaledToFill()
                            }
                            //.frame(width: 50, height: 50)
                            .padding(.leading,5)
                            VStack(alignment: .leading) {
                                Text(record.destination.wrappedValue)
                                    .font(.title3)
                                    .fontWeight(.bold)
                                
                                Text(record.country.wrappedValue)
                            }.padding(10)
                        }
                    }
                }
                .navigationTitle("Destinations 🏄🏼‍♀️")
                //Text("Hello, World!" + String(records.count))
            //}
            .task {
                await self.fetchData()
            }
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://api.airtable.com/v0/appxT9ln6ixuCb3o1/Surf%20Destinations" ) else {
            return
        }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("Bearer patyFkst3N4d14pKy.3bd625bd292da0e033a57ea2a523ab2b13bfdc912c715ca1efc2eb0eb2a7d7bc", forHTTPHeaderField: "Authorization")
        
        guard let (data, _) = try?  await URLSession.shared.data(for: urlRequest) else {
            return
        }
        //print(String(data: data, encoding: .utf8))
        
        guard let records = try? JSONDecoder().decode(RecordsDTO.self, from: data) else {
            return
        }
        print(records)
        self.records = records.records.map { dto in
            MyRecordLegacy(dto)
        }
    }
}

#Preview {
    DestinationsMenuLegacy()
}
