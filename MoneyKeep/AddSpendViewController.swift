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
    @IBOutlet weak var collectionView: UICollectionView!

    @IBOutlet weak var datePicker: UIDatePicker!
    private var datePickerHeight: CGFloat = 60.0//Высота пикера при раскрывании
    
    public var isSpend = true//флаг запуска на траты или поступления
    
    private let itemsPerRow: CGFloat = 3
    private let minimumItemSpacing: CGFloat = 8
    let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        textDescribe.delegate = self
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    @IBAction func btnDatePressed(_ sender: UIButton) {
//        if !datePicker.isHidden {
//            datePickerHeight = datePicker.frame.size.height
//            datePicker.isHidden = true
//            datePicker.frame.size.height = 0
//        }
//        else{
//            datePicker.isHidden = false
//            datePicker.frame.size.height = datePickerHeight
//        }
        selectDate()
    }
    
    private func selectDate(){//календарь выбора даты
        let calendar = YYCalendar(normalCalendarLangType: .ENG, date: "07/01/2019", format: "MM/dd/yyyy") { date in
//            btnDate.setTitle(<#T##title: String?##String?#>, for: <#T##UIControl.State#>)
        }

        calendar.show()
    }
    
    private func selectDateAsPopupController(){
        let vc = CalendarViewController()
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        present(vc, animated: true, completion: nil)
    }
}

extension AddSpendViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
//адаптер для отображения категорий в таблице
    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       sizeForItemAt indexPath: IndexPath) -> CGSize {
       let paddingSpace = sectionInsets.left + sectionInsets.right + minimumItemSpacing * (itemsPerRow - 1)
       let availableWidth = collectionView.bounds.width - paddingSpace
       let widthPerItem = availableWidth / itemsPerRow
       return CGSize(width: widthPerItem, height: widthPerItem)
    }

    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       insetForSectionAt section: Int) -> UIEdgeInsets {
       return sectionInsets
    }

    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumLineSpacingForSectionAt section: Int) -> CGFloat {
       return 10
    }

    func collectionView(_ collectionView: UICollectionView,
                       layout collectionViewLayout: UICollectionViewLayout,
                       minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
       return minimumItemSpacing
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //didSelectItem?(indexPath)
        if let value = calculatorView.result, value != 0.0 {//все нормально, расход правильный
            self.navigationController?.popViewController(animated: true)
//            dismiss(animated: true, completion: nil)
            return
        }//иначе - мигаем лабелью, что типа неправильное значение расхода
        calculatorView.BlinkLabelRed()
    }
    
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.lightGray
    }
    
    func collectionView(_ collectionView: UICollectionView, didUnhighlightItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = UIColor.clear
    }

}

extension AddSpendViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
