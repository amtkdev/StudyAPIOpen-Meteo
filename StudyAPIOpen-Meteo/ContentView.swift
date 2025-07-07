//
//  ContentView.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/06/30.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = WeatherViewModel()
    
    var body: some View {
        NavigationView {
            VStack {
                Text("Current Weather")
                    .font(.largeTitle)
                    .padding()
                
                if viewModel.isLoading {
                    ProgressView()
                } else if let errorMessage = viewModel.errorMessage {
                    Text("Error \(errorMessage)")
                        .foregroundColor(.red)
                } else {
                    weatherInfoView
                }
            }
            .task {
                await viewModel.fetchWeather()
            }
            .padding()
            .navigationTitle("Weather")
        }
    }
    
    private var weatherInfoView: some View {
        Group {
            if let temperature = viewModel.temperature {
                Text("Temperature: \(temperature.roundDouble())°C")
                    .font(.title2)
            }
            if let windSpeed = viewModel.windSpeed {
                Text("Wind Speed: \(windSpeed.roundDouble())km/h")
                    .font(.title2)
            }
        }
    }
}

#Preview {
    ContentView()
}
