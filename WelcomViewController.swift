import UIKit
import SwiftUI
class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        view.backgroundColor = UIColor.systemGray6 // Subtle background color

        // Square view for image
        let imageSquareView = UIView()
        imageSquareView.backgroundColor = .clear
        imageSquareView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageSquareView)

        // Image view
        let imageView = UIImageView(image: UIImage(named: "arm"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true // Ensures the image doesn't overflow its bounds
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageSquareView.addSubview(imageView)

        // Set constraints to make the square view cover the top portion of the screen
        NSLayoutConstraint.activate([
            imageSquareView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            imageSquareView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageSquareView.widthAnchor.constraint(equalTo: imageSquareView.heightAnchor), // Square aspect ratio
            imageSquareView.heightAnchor.constraint(equalToConstant: 200), // Adjust height as needed
            
            // Image view constraints
            imageView.topAnchor.constraint(equalTo: imageSquareView.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: imageSquareView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: imageSquareView.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: imageSquareView.bottomAnchor)
        ])

        // Other UI elements
        // Welcome label
        let welcomeLabel = UILabel()
        welcomeLabel.text = "Welcome to RestRaise"
        welcomeLabel.textAlignment = .center
        welcomeLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        welcomeLabel.textColor = .white
        welcomeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(welcomeLabel)

        // Instructions label
        let instructionsLabel = UILabel()
        instructionsLabel.text = """
        - Tap the camera icon to place a point.
        - Place two points to measure the distance.
        - Click the switch to change the method of calculate.
        """
        instructionsLabel.textAlignment = .center
        instructionsLabel.font = UIFont.systemFont(ofSize: 18)
        instructionsLabel.numberOfLines = 0
        instructionsLabel.textColor = .lightGray
        instructionsLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(instructionsLabel)

        // Start button
        let startButton = UIButton(type: .system)
        startButton.setTitle("Start Raise !", for: .normal)
        startButton.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        startButton.backgroundColor = UIColor.systemBlue
        startButton.setTitleColor(.white, for: .normal)
        startButton.layer.cornerRadius = 10
        startButton.addTarget(self, action: #selector(startButtonTapped), for: .touchUpInside)
        startButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(startButton)

        NSLayoutConstraint.activate([
            // Welcome label constraints
            welcomeLabel.topAnchor.constraint(equalTo: imageSquareView.bottomAnchor, constant: 20),
            welcomeLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            welcomeLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Instructions label constraints
            instructionsLabel.topAnchor.constraint(equalTo: welcomeLabel.bottomAnchor, constant: 20),
            instructionsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            instructionsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),

            // Start button constraints
            startButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            startButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    @objc private func startButtonTapped() {
        let arViewContainer = ARViewContainer()
        let arViewController = UIHostingController(rootView: arViewContainer)
        navigationController?.pushViewController(arViewController, animated: true)
    }
}
