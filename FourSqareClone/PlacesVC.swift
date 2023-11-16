//
//  PlacesVC.swift
//  FourSqareClone
//
//  Created by Jinu on 08/11/23.
//

import UIKit
import ParseCore
class PlacesVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var placeNameArray = [String]()
    var placeidArray = [String]()
    var selectedPlaceId = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.add, target: self, action: #selector(addButtonCLicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem = UIBarButtonItem(title: "Logout", style: UIBarButtonItem.Style.plain, target: self, action: #selector(logoutButtonClicked))
        self.tableView.delegate = self
        self.tableView.dataSource = self
        getDataFromParse()
    }
    func getDataFromParse(){
        
        let query = PFQuery(className: "Places")
        query.findObjectsInBackground { objects, error in
            if error != nil{
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
            }else{
                if objects != nil{
                    self.placeNameArray.removeAll(keepingCapacity: false)
                    self.placeidArray.removeAll(keepingCapacity: false)
                    for object in objects!{
                       if let placeName = object.object(forKey: "name") as? String{
                           if let placeId = object.objectId as? String{
                               self.placeNameArray.append(placeName)
                               self.placeidArray.append(placeId)
                           }
                        }
                    }
                    self.tableView.reloadData()
                }
            }
        }
    }
    @objc func addButtonCLicked(){
        //segue
        performSegue(withIdentifier: "toAddPlaceVC", sender: nil)
    }
    @objc func logoutButtonClicked(){
        PFUser.logOutInBackground { error in
            if error != nil{
                self.makeAlert(title: "Error!", message: error?.localizedDescription ?? "Error")
            }
        }
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //
        if segue.identifier == "toDetailVC"{
            let destinationVC = segue.destination as! DetailVC
            destinationVC.chosenPlaceId = selectedPlaceId
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text  = placeNameArray[indexPath.row]
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return placeNameArray.count
    }
    func makeAlert(title: String, message: String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okBuutton = UIAlertAction(title: "ok", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(okBuutton)
        self.present(alert, animated: true)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedPlaceId = placeidArray[indexPath.row]
        self.performSegue(withIdentifier: "toDetailVC", sender: nil)

    }
}
