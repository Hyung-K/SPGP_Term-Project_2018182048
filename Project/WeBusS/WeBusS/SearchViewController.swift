//
//  SearchViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/14.
//

import UIKit

class SearchViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var stationName = NSMutableString()
    var SiName = NSMutableString()
    var stationId = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    var routeName = NSMutableString()
    var regionName = NSMutableString()
    var routeId = NSMutableString()
    
    var currentCategory : Int = 0
    let busStationPath = "http://openapi.gbis.go.kr/ws/rest/busstationservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
    let busListPath = "http://openapi.gbis.go.kr/ws/rest/busrouteservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
    
    @IBOutlet weak var categoryChooseControl: UISegmentedControl!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func categoryChooseAction(_ sender: Any) {
        let index = categoryChooseControl.selectedSegmentIndex
        switch index {
        case 0:
            currentCategory = 0
            beginXMLFileParsing(path: busStationPath, parameter: "keyword", value: "강남")
        case 1:
            currentCategory = 1
            beginXMLFileParsing(path: busListPath, parameter: "keyword", value: "11")
            break
        default:
            break
        }
    }
    
    @IBAction func micButtonAction(_ sender: Any) {
    }
    
    @IBAction func searchBuutonAction(_ sender: Any) {
        if currentCategory == 0 {
            beginXMLFileParsing(path: busStationPath, parameter: "keyword", value: String(searchTextField.text!))
        } else if currentCategory == 1 {
            beginXMLFileParsing(path: busListPath, parameter: "keyword", value: String(searchTextField.text!))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        currentCategory = 0
        beginXMLFileParsing(path: busStationPath, parameter: "keyword", value: "강남")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else { return }
        
        let cell = sender as! UITableViewCell
        let indexPath = self.tableViewList.indexPath(for: cell)
        
        secondViewController.currentCategory = self.currentCategory
        
        if currentCategory == 0 {
            secondViewController.locationX = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "x") as! NSString as! NSMutableString
            secondViewController.locationY = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "y") as! NSString as! NSMutableString
            
            secondViewController.stationID = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "stationId") as! NSString as! NSMutableString
        } else if currentCategory == 1 {
            secondViewController.routeID = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "routeId") as! NSString as! NSMutableString
        }
    }

    func beginXMLFileParsing(path: String, parameter: String, value: String) {
        let valueEncoding = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let quaryURL = path + parameter + "=" + valueEncoding
        
        posts = []
//        parser = XMLParser(contentsOf: (URL(string: "https://openapi.gg.go.kr/BusStation?ServiceKey=6b722c447ca0430db1c15b6c0a08c4dd" ))!)!
        parser = XMLParser(contentsOf: (URL(string: quaryURL ))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("Search XML Parsing Success!")
        } else {
            print("Search XML Parsing Fail!!")
        }
        
        tableViewList!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        
        element = elementName as NSString
        
        if (elementName as NSString).isEqual(to: "busStationList") {
            elements = NSMutableDictionary()
            elements = [:]
            stationName = NSMutableString()
            stationName = ""
            SiName = NSMutableString()
            SiName = ""
            stationId = NSMutableString()
            stationId = ""
            locationX = NSMutableString()
            locationX = ""
            locationY = NSMutableString()
            locationY = ""
        }
        if (elementName as NSString).isEqual(to: "busRouteList") {
            elements = NSMutableDictionary()
            elements = [:]
            routeName = NSMutableString()
            routeName = ""
            regionName = NSMutableString()
            regionName = ""
            routeId = NSMutableString()
            routeId = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentCategory == 0 {
            if element.isEqual(to: "stationName"){
                stationName.append(string)
            }
            else if element.isEqual(to: "regionName") {
                SiName.append(string)
            }
            else if element.isEqual(to: "stationId") {
                stationId.append(string)
            }
            else if element.isEqual(to: "x") {
                locationX.append(string)
            }
            else if element.isEqual(to: "y") {
                locationY.append(string)
            }
        }
        else if currentCategory == 1 {
            if element.isEqual(to: "routeName") {
                routeName.append(string)
            }
            else if element.isEqual(to: "regionName") {
                regionName.append(string)
            }
            else if element.isEqual(to: "routeId") {
                routeId.append(string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "busStationList") {
            if !stationName.isEqual(nil) {
                elements.setObject(stationName, forKey: "stationName" as NSCopying)
            }
            if !SiName.isEqual(nil) {
                elements.setObject(SiName, forKey: "regionName" as NSCopying)
            }
            if !stationId.isEqual(nil) {
                elements.setObject(stationId, forKey: "stationID" as NSCopying)
            }
            if !locationX.isEqual(nil) {
                elements.setObject(locationX, forKey: "x" as NSCopying)
            }
            if !locationY.isEqual(nil) {
                elements.setObject(locationY, forKey: "y" as NSCopying)
            }
            posts.add(elements)
        }
        if(elementName as NSString).isEqual(to: "busRouteList") {
            if !routeName.isEqual( nil) {
                elements.setObject(routeName, forKey: "routeName" as NSCopying)
            }
            if !regionName.isEqual( nil) {
                elements.setObject(regionName, forKey: "regionName" as NSCopying)
            }
            if !routeId.isEqual( nil) {
                elements.setObject(routeId, forKey: "routeId" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if currentCategory == 0 {
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
            cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        }
        else if currentCategory == 1 {
            
                cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
                cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
