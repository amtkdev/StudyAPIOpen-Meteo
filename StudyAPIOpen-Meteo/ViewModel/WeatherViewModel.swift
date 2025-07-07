//
//  WeatherViewModel.swift
//  StudyAPIOpen-Meteo
//
//  Created by AMTK on 2025/07/07.
//

import Foundation

class WeatherViewModel: ObservableObject {
    @Published var temperature: Double?
    @Published var windSpeed: Double?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let baseUrl = "https://api.open-meteo.com/v1/forecast"
    
    func fetchWeather(latitude: Double = 34.62, longitude: Double = 136.50) async {
        isLoading = true
        errorMessage = nil
        
        let urlString = "\(baseUrl)?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        
//        https://api.open-meteo.com/v1/forecast?latitude=52.52&longitude=13.41&current=temperature_2m,wind_speed_10m&hourly=temperature_2m,relative_humidity_2m,wind_speed_10m"
        
        
        guard let url = URL(string: urlString) else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedData = try JSONDecoder().decode(WeatherData.self, from: data)
            
            DispatchQueue.main.async {
                self.temperature = decodedData.current.temperature_2m
                self.windSpeed = decodedData.current.wind_speed_10m
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }
}
