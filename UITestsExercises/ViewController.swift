//
//  ViewController.swift
//  UITestsExercises
//
//  Created by Альбина Кашапова on 1/29/21.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
    var pickerController = UIImagePickerController()
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var musicLabel: UILabel!
    
    
    
    
    @IBAction func textChanged(_ sender: UITextField) {
        welcomeLabel.text = "Welcome, " + textField.text!
    }
    
    
    @IBAction func pickPhotoPressed(_ sender: UIButton) {
        pickerController.allowsEditing = false
        pickerController.sourceType = .photoLibrary
        
        present(pickerController, animated: true, completion: nil)
    }
    
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        progressView.progress = 1 - slider.value
    }
    
    
    @IBAction func savePressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "Do you want to save?", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func cancelPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: sender.titleLabel?.text, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true)
    }
    
    
    @IBAction func searchPressed(_ sender: UIBarButtonItem) {
    }
    
    
    @IBAction func difficultyControlChanged(_ sender: UISegmentedControl) {
        title = difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex)
    }
    

    
    @IBAction func switcherChanged(_ sender: UISwitch) {
        
        if switcher.isOn {
                musicLabel.text = "Music is ON"
            } else {
                musicLabel.text = "Music is OFF"
            }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        pickerController.delegate = self
        
        title = difficultyControl.titleForSegment(at: difficultyControl.selectedSegmentIndex)
        
        if switcher.isOn {
                musicLabel.text = "Music is ON"
            } else {
                musicLabel.text = "Music is OFF"
            }
        
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.contentMode = .scaleAspectFit
            imageView.image = pickedImage
    }
    
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
}

