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
    
    @IBOutlet weak var chartView: PieChartView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         prepareCircleBtn(incomeBtn)
         prepareCircleBtn(spendBtn)
        let players = ["Ozil", "Ramsey", "Laca", "Auba", "Xhaka", "Torreira"]
        let goals = [6, 8, 26, 30, 8, 10]
        customizeChart(dataPoints: players, values: goals.map{ Double($0) })
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
    }
    
    
    private func prepareCircleBtn(_ btn: UIButton){
        btn.layer.cornerRadius = max(btn.bounds.width, btn.bounds.height)*0.5
        btn.layer.borderWidth = 3
        btn.layer.borderColor = btn.currentTitleColor.cgColor
        //showAddSpendIncomeDlg(false)
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
    
    private func customizeChart(dataPoints: [String], values: [Double]) {
      
      // 1. Set ChartDataEntry
      var dataEntries: [ChartDataEntry] = []
      for i in 0..<dataPoints.count {
        let dataEntry = PieChartDataEntry(value: values[i], label: dataPoints[i], data: dataPoints[i] as AnyObject)
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
  
}

extension ViewController: AddSpendDone{
    func SpendAdded(_ item: SpendItem) {
        SpendData.Data.Spends.addItem(item)
//        SpendCollection.Spends.addItem(item)
    }
}
