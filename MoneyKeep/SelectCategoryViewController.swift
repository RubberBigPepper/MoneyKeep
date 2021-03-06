//
//  SelectCategoryViewController.swift
//  MoneyKeep
//
//  Created by Albert on 30.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

protocol SelectCategoryDelegate {
    func CategorySelected(_ category: SpendCategory)
}

class SelectCategoryViewController: UIViewController {//контроллер, ответственный за категории

    @IBOutlet weak var collectionView: UICollectionView!

    private let itemsPerRow: CGFloat = 3
    private let minimumItemSpacing: CGFloat = 8
    private let sectionInsets = UIEdgeInsets(top: 16.0, left: 16.0, bottom: 20.0, right: 16.0)
    
    public var delegate: SelectCategoryDelegate? = nil
    public var isIncome = true//флаг запуска на траты или поступления, нужен для фильрации категорий
    
    private var categories: [SpendCategory] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if isIncome { categories = SpendData.Data.Categories.incomeCat }
        else { categories = SpendData.Data.Categories.outcomeCat}
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectCategoryViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        let category = categories[indexPath.row]
        cell.labelName.text = category.name
        cell.iconImage.image = ImageCollection.imagesPub.getImage (category.imagePath, createNew: true)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let category = categories[indexPath.row] //паренту говорим, что категория выбрана
        delegate?.CategorySelected(category)
        self.dismiss(animated: true, completion: nil)//и закрываем окно
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
