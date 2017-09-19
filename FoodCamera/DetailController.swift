//
//  DetailController.swift
//  FoodCamera
//
//  Created by DavidTran on 8/29/17.
//  Copyright © 2017 DavidTran. All rights reserved.
//

import Foundation

import ObjectMapper
import SwiftyJSON



class DetailController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    let myColor = mColor()
    @IBOutlet weak var lbElementName: UILabel!
    @IBOutlet weak var ServingSizeCollectionView: UICollectionView!
    
    
    @IBOutlet weak var servCalories: UILabel!
    @IBOutlet weak var servCarbs: UILabel!
    @IBOutlet weak var servFat: UILabel!
    @IBOutlet weak var servProtetin: UILabel!
    
    @IBOutlet weak var totalCalories: UILabel!
    @IBOutlet weak var totalFat: UILabel!
    @IBOutlet weak var totalCarbs: UILabel!
    @IBOutlet weak var totalProtein: UILabel!
    
    var selectedIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    var selectedItemServSizeIndex = 0
    
    var itemFood:Items?
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        lbElementName.text = itemFood?.name
        var strCalories = "-"
        var strProtetin = "-"
        var strFat = "-"
        var strCarbs = "-"
        
        if let calories = itemFood?.nutrition?.calories{
            strCalories =  String(format: "%.1f g",Double(calories))
        }
        if let protein = itemFood?.nutrition?.protein
        {
            strProtetin = String(format: "%.1f g", protein*1000)
        }
        if let fat = itemFood?.nutrition?.totalFat
        {
            strFat = String(format: "%.1f g", fat*1000)
        }
        if let carbs = itemFood?.nutrition?.totalCarbs
        {
            strCarbs = String(format: "%.1f g", carbs*1000)
        }
        
        totalCalories.text = strCalories
        totalCarbs.text = strCarbs
        totalProtein.text = strProtetin
        totalFat.text = strFat
        
        let  firstCell = ServingSizeCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))
            firstCell?.contentView.backgroundColor = myColor.squareCellSelectedColor
        setNutritionForServing(servingSize: (itemFood?.servingSizes?[0])!)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (itemFood?.servingSizes?.count)!
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ServSizeCollectionViewCell", for: indexPath) as! ServSizeCollectionViewCell
        
        cell.lbServSize.text = itemFood?.servingSizes?[indexPath.row].unit
        cell.lbServSize.lineBreakMode = NSLineBreakMode.byWordWrapping
        cell.lbServSize.numberOfLines = 0
        cell.layer.cornerRadius = 10
        cell.contentView.backgroundColor = myColor.squareCellColor
        
        // set color for first cell because selectedindexpath init is first cell
        if(indexPath.row == selectedIndexPath.row){
            cell.contentView.backgroundColor = myColor.squareCellSelectedColor
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        //set color to normal for first cell
        if let  firstCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)){
            firstCell.contentView.backgroundColor = myColor.squareCellColor
        }
        
        // set color for new cell
        let cell = collectionView.cellForItem(at: indexPath)!
        cell.contentView.backgroundColor = myColor.squareCellSelectedColor
        selectedIndexPath = indexPath
        selectedItemServSizeIndex = indexPath.row
        setNutritionForServing(servingSize: (itemFood?.servingSizes?[indexPath.row])!)
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
              cell.contentView.backgroundColor = myColor.squareCellColor
        }
      
    
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if(indexPath.row != selectedIndexPath.row){
           
            cell.contentView.backgroundColor = myColor.squareCellColor
        }
        
    }
    
    
    func setNutritionForServing(servingSize:ServingSizes) {
       
     
        var strCalories = "-"
        var strProtetin = "-"
        var strFat = "-"
        var strCarbs = "-"
        
        if let calories = itemFood?.nutrition?.calories{
           strCalories =  String(format: "%.1f g",Double(calories)*servingSize.servingWeight)
        }
        if let protein = itemFood?.nutrition?.protein
        {
            strProtetin = String(format: "%.1f g", protein*1000*servingSize.servingWeight)
        }

        if let fat = itemFood?.nutrition?.totalFat
        {
            strFat = String(format: "%.1f g", fat*1000*servingSize.servingWeight)
        }
        if let carbs = itemFood?.nutrition?.totalCarbs
        {
            strCarbs = String(format: "%.1f g", carbs*1000*servingSize.servingWeight)
        }

        servCalories.text = strCalories
        servProtetin.text = strProtetin
        servFat.text = strFat
        servCarbs.text = strCarbs
    }

}
