import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "swift")
                .font(.system(size: 80))
                .foregroundStyle(.orange)
            Text("Hello, World!")
                .font(.largeTitle)
                .padding()
        }
    }
}
