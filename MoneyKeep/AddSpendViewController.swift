//
//  AddSpendViewController.swift
//  MoneyKeep
//
//  Created by Albert on 04.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit
import KDCalendar

class AddSpendViewController: UIViewController {

    @IBOutlet weak var btnDate: UIButton!
    @IBOutlet weak var calculatorView: CalculatorView!
    @IBOutlet weak var textDescribe: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    public var isSpend = true//флаг запуска на траты или поступления
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnDatePressed(_ sender: UIButton) {
        selectDate()
    }
    
    private func selectDate(){
        let alert = UIAlertController(title: "Выберите дату",
        message: "Add a new to do text", preferredStyle: .alert)

        let calendarView = CalendarView()//frame: CGRectMake(0, 0, CGRectGetWidth(alert.view.frame), 320))
      //  calendarView.stop

        alert.view.addSubview(calendarView)
        alert.view.heightAnchor.constraint(equalToConstant: 350).isActive = true
        calendarView.leadingAnchor.constraint(equalTo: alert.view.leadingAnchor).isActive = true
        calendarView.trailingAnchor.constraint(equalTo: alert.view.trailingAnchor).isActive = true
        calendarView.topAnchor.constraint(equalTo: alert.view.topAnchor, constant: 100).isActive = true
       
        
        let saveAction = UIAlertAction(title: "ОК", style: .default) {
            (action: UIAlertAction!) -> Void in
            let textField = alert.textFields![0]
        }
        alert.addAction(saveAction)
        
        present(alert, animated: true, completion: nil)
    }
    
}

extension AddSpendViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return CategoryCollection.Categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        let category = CategoryCollection.Categories.getCategory(indexPath.row)
        cell.labelName.text = category?.name
        cell.iconImage.image = ImageCollection.imagesPub.getImage (category!.imagePath, createNew: true)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
////        let widthScr = UIScreen.main.bounds.size.width/2
//        let widthScr = collectionView.bounds.size.width/2
//        return CGSize(width: widthScr, height: widthScr)
//    }
    
}
