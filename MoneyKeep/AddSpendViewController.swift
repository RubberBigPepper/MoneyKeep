//
//  AddSpendViewController.swift
//  MoneyKeep
//
//  Created by Albert on 04.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit
import YYCalendar

class AddSpendViewController: UIViewController {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var calculatorView: CalculatorView!
    @IBOutlet weak var textDescribe: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    
    public var isSpend = true//флаг запуска на траты или поступления

    override func viewDidLoad() {
        super.viewDidLoad()       
        textDescribe.delegate = self
        btnDate.setTitle("Дата: \(Date().toString())", for: .normal)
        calculatorView.delegate = self
        btnCategory.isEnabled = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnDatePressed(_ sender: UIButton) {
        let calendar = YYCalendar(limitedCalendarLangType: .ENG, date: Date().toString(), minDate: nil, maxDate: Date().toString(), format: "dd.MM.yyyy") {
            date in
            self.btnDate.setTitle("Дата: \(date)", for: .normal)
        }
        calendar.show()
    }
    
    @IBAction func btnCategoryPressed(_ sender: Any) {
        performSegue(withIdentifier:"SelectCategory", sender: nil)
    }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc=segue.destination as? SelectCategoryViewController, segue.identifier=="SelectCategory"{
            //vc.listener=self
            //vc.selectedColorName=labelSelectedColor.text!
            //vc.selectedColor=labelSelectedColor.textColor
        }
    }
}

extension AddSpendViewController: UITextFieldDelegate{//это для сокрытия клавиатуры по нажатию return
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

extension AddSpendViewController: CalculatorViewResult{//
    func resultChanged(_ result: Double?) {
        btnCategory.isEnabled = (result != nil) && (result! > 0.0)
    }
}
