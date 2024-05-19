import SwiftUI

struct ContentView: View {
    var body: some View {
        WelcomeViewContainer()
            .edgesIgnoringSafeArea(.all)
    }
}

struct WelcomeViewContainer: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return UINavigationController(rootViewController: WelcomeViewController())
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // No updates needed
    }
}
