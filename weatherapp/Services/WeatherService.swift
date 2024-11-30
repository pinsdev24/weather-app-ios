import Foundation
import Combine
import CoreLocation

enum WeatherError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
}

class WeatherService {
    private let apiKey: String = "YOUR_API_KEY" // Remplacez par votre clé API OpenWeather
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let forecastURL = "https://api.openweathermap.org/data/2.5/forecast"
    
    func fetchWeather(latitude: Double, longitude: Double) -> AnyPublisher<WeatherResponse, Error> {
        let urlString = "\(baseURL)?lat=\(latitude)&lon=\(longitude)&exclude=minutely&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    return WeatherError.networkError(urlError)
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func fetch24HourForecast(latitude: Double, longitude: Double) -> AnyPublisher<[Forecast], Error> {
        let urlString = "\(forecastURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: ForecastWeatherResponse.self, decoder: JSONDecoder())
            .map { $0.list.prefix(24) }
            .map(Array.init)
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    return WeatherError.networkError(urlError)
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func searchCity(query: String) -> AnyPublisher<[City], Error> {
        let geocodingURL = "https://api.openweathermap.org/geo/1.0/direct?q=\(query)&limit=5&appid=\(apiKey)"
        
        guard let url = URL(string: geocodingURL) else {
            return Fail(error: WeatherError.invalidURL).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [City].self, decoder: JSONDecoder())
            .mapError { error -> Error in
                if let urlError = error as? URLError {
                    return WeatherError.networkError(urlError)
                }
                return error
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}