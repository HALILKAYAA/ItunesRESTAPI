//
//  EntityDetailViewController.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit

public protocol EntityDetailActionDelegate {
    func mediaDeleted(model : MediaUIModel)
}

class EntityDetailViewController: BaseViewController {
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var imgArtwork: UIImageView!
    @IBOutlet weak var lblCreator: UILabel!
    @IBOutlet weak var lblCountry: UILabel!
    @IBOutlet weak var lblType: UILabel!
    @IBOutlet weak var lblReleaseDate: UILabel!
    
    var model : MediaUIModel?
    
    var delegate : EntityDetailActionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "entitydetail.title".localized
        
        self.bindModel()
        
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image:Constants.Images.navIconTrash , style: UIBarButtonItem.Style.plain, target:self , action: #selector(deleteTapped))
    }
    
    func bindModel() {
        guard let model = self.model else {
            return
        }
        
        lblTitle.text = model.trackName ?? model.collectionName
        lblReleaseDate.text = model.releaseDate
        if let kind = model.kind {
            lblType.text = kind.rawValue
        }
        else {
            lblType.text = "Unknown"
        }
        
        lblCountry.text = model.country
        
        if let artworkUrl = model.artworkUrl {
            imgArtwork.loadImageFromUrl(url: artworkUrl)
        }
        lblCreator.text = model.artistName ?? "-"
    }
    
    @objc func deleteTapped(){
        ViewUtil.displayYesNoDialog(message: "entitydetail.dialog.remove".localized, vc: self, okAction: { (_) in
            
            guard let delegate = self.delegate, let model = self.model else {
                return
            }
            delegate.mediaDeleted(model: model)
        }, noAction: nil)
        
        
    }

}
