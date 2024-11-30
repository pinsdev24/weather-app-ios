import Foundation
import Combine
import CoreLocation

class WeatherViewModel: ObservableObject {
    @Published var currentWeather: Main?
    @Published var weatherDetails: [WeatherDetail] = []
    @Published var cityName: String = ""
    @Published var hourlyForecast: [Forecast] = []
    @Published var errorMessage: String?
    @Published var isLoading = false
    
    private let weatherService = WeatherService()
    private var cancellables = Set<AnyCancellable>()
    
    func fetchWeather(latitude: Double, longitude: Double) {
        isLoading = true
        
        weatherService.fetchWeather(latitude: latitude, longitude: longitude)
            .sink { completion in
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { response in
                self.currentWeather = response.main
                self.weatherDetails = response.weather
                self.cityName = response.name
            }
            .store(in: &cancellables)
    }
    
    func fetch24HourForecast(latitude: Double, longitude: Double) {
        weatherService.fetch24HourForecast(latitude: latitude, longitude: longitude)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { forecast in
                self.hourlyForecast = forecast
            }
            .store(in: &cancellables)
    }
    
    func searchCity(query: String) {
        guard !query.isEmpty else {
            return
        }
        
        weatherService.searchCity(query: query)
            .sink { completion in
                if case .failure(let error) = completion {
                    self.errorMessage = error.localizedDescription
                }
            } receiveValue: { cities in
                if let city = cities.first {
                    self.fetchWeather(latitude: city.lat, longitude: city.lon)
                    self.fetch24HourForecast(latitude: city.lat, longitude: city.lon)
                }
            }
            .store(in: &cancellables)
    }
    
    // Helper methods for data formatting
    func formatTemperature(_ temp: Double) -> String {
        return String(format: "%.1f°C", temp)
    }
    
    func formatDate(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "E, MMM d"
        return formatter.string(from: date)
    }
    
    func formatTime(_ timestamp: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: timestamp)
        let formatter = DateFormatter()
        formatter.dateFormat = "ha"
        return formatter.string(from: date)
    }
}
