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
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
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
    @IBOutlet weak var countryPicker: UIPickerView! {
        didSet {
            self.countryPicker.dataSource = self.countryDSD
            self.countryPicker.delegate = self.countryDSD
        }
    }
    @IBOutlet weak var documentPicker: UIPickerView! {
        didSet {
            self.documentPicker.dataSource = self.documentDSD
            self.documentPicker.delegate = self.documentDSD
        }
    }
    let countryDSD = CountryDataSourceDelegate()
    let documentDSD = DocumentDataSourceDelegate()
    
    var countries: [Country] = [] {
        didSet {
            countryDSD.countries = countries
            
            if let selectedCountry = countries.first {
                self.selectedCountry = selectedCountry
            }
            if let selectedDocument = countries.first?.documentTypes.first {
                self.selectedDocument = selectedDocument
            }
        }
    }
    var selectedCountry: Country? {
        didSet {
            countryButton?.setTitle(selectedCountry?.label, for: .normal)
            documentDSD.selectedCountry = selectedCountry
            countryDSD.selectedCountry = selectedCountry
            
            countryPicker.reloadAllComponents()
            documentPicker.reloadAllComponents()
        }
    }
    var selectedDocument: DocumentType? {
        didSet {
            documentButton?.setTitle(selectedDocument?.label, for: .normal)
            documentDSD.selectedDocument = selectedDocument
            
            countryPicker.reloadAllComponents()
            documentPicker.reloadAllComponents()
        }
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        let apiClient = ApiClient(secret: ZippyIdSDK.secret, key: ZippyIdSDK.key, baseUrl: ZippyIdSDK.host)
        
        apiClient
            .getCountries()
            .observe { (result) in
                DispatchQueue.main.async {
                    switch result {
                    case .error(let err):
                        self.delegate.onCompletedWithError(error: ZippyError.otherError(err))
                    case .value(let result):
                        self.loaderView.isHidden = true
                        
                        self.countries = result
                    }
                }
        }
    }
    
    @IBAction func onCountryTap(_ sender: Any) {
        countryPicker.isHidden = false
        pickerToolbar.isHidden = false
        documentPicker.isHidden = true
        continueButton.isHidden = true
    }
    
    @IBAction func onDocumentTap(_ sender: Any) {
        documentPicker.isHidden = false
        pickerToolbar.isHidden = false
        countryPicker.isHidden = true
        continueButton.isHidden = true
    }
    
    @IBAction func onContinueTap(_ sender: Any) {
        let bundle = Bundle(for: WizardVC.self)
        self.wizardVC = (UIStoryboard(name: "Main", bundle: bundle).instantiateViewController(withIdentifier: "WizardVC") as! WizardVC)
        self.wizardVC.delegate = self.delegate
        wizardVC.selectedDocument = selectedDocument
        self.present(self.wizardVC, animated: false, completion: nil)
    }
    
    @IBAction func didTapDoneButton(_ sender: Any) {
        if !countryPicker.isHidden {
            selectedCountry = countryDSD.selectedCountry
            selectedDocument = selectedCountry?.documentTypes[0]
            documentPicker.selectRow(0, inComponent: 0, animated: true)
            documentPicker.reloadAllComponents()
            hidePickers()
        }
        
        if !documentPicker.isHidden {
            selectedDocument = documentDSD.selectedDocument
            hidePickers()
        }
    }
    
    func hidePickers() {
        countryPicker.isHidden = true
        documentPicker.isHidden = true
        pickerToolbar.isHidden = true
        continueButton.isHidden = false
    }
}

class CountryDataSourceDelegate: NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var countries: [Country] = []
    var selectedCountry: Country?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries[row]
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