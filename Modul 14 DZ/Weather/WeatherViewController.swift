//
//  WeatherViewController.swift
//  Modul 14 DZ
//
//  Created by Vladimir Karsakov on 11.01.2021.
//

import UIKit
import RealmSwift

class WeatherViewController: UIViewController {
    
    private let realm = try! Realm()
    var objectsSaveRealm: Results<List1Realm>!
    var arrayItem = [List1]()
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadModels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        objectsSaveRealm = realm.objects(List1Realm.self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        dataUpdate()
    }
    
    func loadModels(){
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/forecast?q=Moscow&appid=73dab9894ae5686441c42bb1b502ba3b&lang=ru") else { return }
        let task = URLSession.shared.dataTask(with: url) { [self] (data, response, error) in
            do{
                if error == nil, let data = data{
                    
                    let decoder = JSONDecoder()
                    let finalResult = try decoder.decode(Model.self, from: data)
                    
                    arrayItem = finalResult.list
                    
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
        task.resume()
    }
    
    func dataUpdate(){
        try! realm.write{
            realm.deleteAll()
        }
            
        for object in arrayItem{
            let list1Realm = List1Realm()
            list1Realm.data = object.date
            list1Realm.icon = object.weather[0].icon
            list1Realm.temp = object.main.temp
                
            try! realm.write{
                realm.add(list1Realm)
            }
        }
        self.tableView.reloadData()
    }
}

extension WeatherViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objectsSaveRealm.isEmpty ? 0 : objectsSaveRealm.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellWeather") as! TableViewCell
            cell.dateLabel.text = objectsSaveRealm[indexPath.row].data
            cell.imageViewPicture.image = UIImage(named: "\(objectsSaveRealm[indexPath.row].icon)")
            cell.temperatureLabel.text = "\(Int(objectsSaveRealm[indexPath.row].temp - 273.15))"
            return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
