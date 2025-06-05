import SwiftUI

struct ConnexionView: View {
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var message: String = ""
    @State private var isLoggedIn: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                Image("backgroundConnexion")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack {
                    Text("Connectez-vous 😉")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    Form {
                        Section() {
                            TextField("Email", text: $email)
                                .autocapitalization(.none)
                                .keyboardType(.emailAddress)
                            SecureField("Mot de passe", text: $password)
                            
                            Button("Se connecter") {
                                login()
                            }
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        
                        if !message.isEmpty {
                            Text(message)
                                .foregroundColor(isLoggedIn ? .green : .red)
                        }
                    }
                    .frame(width: 400, height: 300, alignment: .center)
                    .scrollContentBackground(.hidden) // pour rendre le fond du formulaire transparent
                    .background(Color.clear)
                }
                .padding()
            }
            .navigationDestination(isPresented: $isLoggedIn) {
                DisplayPages()
            }
            .navigationTitle("")
        }
    }

    func login() {
        guard let url = URL(string: "http://localhost:4000/login") else {
            message = "URL invalide"
            return
        }

        let body: [String: String] = [
            "email": email,
            "password": password
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: body) else {
            message = "Erreur JSON"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    message = "Erreur : \(error.localizedDescription)"
                    return
                }

                guard let httpResponse = response as? HTTPURLResponse else {
                    message = "Réponse invalide"
                    return
                }

                let headerFields = httpResponse.allHeaderFields as? [String: String] ?? [:]
                let cookies = HTTPCookie.cookies(withResponseHeaderFields: headerFields, for: url)
                cookies.forEach { cookie in
                    print(cookie)
                    HTTPCookieStorage.shared.setCookie(cookie)
                }

                if httpResponse.statusCode == 200 {
                    //message = "Connexion réussie 🎉"
                    isLoggedIn = true
                } else {
                    //message = "Échec de connexion (code \(httpResponse.statusCode))"
                    isLoggedIn = false
                }
            }
        }.resume()
    }
}

#Preview {
    ConnexionView()
}
