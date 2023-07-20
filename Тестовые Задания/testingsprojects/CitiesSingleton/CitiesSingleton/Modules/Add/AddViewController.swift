//
//  AddViewController.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//

import UIKit

final class AddViewController: UIViewController {
    private let dataManager = DataManager()
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var countryTextField: UITextField!
    @IBOutlet private weak var populationTextField: UITextField!
    @IBOutlet private weak var isCapitalSwitch: UISwitch!
    @IBOutlet private weak var saveButtonOutlet: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    @IBAction private func saveButton(_ sender: Any) {
        let city = CityModel(name: nameTextField.text,
                             country: countryTextField.text,
                             population: Int64(populationTextField.text ?? ""),
                             isCapital: isCapitalSwitch.isOn)
        dataManager.saveCity(city: city)
        navigationController?.popViewController(animated: true)
    }
}

extension AddViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        areTextFieldsEmpty()
        return true
    }
}

private extension AddViewController {
    func configure() {
        nameTextField.delegate = self
        countryTextField.delegate = self
        populationTextField.delegate = self
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tapGesture)
        saveButtonOutlet.isEnabled = false
    }
    
    func areTextFieldsEmpty() {
        if nameTextField.text?.isEmpty == true && countryTextField.text?.isEmpty == true && populationTextField.text?.isEmpty == true {
            saveButtonOutlet.isEnabled = false
        } else {
            saveButtonOutlet.isEnabled = true
        }
    }
    
    @objc func handleTap() {
        areTextFieldsEmpty()
        self.view.endEditing(true)
    }
}
