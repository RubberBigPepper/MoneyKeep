//
//  AddSpendViewController.swift
//  MoneyKeep
//
//  Created by Albert on 04.09.2020.
//  Copyright © 2020 Albert. All rights reserved.
//

import UIKit

class AddSpendViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}


extension AddSpendViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0//dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "CatCollectionCell", for: indexPath) as! CategoryCollectionViewCell
        //cell.labelText.text = self.dataArray[indexPath.row].1
      //  let iconName = dataArray[indexPath.row].0
       // cell.imageView.image = UIImage(named: iconName)
        return cell
    }
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
////        let widthScr = UIScreen.main.bounds.size.width/2
//        let widthScr = collectionView.bounds.size.width/2
//        return CGSize(width: widthScr, height: widthScr)
//    }
    
}
