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
    
    @IBOutlet weak var categoryChooseControl: UISegmentedControl!
    @IBOutlet weak var micButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var tableViewList: UITableView!
    @IBOutlet weak var searchTextField: UITextField!
    
    @IBAction func categoryChooseAction(_ sender: Any) {
        let index = categoryChooseControl.selectedSegmentIndex
        switch index {
        case 0:
            break
        case 1:
            break
        default:
            break
        }
    }
    @IBAction func micButtonAction(_ sender: Any) {
    }
    @IBAction func searchBuutonAction(_ sender: Any) {
        beginXMLFileParsing(parameter: "keyword", value: String(searchTextField.text!))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beginXMLFileParsing(parameter:"keyword", value: "강남")
    }

    func beginXMLFileParsing(parameter: String, value: String) {
        
        let path = "http://openapi.gbis.go.kr/ws/rest/busstationservice?serviceKey=cOXFXk2qE%2FhuIiYcsMQ4gv032heBUTwuP%2FDQwW0TskxrWGtrdVC6bJPNmJ2CbVcFq6P1eirV9X5d5fql75eeRg%3D%3D&keyword="
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
        
        if (elementName as NSString).isEqual(to: "busStationList") {
            elements = NSMutableDictionary()
            elements = [:]
            stationName = NSMutableString()
            stationName = ""
            SiName = NSMutableString()
            SiName = ""
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "stationName") {
            stationName.append(string)
        } else if element.isEqual(to: "regionName") {
            SiName.append(string)
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        if (elementName as NSString).isEqual(to: "busStationList") {
            if !stationName.isEqual( nil) {
                elements.setObject(stationName, forKey: "stationName" as NSCopying)
            }
            if !SiName.isEqual(nil) {
                elements.setObject(SiName, forKey: "regionName" as NSCopying)
            }
            posts.add(elements)
            print(posts)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "stationName") as! NSString as String
        cell.detailTextLabel?.text = (posts.object(at: indexPath.row) as AnyObject).value(forKey: "regionName") as! NSString as String
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
}
