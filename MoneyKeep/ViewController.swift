//
//  ViewController.swift
//  MoneyKeep
//
//  Created by Albert on 18.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit
import Charts

class ViewController: UIViewController {

    @IBOutlet weak var incomeBtn: UIButton!//кнопка дохода
    @IBOutlet weak var spendBtn: UIButton!//кнопка расхода
    @IBOutlet weak var segmentType: UISegmentedControl!
    
    @IBOutlet weak var chartView: PieChartView!
    
    private let prevNavButton = UIButton(type: .custom)//кнопка предыдущего месяца
    private let nextNavButton = UIButton(type: .custom)//кнопка следущего месяца
    
    private var firstMonthYear: Int = 0 //первый месяц даты расходов (год*12 + месяц)
    private var endMonthYear: Int = 0 // последний месяц даты расходов (год*12 + месяц)
    private var curMonthYear: Int = 0{//текущий месяц/год
        didSet{
            if curMonthYear == 0 { return }
            updateChart()
            if curMonthYear < endMonthYear {//покажем кнопку далее по месяцам
                nextNavButton.isHidden=false
                nextNavButton.setTitle(monthYear2DateStr(curMonthYear + 1), for: .normal)
            } else {//скроем кнопку далее
                nextNavButton.isHidden=true
            }
            if curMonthYear > firstMonthYear {//покажем кнопку предыдушего месяца
                prevNavButton.isHidden = false
                prevNavButton.setTitle(monthYear2DateStr(curMonthYear - 1), for: .normal)
            } else { //скроем кнопку предыдущего месяца
                prevNavButton.isHidden = true
            }
            self.navigationItem.title = monthYear2DateStr(curMonthYear)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCircleBtn(incomeBtn)
        prepareCircleBtn(spendBtn)
        addNavButtons()
        segmentType.selectedSegmentIndex = 0
//        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
//        let goals = [6, 8, 26, 30, 8, 10]
//        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
        NotificationCenter.default.addObserver(self,//Небольшой костыль-сохранение по сворачиванию
                                               selector: #selector(sceneWillResignActiveNotification(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        updateFirstEndDateMonth()
//        curMonthYear =  date2MonthYear(Date()) //текущий месяц/год
    }

    @objc func sceneWillResignActiveNotification(_ notification: NSNotification) {
        SpendData.Data.saveDataToCore()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
//        SpendData.Data.saveDataToCore()
    }
    
    @IBAction func segmentChanged(_ sender: Any) {
        updateChart()
    }
    
    
    private func prepareCircleBtn(_ btn: UIButton){//делаем кнопки круглыми
        btn.layer.cornerRadius = max(btn.bounds.width, btn.bounds.height)*0.5
        btn.layer.borderWidth = 3
        btn.layer.borderColor = btn.currentTitleColor.cgColor
    }

    @IBAction func incomePressed(_ sender: Any) {
        showAddSpendIncomeDlg(true)
    }
    
    @IBAction func spendPressed(_ sender: Any) {
        showAddSpendIncomeDlg(false)
    }
    
    private func showAddSpendIncomeDlg(_ income: Bool){//покажем диалог ввода траты или прихода денег
        performSegue(withIdentifier:"AddSpendIncome", sender: income)
    }
       
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        if let vc=segue.destination as? AddSpendViewController, segue.identifier=="AddSpendIncome",
           let income = sender as? Bool{
            vc.isIncome = income
            vc.delegate = self
        }
    }
    
    private func updateChart(){//обновление чарта за последний месяц
        let date = Date()
        let from = Date.from(date.getComponent(.year),date.getComponent(.month), 1)
        let data = SpendData.Data.getSpends(from: from!, to: date, type: segmentType.selectedSegmentIndex == 0 ? .outcome: .income)
        updateChart(data)
    }

    private func updateChart(_ data: [Int: Float]) {//обновление данных чарта
      // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for spendData in data {
            let cat = SpendData.Data.Categories.findCategory(spendData.key)
            if cat == nil || spendData.value == 0 { continue }
            let dataEntry = PieChartDataEntry(value: Double(spendData.value), label: cat?.name, data: spendData as AnyObject)
            dataEntries.append(dataEntry)
        }
      // 2. Set ChartDataSet
        let pieChartDataSet = PieChartDataSet(entries: dataEntries, label: nil)
        pieChartDataSet.colors = ColorSet.colors
      // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
      // 4. Assign it to the chart’s data
        chartView.data = pieChartData
    }
    
    private func updateFirstEndDateMonth(){//обновим даты начала и конца ведения расходов
        firstMonthYear = SpendData.Data.firstDate.toMonthYear()
        endMonthYear = SpendData.Data.endDate.toMonthYear()
        if curMonthYear > endMonthYear { curMonthYear = endMonthYear }
        if curMonthYear < firstMonthYear { curMonthYear = firstMonthYear }
    }
    
    private func monthYear2DateStr(_ monthYear: Int)-> String{//число даты в строку для кнопок
        if let date = Date.fromMonthYear(monthYear){
            return date.toString("MM.yyyy")
        }
        else {
            return "N/A"
        }
    }
    
    private func addNavButtons() {//добавляем кнопки на навбар
        prevNavButton.addTarget(self, action: #selector(self.prevMonthAction(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: prevNavButton)
        self.navigationItem.leftBarButtonItem?.isEnabled = true
        
        nextNavButton.addTarget(self, action: #selector(self.nextMonthAction(_:)), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: nextNavButton)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func prevMonthAction(_ sender: UIButton) {//переходим на месяц назад
        curMonthYear = curMonthYear - 1
    }
    
    @IBAction func nextMonthAction(_ sender: UIButton) {//переходим на месяц вперед
        curMonthYear = curMonthYear + 1
    }
}

extension ViewController: AddSpendDone{
    func SpendAdded(_ item: SpendItem) {
        SpendData.Data.Spends.addItem(item)
        if item.category.type == .income && segmentType.selectedSegmentIndex == 0 {//переключим отображения графика на расход или доход соответственно введенному
            segmentType.selectedSegmentIndex = 1
        } else if item.category.type == .outcome && segmentType.selectedSegmentIndex == 1 {
            segmentType.selectedSegmentIndex = 0
        }
        updateFirstEndDateMonth()
        updateChart()
    }
}
