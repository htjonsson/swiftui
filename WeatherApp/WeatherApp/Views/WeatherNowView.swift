//
//  WeatherNowView.swift
//  WeatherApp
//
//  Created by Hordur Thor Jonsson on 01/04/2024.
//

import SwiftUI

struct WeatherNowView: View {
    var weather: ResponseBody
    
    var body: some View {
        VStack {
            VStack(alignment: .leading, spacing: 20) {
                // https://www.hackingwithswift.com/books/ios-swiftui/buttons-and-images
                Text("Weather now")
                    .bold()
                    .padding(.bottom)
                
                HStack {
                    WeatherRow(logo: "thermometer", name: "Min temp", value: (weather.main.tempMin.roundDouble() + ("°")))
                    Spacer()
                    WeatherRow(logo: "thermometer", name: "Max temp", value: (weather.main.tempMax.roundDouble() + "°"))
                }
                
                HStack {
                    WeatherRow(logo: "wind", name: "Wind speed", value: (weather.wind.speed.roundDouble() + " m/s"))
                    Spacer()
                    WeatherRow(logo: "humidity", name: "Humidity", value: "\(weather.main.humidity.roundDouble())%")
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
            .foregroundColor(Color(hue: 0.656, saturation: 0.787, brightness: 0.354))
            .background(.white)
          //  .cornerRadius(20, corners: [.topLeft, .topRight])
            Spacer()
        }
        .background(.white)
    }
}

#Preview {
    WeatherNowView(weather: previewWeather)
}
