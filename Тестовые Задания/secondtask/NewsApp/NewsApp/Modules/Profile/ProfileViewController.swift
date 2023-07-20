//
//  ProfileTableViewController.swift
//  NewsApp
//
//  Created by danil.tsirkunov  on 18.07.2023.
//

import UIKit
import SnapKit

class ProfileViewController: UIViewController {
    private var viewModel = ProfileTableViewModel(with: nil)
    
    private var isEdit = false
    
    private var nameLabel = UILabel()
    private var birthdayLabel = UILabel()
    private var genderLabel = UILabel()
    
    private var nameTextField = UITextField()
    private var birthdayTextField = UITextField()
    private var genderTextField = UITextField()
    
    private let dataPicker = UIDatePicker()
    
    private let repository: RepositoryProfileProtocol
    
    private lazy var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person")
        imageView.backgroundColor = .systemGray5
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    private let editSaveButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = Constants.Color.blue
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = UIFont.preferredFont(forTextStyle: .title2)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.lineBreakMode = .byTruncatingTail
        button.sizeToFit()
        return button
    }()
    
    init(repository: RepositoryProfileProtocol) {
        self.repository = repository
        super.init(nibName: .none, bundle: .none)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        animateUI()
        nameTextField.delegate = self
        birthdayTextField.delegate = self
        genderTextField.delegate = self
        loadData()
        setupGestureRecognizer()
    }
}

extension ProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            userImageView.image = image
            viewModel.imageUser = image.pngData()
            repository.saveProfile(model: viewModel)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

private extension ProfileViewController {
    func setupUI() {
        title = "Профиль"
        view.backgroundColor = Constants.Color.background
        setupLikeButton()
        buildUI()
    }
    
    private func setupGestureRecognizer() {
        var tapGesture = UITapGestureRecognizer(target: self, action: #selector(changeProfileImage))
        userImageView.addGestureRecognizer(tapGesture)
        
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapGesture)
    }
    
    func makeSectionLabel(with name: String) -> UILabel {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.text = name
        label.textColor = Constants.Color.black
        label.numberOfLines = 0
        return label
    }
    
    func setupTextField() -> UITextField {
        let textField = UITextField()
        textField.backgroundColor = .systemGray5
        textField.textColor = Constants.Color.black
        textField.font = Constants.Font.title3
        textField.sizeToFit()
        textField.isEnabled = false
        textField.layer.cornerRadius = 5
        return textField
    }
    
    func buildUI() {
        nameLabel = makeSectionLabel(with: "Имя:")
        birthdayLabel = makeSectionLabel(with: "Дата рождения:")
        genderLabel = makeSectionLabel(with: "Пол:")
        
        nameTextField = setupTextField()
        birthdayTextField = setupTextField()
        genderTextField = setupTextField()
        
        birthdayTextField.keyboardType = .decimalPad
        
        view.addSubview(userImageView)
        view.addSubview(nameLabel)
        view.addSubview(nameTextField)
        view.addSubview(birthdayLabel)
        view.addSubview(birthdayTextField)
        view.addSubview(genderLabel)
        view.addSubview(genderTextField)
        
        userImageView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.centerX.equalToSuperview()
            make.height.width.equalTo(Constants.SizeView.sizeImage)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView.snp.bottom).offset(Constants.Spacing.standart)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        
        nameTextField.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(Constants.Spacing.miniSpacing)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.height.equalTo(Constants.SizeView.heightTextFielg)
        }
        birthdayLabel.snp.makeConstraints { make in
            make.top.equalTo(nameTextField.snp.bottom).offset(Constants.Spacing.standart)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        
        birthdayTextField.snp.makeConstraints { make in
            make.top.equalTo(birthdayLabel.snp.bottom).offset(Constants.Spacing.miniSpacing)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.height.equalTo(Constants.SizeView.heightTextFielg)
        }

        genderLabel.snp.makeConstraints { make in
            make.top.equalTo(birthdayTextField.snp.bottom).offset(Constants.Spacing.standart)
            make.leading.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
        }
        
        genderTextField.snp.makeConstraints { make in
            make.top.equalTo(genderLabel.snp.bottom).offset(Constants.Spacing.miniSpacing)
            make.leading.trailing.equalTo(self.view.safeAreaLayoutGuide).inset(Constants.Spacing.standart)
            make.height.equalTo(Constants.SizeView.heightTextFielg)
        }
    }
    
    func animateUI() {
        userImageView.alpha = 0
        nameLabel.alpha = 0
        nameTextField.alpha = 0
        birthdayLabel.alpha = 0
        birthdayTextField.alpha = 0
        genderLabel.alpha = 0
        genderTextField.alpha = 0
        
        UIView.animate(withDuration: 0.5) { [weak self] in
            self?.userImageView.alpha = 1
            self?.nameLabel.alpha = 1
            self?.nameTextField.alpha = 1
            self?.birthdayLabel.alpha = 1
            self?.birthdayTextField.alpha = 1
            self?.genderLabel.alpha = 1
            self?.genderTextField.alpha = 1
        }
    }
    
    func setupLikeButton() {
        editSaveButton.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: editSaveButton)
        navigationItem.rightBarButtonItem = barButton
    }
    
    func blockUnlockTextField(_ status: Bool) {
        nameTextField.isEnabled = status
        birthdayTextField.isEnabled = status
        genderTextField.isEnabled = status
    }
    
    func loadData() {
        viewModel = repository.loadProfile() ?? ProfileTableViewModel(with: nil)
        nameTextField.text = viewModel.name
        birthdayTextField.text = viewModel.birthday
        genderTextField.text = viewModel.gender
        guard let data = viewModel.imageUser else {
            userImageView.image = UIImage(systemName: "person")
            return
        }
        userImageView.image = UIImage(data: data)
    }
    
    @objc func buttonTapped() {
        if isEdit {
            viewModel.name = nameTextField.text
            viewModel.birthday = birthdayTextField.text
            viewModel.gender = genderTextField.text
            viewModel.imageUser = userImageView.image?.pngData()
            repository.saveProfile(model: viewModel)
            self.editSaveButton.setTitle("Edit", for: .normal)
            blockUnlockTextField(!isEdit)
        } else {
            blockUnlockTextField(!isEdit)
            self.editSaveButton.setTitle("Save", for: .normal)
        }
        isEdit.toggle()
    }
    
    @objc func hideKeyboard() {
        self.view.endEditing(true)
    }
    
    @objc func changeProfileImage() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
}

fileprivate extension Constants {
    enum SizeView {
        static let heightTextFielg = 35
        static let sizeImage = 150
    }
}


