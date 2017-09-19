//
//  ViewController.swift
//  FoodCamera
//
//  Created by DavidTran on 8/27/17.
//  Copyright © 2017 DavidTran. All rights reserved.
//


import Alamofire
import ObjectMapper
import SwiftyJSON



class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UICollectionViewDelegate,UICollectionViewDataSource {

    let myColor = mColor()
    @IBOutlet weak var lbElements: UILabel!
    @IBOutlet weak var lbCalories: UILabel!
    @IBOutlet weak var elementFoodCollectionView: UICollectionView!
    @IBOutlet weak var groupFoodCollectionView: UICollectionView!
    @IBOutlet weak var foodName: UILabel!
    @IBOutlet weak var capturedImage: UIImageView!
    
    var mResponse:Json4Swift_Base?
    var groupFoodArray = [String]()
    var selectedGroupIndex = 0
    var itemFoods:[Items]?
    var selectedIndexPath:IndexPath = IndexPath(item: 0, section: 0)
    var selectedItemFoodIndex = 0
    
    
    
    let apiKey = "2298bc2c894211317815b91de0d41882"
    let url = "https://api-2445582032290.production.gw.apicast.io/v1/foodrecognition?user_key="
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        capturedImage.layer.cornerRadius = 10
        // Do any additional setup after loading the view, typically from a nib.
     
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnLibrary(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.photoLibrary
            ){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary;
            imagePicker.allowsEditing = true
            self.present(imagePicker,animated: true,completion: nil)
        }
        
    }
    @IBAction func btnFoodInfo(_ sender: Any) {
        showAnalyzingFood()
        selectedIndexPath = IndexPath(item: 0, section: 0)
        let cropedImage = capturedImage.image?.resized(toWidth: 544.0)
        let imageData = UIImageJPEGRepresentation(cropedImage!, 1)
       
        Alamofire.upload(multipartFormData:{ multipartFormData in
           
            multipartFormData.append(imageData!, withName: "image", mimeType: "multipart/form-data")},
                         usingThreshold:UInt64.init(),
                         to:url+apiKey,
                         method:.post,
                         encodingCompletion: { encodingResult in
                            switch encodingResult {
                            case .success(let upload, _, _):
                               
                                upload.responseString { response in
                                    //debugPrint(response.result)
                                    print(response.result.value!)
                                    
                                    let apiResponse:Json4Swift_Base = Mapper<Json4Swift_Base>().map(JSONString: response.result.value!)!
                                    
                                    self.mResponse = apiResponse
                                    self.foodName.text = self.mResponse?.results?[0].items?[0].name
                                    
                                    self.groupFoodArray.removeAll()
                                    for groupResult in (self.mResponse?.results!)!
                                    {
                                        debugPrint("\(String(describing: groupResult.group))\n")
                                        
                                        self.groupFoodArray.append(groupResult.group!)
                                        
                                      
                                    }
                                    
                                     self.groupFoodCollectionView.reloadData()
                                     self.itemFoods = self.mResponse?.results?[0].items!
                                    
                                     self.elementFoodCollectionView.reloadData()
                                    
                                    
                                  
                                    self.closeAnalyzingFood()
 
                                }
                            case .failure(let encodingError):
                                print(encodingError)
                                self.closeAnalyzingFood()
                            }
        })
        
    }
    
    func saveImage(_ sender: Any) {
        let imageData = UIImageJPEGRepresentation(capturedImage.image!, 4)
        let compressJPEGImage = UIImage(data:imageData!)
        UIImageWriteToSavedPhotosAlbum(compressJPEGImage!, nil, nil, nil)
        
        saveNotice()
    }
    @IBAction func btnCapture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            
            imagePicker.allowsEditing = false
            self.present(imagePicker,animated: true,completion: nil)
            
        }
    
    }
   
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image:UIImage!,editingInfo:[NSObject:AnyObject]) {
        //let cropedImage = image.resized(toWidth: 544.0)
        capturedImage.image = image
        self.dismiss(animated: true, completion: nil);
        
    }
    
    func saveNotice(){
        let alertController = UIAlertController(title: "Image Saved", message: "Your Image saved successfully", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController,animated: true,completion: nil)
    }
    func showAnalyzingFood()  {
        let alert = UIAlertController(title: nil, message: "Analyzing food...", preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        alert.view.addSubview(loadingIndicator)
        present(alert, animated: true, completion: nil)
    }
    func closeAnalyzingFood(){
        dismiss(animated: false, completion: nil)
    }
   
   
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if(collectionView == groupFoodCollectionView){
           //  Set color of first cell to normal
            if let firstCell = collectionView.cellForItem(at: IndexPath(item: 0, section: 0)){
                 firstCell.contentView.backgroundColor = myColor.squareCellColor            }
            
           
            
            // set color for new cell selected
            selectedIndexPath = indexPath
            let selectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
            selectedCell.contentView.backgroundColor = myColor.squareCellSelectedColor
            selectedGroupIndex = indexPath.row
            print("group food \(selectedGroupIndex) selected")
            
            itemFoods = (mResponse?.results?[selectedGroupIndex].items)!
            elementFoodCollectionView.reloadData()
            
        }
        else{
            selectedItemFoodIndex = indexPath.row
            print("selected item food index:\(selectedItemFoodIndex)")
            print("selected item food:\(itemFoods?[selectedItemFoodIndex].name)")
            
            let detailController = storyboard?.instantiateViewController(withIdentifier: "DetailController") as! DetailController
            detailController.itemFood = itemFoods?[selectedItemFoodIndex]
            navigationController?.pushViewController(detailController, animated: true)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if(collectionView == groupFoodCollectionView){
            if let deSelectedCell:UICollectionViewCell = collectionView.cellForItem(at: indexPath){
            deSelectedCell.contentView.backgroundColor = myColor.squareCellColor
            }
        
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == groupFoodCollectionView {
            return groupFoodArray.count
        }
        else{
            if(selectedGroupIndex>=0){
                if let count = mResponse?.results![selectedGroupIndex].items?.count{
                    if count>0 {
                        return count
                    }
                }
            }
            
        return 0
    }
    }
    
    // check if a particular cell showed
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        //if not seleted cell
         if collectionView == groupFoodCollectionView {
         if(indexPath.row != selectedIndexPath.row){
            cell.contentView.backgroundColor = myColor.squareCellColor
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if collectionView == groupFoodCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "groupFoodCollectionViewCell", for: indexPath) as! groupFoodCollectionViewCell
            // set radius corner view cell
            cell.layer.cornerRadius = 10
            
            cell.groupFood.text = groupFoodArray[indexPath.row]
            
              cell.contentView.backgroundColor = myColor.squareCellColor
            // set color  selected for first cell because selectedindexpath init is first cell
            if(indexPath.row == selectedIndexPath.row){
                cell.contentView.backgroundColor = myColor.squareCellSelectedColor
            }
            
            return cell
        }
    
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "elementFoodCollectionViewCell", for: indexPath) as! elementFoodCollectionViewCell
            if !(itemFoods?.isEmpty)!{
                let elementName = itemFoods?[indexPath.row].name
                cell.ElementFood.text = elementName
                let calories = itemFoods?[indexPath.row].nutrition?.calories
                print(elementName! + " \(calories!)")
                cell.Calories.text = "\(calories!)"
            }
            lbElements.isHidden = false
            lbCalories.isHidden = false
           
            return cell
        }

    }
    
    
}


