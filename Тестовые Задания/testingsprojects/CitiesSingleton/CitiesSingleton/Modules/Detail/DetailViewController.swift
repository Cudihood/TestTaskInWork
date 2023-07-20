//
//  DetailViewController.swift
//  CitiesSingleton
//
//  Created by danil.tsirkunov  on 17.07.2023.
//

import UIKit

final class DetailViewController: UIViewController {
    private var city = City()
    
    @IBOutlet private weak var nameLable: UILabel!
    @IBOutlet private weak var counrtyLable: UILabel!
    @IBOutlet private weak var populationLable: UILabel!
    @IBOutlet private weak var isCapitalLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    func setCity(city: City) {
        self.city = city
    }
}

private extension DetailViewController {
    func configure() {
        nameLable.text = city.name
        counrtyLable.text = city.country
        populationLable.text = String(city.population)
        isCapitalLabel.text = city.isCapital ? "Yes" : "No"
    }
}
