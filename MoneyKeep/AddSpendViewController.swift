//
//  AddSpendViewController.swift
//  MoneyKeep
//
//  Created by Albert on 04.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class AddSpendViewController: UIViewController {

    @IBOutlet weak var dateTime: UIDatePicker!
    @IBOutlet weak var textDescribe: UITextField!
    @IBOutlet weak var textAmount: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!

    public var isSpend = true//флаг запуска на траты или поступления
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dateTime.maximumDate=Date()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
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
