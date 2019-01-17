//
//  IDVertificationVC.swift
//  ZippyIdSDK
//
//  Created by Melānija Grunte on 16/01/2019.
//  Copyright © 2019 ZippyId. All rights reserved.
//

import Foundation

class IDVertificationVC: UIViewController  {
    var wizardVC: WizardVC!
    public var delegate: ZippyVCDelegate!
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
    
    @IBOutlet weak var countryPicker: UIPickerView!
    @IBOutlet weak var documentPicker: UIPickerView!
    let countryDSD = CountryDataSourceDelegate()
    let documentDSD = DocumentDataSourceDelegate()
    
    var selectedCountry: ZippyCountry?
    var selectedDocument: ZippyDocumentType?
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedCountry = countries[0]
        selectedDocument = selectedCountry?.documentTypes[0]
        
        updatePickerValues()
    
        countryPicker.dataSource = countryDSD
        countryPicker.delegate = countryDSD
        
        documentPicker.dataSource = documentDSD
        documentPicker.delegate = documentDSD
    }
    
    
    @IBAction func onCountryTap(_ sender: Any) {
        countryPicker.isHidden = false
        documentPicker.isHidden = true
        continueButton.isHidden = true
        countryDSD.selectedCountry = selectedCountry
        countryDSD.selectedDocument = selectedDocument

    }
    
    @IBAction func onDocumentTap(_ sender: Any) {
        documentPicker.isHidden = false
        countryPicker.isHidden = true
        continueButton.isHidden = true
        documentDSD.selectedCountry = selectedCountry
        documentDSD.selectedDocument = selectedDocument
    }
    
    @IBAction func onContinueTap(_ sender: Any) {
        self.wizardVC = (UIStoryboard(name: "Main", bundle: ZippyIdSDK.resourcesBundle).instantiateViewController(withIdentifier: "WizardVC") as! WizardVC)
        self.wizardVC.delegate = self.delegate
        self.present(self.wizardVC, animated: false, completion: nil)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first

        if (countryPicker.isHidden == false && touch?.view != countryPicker) {
            selectedCountry = countryDSD.selectedCountry
            // selectedDocument = selectedCountry?.documentTypes.contains(selectedDocument ?? .idCard) ?? false ? selectedDocument : selectedCountry?.documentTypes[0]
            updatePickerValues()
        }
        
        if (documentPicker.isHidden == false && touch?.view != documentPicker) {
            selectedDocument = documentDSD.selectedDocument
            // selectedCountry = selectedCountry?.documentTypes.contains(selectedDocument ?? .idCard) ?? false ? selectedCountry : countries[0]
            updatePickerValues()
        }
        
    }
    
    func updatePickerValues() {
        countryPicker.isHidden = true
        documentPicker.isHidden = true
        continueButton.isHidden = false
        
        countryButton.setTitle(selectedCountry?.label, for: .normal)
        documentButton.setTitle(selectedDocument?.rawValue, for: .normal)
        
        countryDSD.selectedCountry = selectedCountry
        countryDSD.selectedDocument = selectedDocument
        documentDSD.selectedCountry = selectedCountry
        documentDSD.selectedDocument = selectedDocument
        
        countryPicker.reloadAllComponents()
        documentPicker.reloadAllComponents()
    }
}


class CountryDataSourceDelegate : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var selectedCountry: ZippyCountry?
    var selectedDocument: ZippyDocumentType?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return countries.filter { $0.documentTypes.contains(selectedDocument ?? .idCard) }.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return countries.filter { $0.documentTypes.contains(selectedDocument ?? .idCard) }[row].label
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCountry = countries.filter { $0.documentTypes.contains(selectedDocument ?? .idCard) }[row]
    }
}


class DocumentDataSourceDelegate : NSObject, UIPickerViewDelegate, UIPickerViewDataSource {
    var selectedCountry: ZippyCountry?
    var selectedDocument: ZippyDocumentType?
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selectedCountry?.documentTypes.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return (selectedCountry?.documentTypes[row]).map { $0.rawValue }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedDocument = selectedCountry?.documentTypes[row]
    }
}
