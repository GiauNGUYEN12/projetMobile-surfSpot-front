//
//  decodeAPI.swift
//  surfSpot
//
//  Created by Giau Nguyen on 05/05/2025.
//
import  SwiftUI

struct QuoteResponse: Codable {
    var quotes: [Quote]
}

struct Quote: Codable {
    var quote_id: Int
    var quote: String
    var author: String
    
    enum CodingKeys: String, CodingKey {
        case quote_id = "id"
        case quote
        case author
    }
}

struct decodeAPI: View {
    @State private var quotes = [Quote]()
    
    var body: some View {
        NavigationView {
            List(quotes, id: \.quote_id) { quote in
                VStack(alignment: .leading) {
                    Text(quote.quote)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Color.green)
                    Text(quote.author)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            .navigationTitle("Quotes")
        }
        .task {
            await fetchData()
        }
    }
    
    func fetchData() async {
        guard let url = URL(string: "https://dummyjson.com/quotes") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            
//            print(String(decoding: data, as: UTF8.self))
            let decodedResponse = try JSONDecoder().decode(QuoteResponse.self, from: data)
            self.quotes = decodedResponse.quotes
            
        } catch {
            print("Data isn't valid: \(error.localizedDescription)")
        }
    }
}

struct decodeAPI_Previews: PreviewProvider {
    static var previews: some View {
        decodeAPI()
    }
}
