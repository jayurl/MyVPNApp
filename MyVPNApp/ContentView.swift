//
//  ContentView.swift
//  MyVPNApp
//
//  Created by Jay on 8/21/24.
//

import SwiftUI
import MapKit

struct ContentView: View {
    var body: some View {
        ZStack {
            // Background
            Color.black
                .edgesIgnoringSafeArea(.all)

            VStack(spacing: 30) {
                // Title
                Text("VPN Client")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                    .padding(.top, 50)

                // Map View
                MapView(coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -77.0410))
                    .frame(height: 250)
                    .cornerRadius(15)
                    .padding(.horizontal)
                    .shadow(color: Color.white.opacity(0.3), radius: 10, x: 0, y: 10)

                // VPN Status Indicator
                VStack {
                    Text("Status:")
                        .font(.system(size: 24, weight: .medium, design: .rounded))
                        .foregroundColor(.white.opacity(0.7))
                    Text("Disconnected")
                        .font(.system(size: 28, weight: .semibold, design: .rounded))
                        .foregroundColor(.red)
                        .padding(.top, 5)
                }
                .padding(.vertical, 20)

                // Connect Button
                Button(action: {
                    VPNManager.shared.configureVPN(
                        username: "your-username",
                        password: "your-password",
                        serverAddress: "your-vpn-server-ip"
                    )
                    VPNManager.shared.connectVPN()
                }) {
                    Text("Connect")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.green)
                        .cornerRadius(15)
                        .shadow(color: Color.green.opacity(0.5), radius: 10, x: 0, y: 10)
                }

                // Disconnect Button
                Button(action: {
                    VPNManager.shared.disconnectVPN()
                }) {
                    Text("Disconnect")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 200)
                        .background(Color.red)
                        .cornerRadius(15)
                        .shadow(color: Color.red.opacity(0.5), radius: 10, x: 0, y: 10)
                }
            }
            .padding(.bottom, 50)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .preferredColorScheme(.dark)
    }
}


struct MapView: UIViewRepresentable {
    var coordinate: CLLocationCoordinate2D

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: coordinate, span: span)
        view.setRegion(region, animated: true)

        // Add a pin at the VPN location
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "VPN Server"
        view.addAnnotation(annotation)
    }
}



