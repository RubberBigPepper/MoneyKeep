//
//  AddSpendViewController.swift
//  MoneyKeep
//
//  Created by Albert on 04.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit
import YYCalendar

protocol AddSpendDone {//протокол добавления данных о расходе или доходе через форму
    func SpendAdded(_ item: SpendItem)
}

class AddSpendViewController: UIViewController {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var calculatorView: CalculatorView!
    @IBOutlet weak var textDescribe: UITextField!
    @IBOutlet weak var btnCategory: UIButton!
    
    public var isIncome = true//флаг запуска на траты или поступления, нужен для фильрации категорий
    public var delegate: AddSpendDone? = nil
    
    private var selectedDate: Date = Date(){
        didSet{
            btnDate.setTitle("Дата: \(selectedDate.toString())", for: .normal)
        }
    }
    private let fmtDate = "dd.MM.yyyy"

    override func viewDidLoad() {
        super.viewDidLoad()       
        textDescribe.delegate = self
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
        let calendar = YYCalendar(limitedCalendarLangType: .ENG, date: Date().toString(), minDate: nil, maxDate: Date().toString(), format: fmtDate) {
            date in
            if let dateClr = Date.fromString(date, self.fmtDate) {
                self.selectedDate = dateClr
            }
        }
        calendar.show()
    }
    
    @IBAction func btnCategoryPressed(_ sender: Any) {
        performSegue(withIdentifier:"SelectCategory", sender: nil)
    }
           
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc=segue.destination as? SelectCategoryViewController, segue.identifier=="SelectCategory"{
            vc.delegate = self
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

extension AddSpendViewController: SelectCategoryDelegate{
    func CategorySelected(_ category: SpendCategory) {//сформируем SpendItem (то есть затраты)
        if let amount = calculatorView.result, let text = textDescribe.text {
            let item = SpendItem(category: category, amount: Float(amount), date: selectedDate, text: text)
            self.delegate?.SpendAdded(item)
            dismiss(animated: true, completion: nil)
        }
    }
}
