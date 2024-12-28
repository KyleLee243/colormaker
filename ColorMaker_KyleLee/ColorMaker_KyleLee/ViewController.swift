import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var mainStackView: UIStackView!
    // UI Outlets for sliders, text fields, and switches
    @IBOutlet weak var colorBox: UIView!
    
    @IBOutlet weak var redSlider: UISlider!
    @IBOutlet weak var greenSlider: UISlider!
    @IBOutlet weak var blueSlider: UISlider!
    
    @IBOutlet weak var redTextField: UITextField!
    @IBOutlet weak var greenTextField: UITextField!
    @IBOutlet weak var blueTextField: UITextField!
    
    @IBOutlet weak var redSwitch: UISwitch!
    @IBOutlet weak var greenSwitch: UISwitch!
    @IBOutlet weak var blueSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard mainStackView != nil else {
                 fatalError("mainStackView is not connected to the storyboard.")}
        
        redSwitch.transform = CGAffineTransform(scaleX: 1, y: 1)
        
        // Assign delegate to text fields
        redTextField.delegate = self
        greenTextField.delegate = self
        blueTextField.delegate = self
        
        // Set all switches to "off" by default
        redSwitch.isOn = false
        greenSwitch.isOn = false
        blueSwitch.isOn = false

        // Disable sliders and text fields initially
        redSlider.isEnabled = false
        greenSlider.isEnabled = false
        blueSlider.isEnabled = false
        redTextField.isEnabled = false
        greenTextField.isEnabled = false
        blueTextField.isEnabled = false
        
        // Set color box to initial state
        updateColorBox()
        loadState()
        
        // Adjust stack view based on current orientation and device
        adjustStackViewForCurrentOrientationAndDevice()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        adjustStackViewForCurrentOrientationAndDevice()
    }

    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        coordinator.animate(alongsideTransition: { _ in
            self.adjustStackViewForCurrentOrientationAndDevice()
        })
    }
    
    private func adjustStackViewForCurrentOrientationAndDevice() {
        if UIDevice.current.userInterfaceIdiom == .pad {
            // iPad Layout
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // iPad Landscape Mode
                mainStackView.axis = .horizontal
                mainStackView.spacing = 20
            } else {
                // iPad Portrait Mode
                mainStackView.axis = .vertical
                mainStackView.spacing = 10
            }
        } else {
            // iPhone Layout
            if UIScreen.main.bounds.width > UIScreen.main.bounds.height {
                // iPhone Landscape Mode
                mainStackView.axis = .horizontal
                mainStackView.spacing = 15
            } else {
                // iPhone Portrait Mode
                mainStackView.axis = .vertical
                mainStackView.spacing = 10
            }
        }
    }

    
    
    @IBAction func resetButtonTapped(_ sender: Any) {
        resetToInitialState()
    }
    // Action for Red Slider
    @IBAction func redSliderChanged(_ sender: UISlider) {
        redTextField.text = String(format: "%.2f", sender.value)
        updateColorBox()
    }
    
    // Action for Green Slider
    @IBAction func greenSliderChanged(_ sender: UISlider) {
        greenTextField.text = String(format: "%.2f", sender.value)
        updateColorBox()
    }
    
    // Action for Blue Slider
    @IBAction func blueSliderChanged(_ sender: UISlider) {
        blueTextField.text = String(format: "%.2f", sender.value)
        updateColorBox()
    }

    // Actions for Switches to Enable/Disable Components
    @IBAction func redSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            // Re-enable the slider and text field, and restore the last value
            redSlider.isEnabled = true
            redTextField.isEnabled = true
            redTextField.text = String(format: "%.2f", redSlider.value)
        } else {
            // Disable the slider and text field but keep the value
            redSlider.isEnabled = false
            redTextField.isEnabled = false
        }
        updateColorBox()
    }

    @IBAction func greenSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            greenSlider.isEnabled = true
            greenTextField.isEnabled = true
            greenTextField.text = String(format: "%.2f", greenSlider.value)
        } else {
            greenSlider.isEnabled = false
            greenTextField.isEnabled = false
        }
        updateColorBox()
    }

    @IBAction func blueSwitchToggled(_ sender: UISwitch) {
        if sender.isOn {
            blueSlider.isEnabled = true
            blueTextField.isEnabled = true
            blueTextField.text = String(format: "%.2f", blueSlider.value)
        } else {
            blueSlider.isEnabled = false
            blueTextField.isEnabled = false
        }
        updateColorBox()
    }
    
    private func resetToInitialState() {
        // Set all switches to "off"
        redSwitch.isOn = false
        greenSwitch.isOn = false
        blueSwitch.isOn = false

        // Disable sliders and text fields, and set their values to 0
        redSlider.isEnabled = false
        greenSlider.isEnabled = false
        blueSlider.isEnabled = false
        redTextField.isEnabled = false
        greenTextField.isEnabled = false
        blueTextField.isEnabled = false
        
        redSlider.value = 0
        greenSlider.value = 0
        blueSlider.value = 0
        redTextField.text = "0.00"
        greenTextField.text = "0.00"
        blueTextField.text = "0.00"
        
        // Reset color box
        updateColorBox()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // Allow clearing the text field
        if string.isEmpty {
            return true
        }
        return true // Allow all input
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        // Check the value entered by the user
        guard let text = textField.text, let value = Float(text) else {
            // If invalid, reset to the current slider value
            if textField == redTextField {
                textField.text = String(format: "%.2f", redSlider.value)
            } else if textField == greenTextField {
                textField.text = String(format: "%.2f", greenSlider.value)
            } else if textField == blueTextField {
                textField.text = String(format: "%.2f", blueSlider.value)
            }
            return
        }

        // If the value is greater than 1.0, reset and show a warning
        if value > 1.0 {
            textField.text = String(format: "%.2f", 1.0) // Reset to 1.0
            if textField == redTextField {
                redSlider.value = 1.0
            } else if textField == greenTextField {
                greenSlider.value = 1.0
            } else if textField == blueTextField {
                blueSlider.value = 1.0
            }
            
            // Show a warning message
            let alert = UIAlertController(title: "Invalid Input", message: "The value must be between 0 and 1.0.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true, completion: nil)
        } else {
            // If valid, update the slider
            if textField == redTextField {
                redSlider.value = value
            } else if textField == greenTextField {
                greenSlider.value = value
            } else if textField == blueTextField {
                blueSlider.value = value
            }
        }

        // Update the color box
        updateColorBox()
    }

    func saveState() {
        let defaults = UserDefaults.standard
        
        defaults.set(redSwitch.isOn, forKey: "redSwitch")
        defaults.set(greenSwitch.isOn, forKey: "greenSwitch")
        defaults.set(blueSwitch.isOn, forKey: "blueSwitch")
        
        defaults.set(redSlider.value, forKey: "redSlider")
        defaults.set(greenSlider.value, forKey: "greenSlider")
        defaults.set(blueSlider.value, forKey: "blueSlider")
    }
    
    func loadState() {
        let defaults = UserDefaults.standard
           
        redSwitch.isOn = defaults.bool(forKey: "redSwitch")
        greenSwitch.isOn = defaults.bool(forKey: "greenSwitch")
        blueSwitch.isOn = defaults.bool(forKey: "blueSwitch")
           
        redSlider.value = defaults.float(forKey: "redSlider")
        greenSlider.value = defaults.float(forKey: "greenSlider")
        blueSlider.value = defaults.float(forKey: "blueSlider")
           
        redSlider.isEnabled = redSwitch.isOn
        greenSlider.isEnabled = greenSwitch.isOn
        blueSlider.isEnabled = blueSwitch.isOn
           
        redTextField.isEnabled = redSwitch.isOn
        greenTextField.isEnabled = greenSwitch.isOn
        blueTextField.isEnabled = blueSwitch.isOn
           
        redTextField.text = String(format: "%.2f", redSlider.value)
        greenTextField.text = String(format: "%.2f", greenSlider.value)
        blueTextField.text = String(format: "%.2f", blueSlider.value)
           
        updateColorBox()
    }
    
    private func updateColorBox() {
        let red = redSwitch.isOn ? CGFloat(redSlider.value) : 0
        let green = greenSwitch.isOn ? CGFloat(greenSlider.value) : 0
        let blue = blueSwitch.isOn ? CGFloat(blueSlider.value) : 0
        colorBox.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
    }
}
