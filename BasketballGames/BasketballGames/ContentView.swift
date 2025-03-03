//
//  ContentView.swift
//  BasketballGames
//
//  Created by Samuel Shi on 2/27/25.
//

import SwiftUI

struct Response: Codable {
    var results: [Result]
}
struct Result: Codable, Identifiable {
    var team: String
    var opponent: String
    var id: Int
    var date: String
    var score: Score
    var isHomeGame: Bool
}
struct Score: Codable {
    var opponent: Int
    var unc: Int
}
struct ContentView: View {
    @State private var results = [Result]()
    var body: some View {
        List(results) {
            item in VStack(alignment: .leading) {
            HStack {
                Text("\(item.team) vs. \(item.opponent)")
                    .font(.headline)
                Spacer()
                Text("\(item.score)")
                    .font(.headline)
            }
            
            HStack {
                Text("\(item.date)")
                    .font(.subheadline)
                Spacer()
                Text("\(item.isHomeGame)")
                    .font(.subheadline)
                    
            }
            
        }
        .task {
            await loadData()
        }
    }
    }
    func loadData() async {
        guard let url = URL(string: "https://api.samuelshi.com/uncbasketball") else {
            print("Invalid URL")
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let decodedResults = try? JSONDecoder().decode(Response.self, from: data) {
                results = decodedResults.results
            } else {
                print("Failed to decode JSON")
            }
        } catch {
            print("Error fetching data: \(error)")
        }
    }
}


#Preview {
    ContentView()
}
