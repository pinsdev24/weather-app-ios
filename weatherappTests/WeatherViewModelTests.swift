import XCTest
@testable import weatherapp
import Combine

class WeatherViewModelTests: XCTestCase {
    var viewModel: WeatherViewModel!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        viewModel = WeatherViewModel()
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        cancellables = nil
        super.tearDown()
    }
    
    func testFetchWeatherSuccess() {
        let expectation = self.expectation(description: "Weather data fetched")
        
        viewModel.$currentWeather
            .dropFirst()
            .sink { weather in
                XCTAssertNotNil(weather)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.fetchWeather(latitude: 37.7749, longitude: -122.4194)
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testSearchCitySuccess() {
        let expectation = self.expectation(description: "City search successful")
        
        viewModel.$cityName
            .dropFirst()
            .sink { cityName in
                XCTAssertEqual(cityName, "San Francisco")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        viewModel.searchCity(query: "San Francisco")
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTemperatureFormatting() {
        let temp = 23.456
        XCTAssertEqual(viewModel.formatTemperature(temp), "23.5°C")
    }
    
    func testDateFormatting() {
        let timestamp: TimeInterval = 1672531200 // January 1, 2023
        let formattedDate = viewModel.formatDate(timestamp)
        XCTAssertFalse(formattedDate.isEmpty)
    }
    
    func testTimeFormatting() {
        let timestamp: TimeInterval = 1672531200 // January 1, 2023
        let formattedTime = viewModel.formatTime(timestamp)
        XCTAssertFalse(formattedTime.isEmpty)
    }
}
