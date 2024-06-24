//
//  TbvCell.swift
//  Created by GaliSrikanth on 22/06/24.

import UIKit

class TbvCell: UITableViewCell {
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var despLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(WithPostModel postM: PostModel) {
        self.backgroundColor = .clear
        self.selectionStyle = .none
        
        titleLbl.text = postM.title ?? ""
        despLbl.text  = postM.body ?? ""
    }
}
