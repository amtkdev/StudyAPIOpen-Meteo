//
//  ContentView.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/06/30.
//

import SwiftUI

struct ContentView: View {
    // 1. Instance ViewModel
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                // 2. Title
                Text("Current Weather")
                    .font(.largeTitle)
                    .padding()
                
                // 3. UI state
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error \(errorMessage)")
                        .foregroundColor(.red)
                } else if let weather = viewModel.currentWeather {
                    // 4. Show the data
                    weatherInfoView(weather: weather)
                }
            }
            .task {
                // 5. Calls fetchWeather
                await viewModel.fetchWeather()
            }
            .padding()
            .navigationTitle("Weather")
        }
    }
    
    // 6. Subview with weather data
    private func weatherInfoView(weather: CurrentWeather) -> some View {
        
        List {
            Section {
                HStack {
                    VStack {
                        Text(weather.is_day == 1 ? "Day" : "Night")
                    }
                }
                HStack {
                    VStack {
                        Text("Temperature: \(weather.temperature_2m.roundDouble()) \(viewModel.currentUnits?.temperature_2m ?? "")")
                    }
                }
                HStack {
                    VStack {
                        Text("Humidity: \(weather.relative_humidity_2m?.roundDouble() ?? "N/A")%")
                    }
                }
            } header: {
                Image(systemName: "thermometer.medium")
                Text("Ambient Conditions")
            }

            Section {
                HStack {
                    VStack {
                        Text("Wind Speed: \(weather.wind_speed_10m.roundDouble()) \(viewModel.currentUnits?.wind_speed_10m ?? "")")
                    }
                }
                HStack {
                    VStack {
                        Text(" Wind Direction:\(weather.wind_direction_10m?.roundDouble() ?? "N/A")°")
                    }
                }
            } header: {
                Image(systemName: "wind")
                Text("Wind Conditions")
            }
            
            Section {
                VStack {
                    Text("Precipitation: \(weather.precipitation?.roundDouble() ?? "0") mm")
                }
                VStack {
                    Text("Rain: \(weather.rain?.roundDouble() ?? "0") mm")
                }
            } header: {
                Image(systemName: "cloud.rain")
                Text("Rain Conditions")
            }
        }
    }
}

#Preview {
    ContentView()
}
