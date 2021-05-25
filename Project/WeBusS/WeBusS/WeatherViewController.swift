//
//  WeatherViewController.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/05/25.
//

import UIKit

class WeatherViewController: UIViewController,XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {

    var parser = XMLParser()
    var posts = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
        
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//    }
    
    func beginXmlFileParsing(path: String, parameter: String, value: String) {
        let valueEncoding = value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let quaryURL = path + parameter + "=" + valueEncoding
        
        posts = []
        parser = XMLParser(contentsOf:(URL(string: quaryURL ))!)!
        parser.delegate = self
        
        let success:Bool = parser.parse()
        if success {
            print("Weather Parsing Success")
        } else {
            print("Weather Parsing Fail!")
        }
        
        // listTableView!.reloadData()
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String: String]) {
        element = elementName as NSString
        if ( elementName as NSString ).isEqual(to: "busStationList") {
            
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI namspaceURI: String?, qualifiedName qName: String?) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let secondViewController = segue.destination as? BusInfoViewController else { return }
    }
}
