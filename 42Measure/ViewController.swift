import UIKit
import ARKit
import SceneKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var dotNodes = [SCNNode]()
    var textNode = SCNNode()
    var lineNode = SCNNode()
    var meterValue: Double?

    var sceneView: ARSCNView!
    var shutterButton: UIButton!
    var clearButton: UIButton!
    var crosshairView: CrosshairView!
    var distanceLabel: UILabel!
    var genderSwitch: UISegmentedControl!
    var methodSwitch: UISegmentedControl!
    var isWoman = true
    var useHighCentimeter = false

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        sceneView = ARSCNView(frame: view.frame)
        sceneView.delegate = self
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.scene = SCNScene()
        view.addSubview(sceneView)

        addGenderSwitch()
        addMethodSwitch()
        addShutterButton()
        addClearButton()
        addCrosshairView()
        addDistanceLabel()
    }

    func addGenderSwitch() {
        genderSwitch = UISegmentedControl(items: ["Woman", "Man"])
        genderSwitch.selectedSegmentIndex = 0
        genderSwitch.addTarget(self, action: #selector(genderSwitchChanged), for: .valueChanged)
        genderSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(genderSwitch)

        NSLayoutConstraint.activate([
            genderSwitch.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            genderSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            genderSwitch.widthAnchor.constraint(equalToConstant: 200),
            genderSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    func addMethodSwitch() {
        methodSwitch = UISegmentedControl(items: ["Arm", "Body"])
        methodSwitch.selectedSegmentIndex = 0
        methodSwitch.addTarget(self, action: #selector(methodSwitchChanged), for: .valueChanged)
        methodSwitch.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(methodSwitch)

        NSLayoutConstraint.activate([
            methodSwitch.topAnchor.constraint(equalTo: genderSwitch.bottomAnchor, constant: 20),
            methodSwitch.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            methodSwitch.widthAnchor.constraint(equalToConstant: 200),
            methodSwitch.heightAnchor.constraint(equalToConstant: 30)
        ])
    }

    @objc func genderSwitchChanged() {
        isWoman = genderSwitch.selectedSegmentIndex == 0
        calculate()
    }

    @objc func methodSwitchChanged() {
        useHighCentimeter = methodSwitch.selectedSegmentIndex == 1
        calculate()
    }

    func addShutterButton() {
        let shutterImage = UIImage(systemName: "camera.fill")
        shutterButton = UIButton(type: .system)
        shutterButton.setImage(shutterImage, for: .normal)
        shutterButton.translatesAutoresizingMaskIntoConstraints = false
        shutterButton.tintColor = .systemBlue
        shutterButton.addTarget(self, action: #selector(shutterButtonPressed), for: .touchUpInside)
        view.addSubview(shutterButton)

        NSLayoutConstraint.activate([
            shutterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            shutterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            shutterButton.widthAnchor.constraint(equalToConstant: 50),
            shutterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func addClearButton() {
        clearButton = UIButton(type: .system)
        clearButton.setTitle("Clear", for: .normal)
        clearButton.setTitleColor(.systemBlue, for: .normal)
        clearButton.layer.borderWidth = 1.0
        clearButton.layer.borderColor = UIColor.systemBlue.cgColor
        clearButton.layer.cornerRadius = 8.0
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        clearButton.addTarget(self, action: #selector(clearButtonPressed), for: .touchUpInside)
        view.addSubview(clearButton)

        NSLayoutConstraint.activate([
            clearButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            clearButton.bottomAnchor.constraint(equalTo: shutterButton.topAnchor, constant: -20),
            clearButton.widthAnchor.constraint(equalToConstant: 100),
            clearButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func addCrosshairView() {
        crosshairView = CrosshairView()
        crosshairView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(crosshairView)

        NSLayoutConstraint.activate([
            crosshairView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            crosshairView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            crosshairView.widthAnchor.constraint(equalToConstant: 50),
            crosshairView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    func addDistanceLabel() {
        distanceLabel = UILabel()
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        distanceLabel.textColor = .white
        distanceLabel.textAlignment = .center
        distanceLabel.font = UIFont.systemFont(ofSize: 20)
        distanceLabel.layer.cornerRadius = 10
        distanceLabel.layer.masksToBounds = true
        view.addSubview(distanceLabel)

        NSLayoutConstraint.activate([
            distanceLabel.topAnchor.constraint(equalTo: methodSwitch.bottomAnchor, constant: 20),
            distanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            distanceLabel.widthAnchor.constraint(equalToConstant: 200),
            distanceLabel.heightAnchor.constraint(equalToConstant: 40)
        ])
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        sceneView.session.pause()
    }

    @objc func shutterButtonPressed() {
        if dotNodes.count >= 2 {
            resetMeasurements()
        }

        let touchLocation = CGPoint(x: sceneView.bounds.midX, y: sceneView.bounds.midY)
        let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
        let alignment: ARRaycastQuery.TargetAlignment = .any

        let query = sceneView.raycastQuery(from: touchLocation, allowing: estimatedPlane, alignment: alignment)

        if let validQuery = query {
            let result = sceneView.session.raycast(validQuery)

            if let hitResult = result.first {
                addDot(at: hitResult)
            }
        }
    }

    @objc func clearButtonPressed() {
        resetMeasurements()
    }

    func resetMeasurements() {
        for dot in dotNodes {
            dot.removeFromParentNode()
        }
        lineNode.removeFromParentNode()
        textNode.removeFromParentNode()
        dotNodes = [SCNNode]()
        distanceLabel.text = ""
    }

    func addDot(at hitResult: ARRaycastResult) {
        let dotGeometry = SCNSphere(radius: 0.0087)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        dotGeometry.materials = [material]

        let dotNode = SCNNode(geometry: dotGeometry)
        dotNode.position = SCNVector3(
            hitResult.worldTransform.columns.3.x,
            hitResult.worldTransform.columns.3.y + 0.01,
            hitResult.worldTransform.columns.3.z)

        sceneView.scene.rootNode.addChildNode(dotNode)
        dotNodes.append(dotNode)

        if dotNodes.count >= 2 {
            calculate()
            drawLine()
        }
    }

    func calculate() {
        guard dotNodes.count >= 2 else { return }

        let start = dotNodes[0]
        let end = dotNodes[1]

        let distance = sqrt(
            pow(end.position.x - start.position.x, 2) +
            pow(end.position.y - start.position.y, 2) +
            pow(end.position.z - start.position.z, 2)
        )

        meterValue = Double(distance)

        if useHighCentimeter {
            calculateWithHighCentimeter()
        } else {
            calculateWithStandardFormula()
        }
    }

    func calculateWithStandardFormula() {
        let heightMeter = Measurement(value: meterValue ?? 0, unit: UnitLength.meters)
        let heightCentimeters = heightMeter.converted(to: UnitLength.centimeters).value

        let finalValue: Double
        if isWoman {
            finalValue = (1.35 * heightCentimeters) + 50.0
        } else {
            finalValue = (1.40 * heightCentimeters) + 54.8
        }

        distanceLabel.text = String(format: "%.2f CM (Arm)", finalValue)
    }

    func calculateWithHighCentimeter() {
        let heightMeter = Measurement(value: meterValue ?? 0, unit: UnitLength.meters)
        let heightCentimeters = heightMeter.converted(to: UnitLength.centimeters).value

        let finalValue = heightCentimeters

        distanceLabel.text = String(format: "%.2f CM (Body)", finalValue)
    }

    func drawLine() {
        let start = dotNodes[0].position
        let end = dotNodes[1].position

        let lineGeometry = SCNGeometry.lineFrom(vector: start, toVector: end)
        lineNode = SCNNode(geometry: lineGeometry)
        sceneView.scene.rootNode.addChildNode(lineNode)
    }
}

extension SCNGeometry {
    static func lineFrom(vector start: SCNVector3, toVector end: SCNVector3) -> SCNGeometry {
        let indices: [Int32] = [0, 1]

        let source = SCNGeometrySource(vertices: [start, end])
        let element = SCNGeometryElement(indices: indices, primitiveType: .line)

        return SCNGeometry(sources: [source], elements: [element])
    }
}
