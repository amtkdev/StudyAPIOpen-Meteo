//
//  ContentView.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/06/30.
//

import SwiftUI
//codable is available from the json
struct WeatherData: Decodable {
    let current: CurrentWeather
}

struct CurrentWeather: Decodable {
    let temperature_2m: Double
    let wind_speed_10m: Double
}

struct ContentView: View {
    @State private var temperature: Double?
    @State private var windSpeed: Double?
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current Weather")
                    .font(.largeTitle)
                    .fontWeight(.thin)
                    .padding()
                
                if let temperature = temperature {
                    Text("Temperature: \(temperature.roundDouble()) C")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                }
                if let windSpeed = windSpeed {
                    Text("Wind Speed \(windSpeed.roundDouble()) km/h")
                        .font(.title2)
                        .fontWeight(.ultraLight)
                }
            }
            .padding()
            .task {
                await fetchWeatherFromAPI()
            }
            .navigationTitle("Weather")
        }
    }
    
    func fetchWeatherFromAPI() async {
        let urlString = "https://api.open-meteo.com/v1/forecast?latitude=34.62&longitude=136.50&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        guard let url = URL(string: urlString) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            DispatchQueue.main.async {
                self.temperature = decodedData.current.temperature_2m
                self.windSpeed = decodedData.current.wind_speed_10m
            }
        } catch {
            print("error fetching weather data \(error)")
        }
    }
}

#Preview {
    ContentView()
}
