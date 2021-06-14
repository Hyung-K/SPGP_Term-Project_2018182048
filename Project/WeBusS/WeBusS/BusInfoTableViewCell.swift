//
//  BusInfoTableViewCell.swift
//  WeBusS
//
//  Created by Hyungkyun You on 2021/06/08.
//

import UIKit

class BusInfoTableViewCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locationNo1: UILabel!
    @IBOutlet weak var locationNo2: UILabel!
    @IBOutlet weak var predictTime1: UILabel!
    @IBOutlet weak var predictTime2: UILabel!
    @IBOutlet weak var remainSeatCnt: UILabel!
    @IBOutlet weak var busImage: UIImageView!
    @IBOutlet weak var plateNo: UILabel!
    @IBOutlet weak var remainSeatCnt1: UILabel!
    @IBOutlet weak var remainSeatCnt2: UILabel!
        
    override func awakeFromNib() {
        super.awakeFromNib()
    }
        
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
