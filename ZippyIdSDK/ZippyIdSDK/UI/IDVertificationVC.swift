//
//  IDVertificationVC.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 16/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class IDVertificationVC: UIViewController {
    var wizardVC: WizardVC!
    public weak var delegate: ZippyVCDelegate!
    @IBOutlet weak var countryButton: UIButton! {
        didSet {
            countryButton.layer.cornerRadius = 20
            countryButton.layer.borderWidth = 1
            countryButton.layer.borderColor = (UIColor.lightGray).cgColor
        }
    }
    @IBOutlet weak var documentButton: UIButton! {
        didSet {
            documentButton.layer.cornerRadius = 20
            documentButton.layer.borderWidth = 1
            documentButton.layer.borderColor = (UIColor.lightGray).cgColor
        }
    }
    @IBOutlet weak var continueButton: UIButton! {
        didSet {
            continueButton.layer.cornerRadius = 20
        }
    }
    
    @IBOutlet weak var pickerToolbar: UIToolbar!
    @IBOutlet weak var pickerToolbarDoneButton: UIBarButtonItem!
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var documentPicker: UIPickerView!
    let countryDSD = CountryDataSourceDelegate()
    let documentDSD = DocumentDataSourceDelegate()
    
    var countries: [Country] = []
    var selectedCountry: Country?
    var selectedDocument: DocumentType?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiClient = ApiClient(secret: ZippyIdSDK.secret, key: ZippyIdSDK.key, baseUrl: ZippyIdSDK.host)
        
        apiClient
            .getCountries()
            .observe { (result) in
                switch result {
                case .error(let err):
                    print(err)
                case .value(let result):
                    self.countries = result
                    self.selectedCountry = result[0]
                    self.selectedDocument = result[0].documentTypes[0]
                    
                    self.updatePickerValues()
                    
                    self.countryPicker.dataSource = self.countryDSD
                    self.countryPicker.delegate = self.countryDSD
                    
                    self.documentPicker.dataSource = self.documentDSD
                    self.documentPicker.delegate = self.documentDSD
                }
        }
    }
    
    @IBAction func onCountryTap(_ sender: Any) {
        countryPicker.isHidden = false
        pickerToolbar.isHidden = false
        documentPicker.isHidden = true
        continueButton.isHidden = true
        countryDSD.countriesAPI = countries
        countryDSD.selectedCountry = selectedCountry
        countryDSD.selectedDocument = selectedDocument
    }
    
    @IBAction func onDocumentTap(_ sender: Any) {
        documentPicker.isHidden = false
        pickerToolbar.isHidden = false
        countryPicker.isHidden = true
        continueButton.isHidden = true
        documentDSD.selectedCountry = selectedCountry
        documentDSD.selectedDocument = selectedDocument
    }
    
    @IBAction func onContinueTap(_ sender: Any) {
        self.wizardVC = (UIStoryboard(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "WizardVC") as! WizardVC)
        self.wizardVC.delegate = self.delegate
        wizardVC.selectedDocument = selectedDocument
        self.present(self.wizardVC, animated: false, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        if !countryPicker.isHidden {
            selectedCountry = countryDSD.selectedCountry
            selectedDocument = selectedCountry?.documentTypes.contains {($0.value == selectedDocument?.value)} ?? false ? selectedDocument : selectedCountry?.documentTypes[0]
            updatePickerValues()
        }
        
        if !documentPicker.isHidden {
            selectedDocument = documentDSD.selectedDocument            
            selectedCountry = selectedCountry?.documentTypes.contains {($0.value == selectedDocument?.value)} ?? false ? selectedCountry : countries[0]
            updatePickerValues()
        }
    }
    
    func updatePickerValues() {
        countryPicker.isHidden = true
        documentPicker.isHidden = true
        pickerToolbar.isHidden = true
        continueButton.isHidden = false
        
        countryButton.setTitle(selectedCountry?.label, for: .normal)
        documentButton.setTitle(selectedDocument?.label, for: .normal)
        
        countryDSD.selectedCountry = selectedCountry
        countryDSD.selectedDocument = selectedDocument
        documentDSD.selectedCountry = selectedCountry
        documentDSD.selectedDocument = selectedDocument
        
        countryPicker.reloadAllComponents()
        documentPicker.reloadAllComponents()
    }
}

class CountryDataSourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var countriesAPI: [Country] = []
    var selectedCountry: Country?
    var selectedDocument: DocumentType?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countriesAPI.filter {$0.documentTypes.contains {($0.value == selectedDocument?.value)}}.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countriesAPI.filter {$0.documentTypes.contains {($0.value == selectedDocument?.value)}}[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countriesAPI.filter {$0.documentTypes.contains {($0.value == selectedDocument?.value)}}[row]
    }
}

class DocumentDataSourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var selectedCountry: Country?
    var selectedDocument: DocumentType?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedCountry?.documentTypes.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectedCountry?.documentTypes[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDocument = selectedCountry?.documentTypes[row]
    }
}
