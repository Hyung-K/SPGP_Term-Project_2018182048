//
//  BusInfoViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/21.
//

import UIKit

class BusInfoViewController: UIViewController, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    
    var routeName = NSMutableString()
    var routeTypeName = NSMutableString()
    var stationID = NSMutableString()
    
    @IBOutlet weak var busListTableView: UITableView!
    
    @IBAction func backwardViewController(segue: UIStoryboardSegue){
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        beginXMLFileParsing(parameter: "stationId", value: stationID)
    }
    
    func beginXMLFileParsing(parameter: String, value: NSMutableString) {
        let path = "http://openapi.gbis.go.kr/ws/rest/busstationservice/route?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&"
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
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "routeName") {
            routeName.append(string)
        }
        else if element.isEqual(to: "routeTypeName") {
            routeTypeName.append(string)
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
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "routeTypeName") as! NSString as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
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
