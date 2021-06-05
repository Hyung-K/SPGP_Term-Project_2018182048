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
    
    var postsArriv = NSMutableArray()
    var elementsArriv = NSMutableDictionary()
    var elementArriv = NSString()
    
    var routeName = NSMutableString()
    var routeId = NSMutableString()
    var routeTypeName = NSMutableString()
    
    var stationID = NSMutableString()
    var locationX = NSMutableString()
    var locationY = NSMutableString()
   
    var routeID = NSMutableString()
    var stationName = NSMutableString()
    var stationSeq = NSMutableString()
    
    var plateNo1 = NSMutableString()
    var plateNo2 = NSMutableString()
    var predictTime1 = NSMutableString()
    var predictTime2 = NSMutableString()
    var remainSeatCnt1 = NSMutableString()
    var remainSeatCnt2 = NSMutableString()
    var routeIdArriv = NSMutableString()
    
    var locationNo1 = NSMutableString()
    var locationNo2 = NSMutableString()
    var stationIdArrive = NSMutableString()
    
    @IBOutlet weak var busListTableView: UITableView!
    
    @IBAction func backwardViewController(segue: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        busListTableView.estimatedRowHeight = 60
        busListTableView.rowHeight = 60
        
        if currentCategory == 0 {
            beginXMLFileParsing(category: currentCategory, parameter: "stationId", value: stationID)
        } else if currentCategory == 1 {
            beginXMLFileParsing(category: currentCategory, parameter: "routeId", value: routeID)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? MapViewController else {
            guard let weatherViewController = segue.destination as? WeatherViewController else { return }
            
            if self.currentCategory == 0 {
                weatherViewController.locationX = self.locationX
                weatherViewController.locationY = self.locationY
            }
            return
        }
        
        let cell = sender as! UITableViewCell
        let indexPath = self.busListTableView.indexPath(for: cell)
        
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
        
        if category == 0 || category == 1 {
            posts = []
        } else {
            postsArriv = []
        }
        
        parser = XMLParser(contentsOf: (URL(string: quaryURL))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("BusInfo XML Parsing Success!")
        } else {
            print("BusInfo XML Parsing Failure!")
        }
        if category == 0 || category == 1 {
            busListTableView!.reloadData()
        }
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDicr: [String: String]) {
        element = elementName as NSString
        
        if (elementName as NSString).isEqual(to: "busRouteList") {
            elements = NSMutableDictionary()
            elements = [:]
            routeName = NSMutableString()
            routeName = ""
            routeId = NSMutableString()
            routeId = ""
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
            } else if element.isEqual(to: "routeId") {
                routeId.append(string)
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
            }
            if !routeId.isEqual(nil) {
                elements.setObject(routeId, forKey: "routeId" as NSCopying)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! BusInformationTableViewCell
        
        if currentCategory == 0 {
            cell.titleLabel.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
            print(postsArriv.count)
            for i in 0..<postsArriv.count {
                if ((posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeId") as! NSString == (postsArriv[i] as AnyObject).value(forKey: "routeId") as! NSString as! NSMutableString) {
                    let t = (postsArriv[i] as AnyObject).value(forKey: "locationNo1") as! NSString as! NSMutableString as String
                    cell.locationNo1.text = String("\(t)전")
                    
                    let t2 = (postsArriv[i] as AnyObject).value(forKey: "locationNo2") as! NSString as! NSMutableString as String
                    cell.locationNo2.text = String("\(t2)전")
                    
                    let t3 = (postsArriv[i] as AnyObject).value(forKey: "predictTime1") as! NSString as! NSMutableString as String
                    cell.predictTime1.text = String("\(t3)분")
                    
                    let t4 = (postsArriv[i] as AnyObject).value(forKey: "predictTime2") as! NSString as! NSMutableString as String
                    cell.predictTime2.text = String("\(t4)분")
                    
                    let t5 = (postsArriv[i] as AnyObject).value(forKey: "remainSeatCnt1") as! NSString as! NSMutableString as String
                    if t5 != "-1" {
                        cell.remainSeatCnt1.text = String("\(t5)석")
                    } else {
                        cell.remainSeatCnt1.text = String("만석")
                    }
                    
                    let t6 = (postsArriv[i] as AnyObject).value(forKey: "remainSeatCnt2") as! NSString as! NSMutableString as String
                    if t6 != "-1" {
                        cell.remainSeatCnt2.text = String("\(t6)석")
                    } else {
                        cell.remainSeatCnt2.text = String("만석")
                    }
                }
            }
            
            cell.busImage.isHidden = true
            cell.remainSeatCnt.isHidden = true
            cell.plateNo.isHidden = true
            
            cell.locationNo1.isHidden = false
            cell.locationNo2.isHidden = false
            cell.predictTime1.isHidden = false
            cell.predictTime2.isHidden = false
            cell.remainSeatCnt1.isHidden = false
            cell.remainSeatCnt2.isHidden = false
        } else if currentCategory == 1 {
            cell.busImage.isHidden = false
            cell.remainSeatCnt.isHidden = false
            cell.plateNo.isHidden = false
            
            cell.locationNo1.isHidden = true
            cell.locationNo2.isHidden = true
            cell.predictTime1.isHidden = true
            cell.predictTime2.isHidden = true
            cell.remainSeatCnt1.isHidden = true
            cell.remainSeatCnt2.isHidden = true
            
            cell.titleLabel.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
            cell.busImage.image = UIImage(named: "res/grayBus.png")
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
}
