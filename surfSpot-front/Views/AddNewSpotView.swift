//
//  AddNewSpotView.swift
//  surfSpot
//
//  Created by Giau Nguyen on 07/05/2025.
//

import SwiftUI


struct SurfSpotDTO: Codable {
    var destination: String
    var surfBreak: String
    var address: String
    var country: String
    var difficultyLevel: Int
    var photo_url: String
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case destination
        case surfBreak = "surf_breaks"
        case address
        case country
        case difficultyLevel = "difficulty_level"
        case photo_url
        case description
    }
}

struct AddNewSpotView: View {
    @Binding var tabSelection: Int

    @State var destination: String = ""
    @State var surfBreak: String = ""
    @State var address: String = ""
    @State var country: String = ""
    @State var difficultyLevel: String = ""
    @State var photoURL: String = ""
    @State var description: String = ""
    
    @State private var navigate = false
    
    var body: some View {
        
        NavigationStack {
            Form {
                Section("Add your post"){
                    TextField("Destination", text: $destination)
                        .autocapitalization(.none)
                    TextField("Surf Break", text: $surfBreak)
                    TextField("Address", text: $address)
                        .autocapitalization(.none)
                    TextField("Country", text: $country)
                        .autocapitalization(.none)
                    TextField("Difficulty Level", text: $difficultyLevel)
                        .autocapitalization(.none)
                    TextField("Photo URL", text: $photoURL)
                }
                Section("Description"){
                    TextEditor(text: $description)
                }
                Section {
                    Button(action: {
                        DataTask()
                        destination = ""
                        surfBreak = ""
                        address = ""
                        country = ""
                        difficultyLevel = ""
                        photoURL = ""
                        self.tabSelection = 1
                        description = ""
                    }) {
                        HStack {
                            Image(systemName: "paperplane.fill")
                            Text("Post Spot")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green)
                    .controlSize(.large)
                }
                
            }
            .navigationTitle("Add your spot 🌊")
        }
        
    }
    func DataTask() {
        guard let url = URL(string:"http://localhost:4000/surfSpots") else {
            print("URL invalide")
            return
        }
        guard let difficulty = Int(difficultyLevel) else {
            print("Niveau de difficulté invalide")
            return
        }
        print("difficultyLevel**", difficultyLevel, difficulty)
        let cookies = HTTPCookieStorage.shared.cookies(for: url) ?? []

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let cookieHeader = HTTPCookie.requestHeaderFields(with: cookies)
        
        for (headerField, value) in cookieHeader {
            request.setValue(value, forHTTPHeaderField: headerField)
        }

        let newSpot = SurfSpotDTO (
            destination: destination,
            surfBreak: surfBreak,
            address: address,
            country: country,
            difficultyLevel: difficulty,
            photo_url: photoURL,
            description: description
        )
        
        guard let jsonData = try? JSONEncoder().encode(newSpot) else {
            print("Erreur encodage JSON")
            return
        }

        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Erreur requête POST: \(error)")
                return
            }
            
            if let httpResponse = response as? HTTPURLResponse {
                print("Réponse HTTP: \(httpResponse.statusCode)")
            }
        }.resume()
    }
}


#Preview {
    AddNewSpotView(tabSelection: .init(get: { 1 }, set: { _ in }))
}
