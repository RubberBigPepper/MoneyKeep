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
    
    @IBOutlet weak var demoOffBtn: UIButton!
    @IBOutlet weak var chartView: PieChartView!
    
    private var firstMonthYear: Int = 0 //первый месяц даты расходов (год*12 + месяц)
    private var endMonthYear: Int = 0 // последний месяц даты расходов (год*12 + месяц)
    private var curMonthYear: Int = 0{//текущий месяц/год
        didSet{
            if curMonthYear == 0 { return }
            updateChart()
            self.navigationItem.rightBarButtonItem?.title = monthYear2DateStr(curMonthYear + 1, true)
            self.navigationItem.leftBarButtonItem?.title = monthYear2DateStr(curMonthYear - 1, true)
            self.navigationItem.rightBarButtonItem?.isEnabled = curMonthYear < endMonthYear
            self.navigationItem.leftBarButtonItem?.isEnabled = curMonthYear > firstMonthYear
            self.navigationItem.title = monthYear2DateStr(curMonthYear)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCircleBtn(incomeBtn)
        prepareCircleBtn(spendBtn)
        addNavButtons()
        segmentType.selectedSegmentIndex = 0
        NotificationCenter.default.addObserver(self,//Небольшой костыль-сохранение по сворачиванию
                                               selector: #selector(sceneWillResignActiveNotification(_:)),
                                               name: UIApplication.willResignActiveNotification,
                                               object: nil)
        let demo = Persistance.shared.isDemoMode
        if demo == nil {//первый запуск, покажем диалог
            showDemoModeDlg()
        }
        else {
            demoOffBtn.isHidden = !demo!
        }
        updateFirstEndDateMonth()
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
    
    private func showDemoModeDlg(){//покажем диалог запуска демо режима
        let alert = UIAlertController(title: String.localized("demo_mode"),
                                      message: String.localized("demo_mode_prompt"), preferredStyle: .alert)

        let yesAction = UIAlertAction(title: String.localized("yes") , style: .default) {
            (action: UIAlertAction!) -> Void in
            SpendData.Data.generateDemoData()
            self.updateFirstEndDateMonth()
            Persistance.shared.isDemoMode = true
            self.demoOffBtn.isHidden = false
        }
               
        let noAction = UIAlertAction(title: String.localized("no"), style: .default) {
           (action: UIAlertAction!) -> Void in
        }
        alert.addAction(yesAction)
        alert.addAction(noAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    private func prepareCircleBtn(_ btn: UIButton){//делаем кнопки круглыми
        btn.layer.cornerRadius = max(btn.bounds.width, btn.bounds.height)*0.5
        btn.layer.borderWidth = 5
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
//        let date = Date()
        //let from = Date.from(date.getComponent(.year),date.getComponent(.month), 1)
        if let from = Date.fromMonthYear(curMonthYear),
           let to = Date.fromMonthYear(curMonthYear + 1){
            let data = SpendData.Data.getSpends(from: from, to: to, type: segmentType.selectedSegmentIndex == 0 ? .outcome: .income)
            updateChart(data)
        }
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
        var curMonth=Date().toMonthYear()
        if curMonth > endMonthYear {
            curMonth = endMonthYear
        }
        if curMonth < firstMonthYear {
            curMonth = firstMonthYear
        }
        curMonthYear=curMonth
    }
    
    private func monthYear2DateStr(_ monthYear: Int, _ monthName: Bool = false)-> String?{//число даты в строку для кнопок
        if let date = Date.fromMonthYear(monthYear){
            if monthName {//нужно только месяц как текст
                return date.toString("MMM")
            }
            else {
                return date.toString("MM.yyyy")
            }
        }
        else {
            return nil
        }
    }
    
    private func addNavButtons() {//добавляем кнопки на навбар
        let prevBtn=UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.prevMonthAction(_:)))
        self.navigationItem.setLeftBarButton(prevBtn, animated: true)
        self.navigationItem.leftBarButtonItem?.isEnabled = true

        let nextBtn=UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(self.nextMonthAction(_:)))
        self.navigationItem.setRightBarButton(nextBtn, animated: true)
        self.navigationItem.rightBarButtonItem?.isEnabled = true
    }
    
    @IBAction func prevMonthAction(_ sender: UIButton) {//переходим на месяц назад
        curMonthYear = curMonthYear - 1
    }
    
    @IBAction func nextMonthAction(_ sender: UIButton) {//переходим на месяц вперед
        curMonthYear = curMonthYear + 1
    }
    
    @IBAction func demoOffPressed(_ sender: Any) {
        SpendData.Data.Spends.clear()
        Persistance.shared.isDemoMode = false
        updateFirstEndDateMonth()
        updateChart()
        demoOffBtn.isHidden = true
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
