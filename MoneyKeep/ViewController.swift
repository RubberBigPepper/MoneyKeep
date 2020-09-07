//
//  ViewController.swift
//  MoneyKeep
//
//  Created by Albert on 18.08.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var incomeBtn: UIButton!//кнопка дохода
    @IBOutlet weak var spendBtn: UIButton!//кнопка расхода
    
    override func viewDidLoad() {
        super.viewDidLoad()
         prepareCircleBtn(incomeBtn)
         prepareCircleBtn(spendBtn)
    }
    
    private func prepareCircleBtn(_ btn: UIButton){
        btn.layer.cornerRadius = max(btn.bounds.width, btn.bounds.height)*0.5
        btn.layer.borderWidth = 3
        btn.layer.borderColor = btn.currentTitleColor.cgColor
        showAddSpendIncomeDlg(false)
    }

    @IBAction func incomePressed(_ sender: Any) {
        showAddSpendIncomeDlg(true)
    }
    
    @IBAction func spendPressed(_ sender: Any) {
        showAddSpendIncomeDlg(false)
    }
    
    
    private func showAddSpendIncomeDlg(_ income: Bool){//покажем диалог ввода траты или прихода денег
        if let viewController = self.storyboard?.instantiateViewController(withIdentifier: "AddSpendIncome") as? AddSpendViewController {
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

