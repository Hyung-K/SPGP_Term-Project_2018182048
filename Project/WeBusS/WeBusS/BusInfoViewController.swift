//
//  BusInfoViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/21.
//

import UIKit

class BusInfoViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var currentCategory : Int = 0
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var routeName = NSMutableString()
    var routeTypeName = NSMutableString()
    var stationID = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
    var routeID = NSMutableString()
    var stationName = NSMutableString()
    var stationSeq = NSMutableString()
    
    @IBOutlet weak var busListTableView: UITableView!
    
    @IBAction func backwardViewController(segue: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
//        beginXMLFileParsing(parameter: "stationId", value: stationID)
        if currentCategory == 0 {
            beginXMLFileParsing(category: currentCategory, parameter: "stationId", value: stationID)
        } else if currentCategory == 1 {
            beginXMLFileParsing(category: currentCategory, parameter: "routeId", value: routeID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let cell = sender as! UITableViewCell
        let indexPath = self.busListTableView.indexPath(for: cell)
        
        guard let secondViewController = segue.destination as? MapViewController else {return}
        if currentCategory == 0 {
            secondViewController.locationX = self.locationX
            secondViewController.locationY = self.locationY
        } else if currentCategory == 1 {
            secondViewController.locationX = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "x") as! NSString as! NSMutableString
            secondViewController.locationY = (posts.object(at: indexPath!.row) as AnyObject).value(forKey: "y") as! NSString as! NSMutableString
        }
    }
    
    func beginXMLFileParsing(category: Int, parameter: String, value: NSMutableString) {
        var path = ""
        if category == 0 {
            path = "http://openapi.gbis.go.kr/ws/rest/busstationservice/route?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
        } else if category == 1 {
            path = "http://openapi.gbis.go.kr/ws/rest/busrouteservice/station?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
        }
        
        let quaryURL = path + parameter + "=" + String(value)
        
        posts = []
        parser = XMLParser(contentsOf: (URL(string: quaryURL))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("BusInfo XML Parsing Success!")
        } else {
            print("BusInfo XML Parsing Failure!")
        }
        busListTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDicr: [String: String]) {
        element = elementName as NSString
        
        if (elementName as NSString).isEqual(to: "busRouteList") {
            elements = NSMutableDictionary()
            elements = [:]
            routeName = NSMutableString()
            routeName = ""
            routeTypeName = NSMutableString()
            routeTypeName = ""
        } else if (elementName as NSString).isEqual(to: "busRouteStationList") {
            elements = NSMutableDictionary()
            elements = [:]
            stationName = NSMutableString()
            stationName = ""
            stationSeq = NSMutableString()
            stationSeq = ""
            locationX = NSMutableString()
            locationX = ""
            locationY = NSMutableString()
            locationY = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if currentCategory == 0 {
            if element.isEqual(to: "routeName") {
                routeName.append(string)
            } else if element.isEqual(to: "routeTypeName") {
                routeTypeName.append(string)
            }
        } else if currentCategory == 1 {
            if element.isEqual(to: "stationName") {
                stationName.append(string)
            } else if element.isEqual(to: "stationSeq") {
                stationSeq.append(string)
            } else if element.isEqual(to: "x") {
                locationX.append(string)
            } else if element.isEqual(to: "y") {
                locationY.append(string)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namepaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "busRouteList") {
            if !routeName.isEqual(nil) {
                elements.setObject(routeName, forKey: "routeName" as NSCopying)
                print(routeName)
            }
            if !routeName.isEqual(nil) {
                elements.setObject(routeName, forKey: "routeTypeName" as NSCopying)
            }
            posts.add(elements)
        } else if (elementName as NSString).isEqual(to: "busRouteStationList") {
            if !stationName.isEqual(nil) {
                elements.setObject(stationName, forKey: "staionName" as NSCopying)
            }
            if !stationSeq.isEqual(nil) {
                elements.setObject(stationSeq, forKey: "stationSeq" as NSCopying)
            }
            if !locationX.isEqual(nil) {
                elements.setObject(locationX, forKey: "x" as NSCopying)
            }
            if !locationY.isEqual(nil) {
                elements.setObject(locationY, forKey: "y" as NSCopying)
            }
            
            posts.add(elements)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if currentCategory == 0 {
            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
            cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeTypeName") as! NSString as String
        } else if currentCategory == 1 {
            cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "staionName") as! NSString as String
            cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationSeq") as! NSString as String
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
