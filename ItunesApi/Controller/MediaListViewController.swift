//
//  MediaListViewController.swift
//  ItunesApi
//
//  Created by Halil Kaya on 21.11.2021.
//  Copyright © 2021 kaya. All rights reserved.
//

import UIKit

class MediaListViewController: BaseViewController {
    @IBOutlet weak var searchBar: UISearchBar!
    
    let client = iTunesService()
    private var mediaList : [MediaUIModel] = []
    
    /// Search Timer for throttling purposes
    var searchTimer : Timer?
    
    /// Setting bottom size for keyboard events
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var collectionViewMedia: UICollectionView!
    
    var optionsFilterType : [FilterType] = [.all, .movie, .podcast, .song]
    var pickerViewFilterType = UIPickerView()
    var selectedFilterTpe : FilterType = .all {
        didSet {
            self.searchBar.text = ""
            self.mediaList = []
            self.collectionViewMedia.reloadData()
        }
    }
    
    /// Temproary Text Field for using with UIPickerView
    let tempTextField = UITextField(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "main.title".localized
        
        setupCollectionView()
        
        setupFilterPickerView()
        
        searchBar.delegate = self
        
        searchBar.becomeFirstResponder()
        searchBar.placeholder = "main.searchbar.placeholder".localized
        
        //Setting placeholder view
        self.emptyPlaceHolderView = self.collectionViewMedia
        
        self.navigationItem.rightBarButtonItem =  UIBarButtonItem(image:Constants.Images.navIconFilter , style: UIBarButtonItem.Style.plain, target:self , action: #selector(filterTapped))
        
        self.subscribeForKeyboardNotifications()
    }
    
    func setupCollectionView() {
        self.collectionViewMedia.register(UINib(nibName: MediaCollectionViewCell.className, bundle: Bundle.main), forCellWithReuseIdentifier: MediaCollectionViewCell.className)
        self.collectionViewMedia.delegate = self
        self.collectionViewMedia.dataSource = self
        self.collectionViewMedia.contentInset = UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
    
    func setupFilterPickerView() {
        pickerViewFilterType.delegate = self
        pickerViewFilterType.dataSource = self
        
        self.view.addSubview(tempTextField)
        tempTextField.inputAccessoryView = toolBar
        tempTextField.inputView = pickerViewFilterType
    }
    
    //Detect Orientation Changes
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        
        collectionViewMedia.collectionViewLayout.invalidateLayout()
    }
    
    // Called when filter icon tapped.
    @objc func filterTapped(){
        tempTextField.becomeFirstResponder()
    }
    
    //Detect Keyboard Events
    override func keyboardDidShow(notification: NSNotification) {
        super.keyboardDidShow(notification: notification)
        
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        bottomConstraint.constant = keyboardFrame.height
    }
    
    override func keyboardWillHide(notification: NSNotification) {
        super.keyboardWillHide(notification: notification)
        bottomConstraint.constant = 0
    }
}

extension MediaListViewController  {
    /// Searches song with given term
    /// - Parameter term: term for search
    func searchSongsWithService(term : String) {
        self.isLoading = true
        self.showLoadingView()
        
        client.searchMedia(withTerm: term, filterType: selectedFilterTpe) { [weak self] uiModelList, error in
            self?.isLoading = false
            guard let self = self else{
                return
            }
            self.removeLoadingView()
            
            guard let error = error else{
                self.mediaList = []
                self.mediaList = self.filterDeletedMedia(mediaList: uiModelList)
                self.collectionViewMedia.reloadData()
                return
            }
            ViewUtil.displayErrorMessage(message: error.localizedDescription, vc: self)
        }
    }
    
    /// Filter deleted media from the list
    /// - Parameter mediaList: list of media items
    /// - Returns: filtered media list
    func filterDeletedMedia(mediaList : [MediaUIModel]) -> [MediaUIModel] {
        var filteredMediaList : [MediaUIModel] = []
        for (_, element) in mediaList.enumerated() {
            if !element.getIsDeleted() {
                filteredMediaList.append(element)
            }
        }
        return filteredMediaList
    }
    
    /// Deletes Media from the list which is in memory and DB
    /// - Parameter model: model to be deleted
    func deleteMedia(model : MediaUIModel) {
        
        guard let mediaId = model.getId() else {
            return
        }
        var foundIndex = -1
        for (index, element) in mediaList.enumerated() {
            if element.getId() == mediaId {
                foundIndex = index
                break
            }
        }
        guard  foundIndex != -1 else {
            return
        }
        
        Timer.scheduledTimer(withTimeInterval: Constants.MediaList.Time.deleteWait, repeats: false) { (_) in
            self.mediaList.remove(at: foundIndex)
            self.collectionViewMedia.deleteItems(at: [IndexPath(item: foundIndex, section: 0)])
        }
        DataService.sharedInstance.markMediaDeleted(mediaId: mediaId)
    }
}

//UICollectionView Delegate and DataSource
extension MediaListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        //Show Empty View If There is No Media.
        if mediaList.count == 0 {
            self.isEmptyList = true
        }
        else
        {
            self.isEmptyList = false
        }
        return mediaList.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell : MediaCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MediaCollectionViewCell.className, for: indexPath) as! MediaCollectionViewCell
        
        mediaList[indexPath.row].checkIsRead()
        cell.bindUIModel(uiModel: mediaList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        
        var width = collectionView.frame.size.width
        
        //Show Two Items per colon if screen is landscape.
        if UIApplication.shared.statusBarOrientation.isLandscape {
            width = width / Constants.MediaList.Dimensions.cellPerRowInLandscape
        }
        
        return CGSize(width: width - Constants.MediaList.Dimensions.cellWidthGap , height: Constants.MediaList.Dimensions.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.MediaList.Dimensions.cellInterspacing
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: Constants.MediaList.Dimensions.cellInterspacing, bottom: Constants.MediaList.Dimensions.cellInterspacing, right: Constants.MediaList.Dimensions.cellInterspacing);
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.MediaList.Dimensions.cellInterspacing
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = UIStoryboard.main.instantiateViewController(withIdentifier: EntityDetailViewController.className) as! EntityDetailViewController
        
        mediaList[indexPath.row].markRead()
        collectionView.reloadItems(at: [indexPath])
        
        vc.model = mediaList[indexPath.row]
        vc.delegate = self
        
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension MediaListViewController : UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        let trimmedSearchText = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let searchTimer = self.searchTimer {
            searchTimer.invalidate()
        }
        
        guard !trimmedSearchText.isEmpty else {
            self.mediaList = []
            self.collectionViewMedia.reloadData()
            return
        }
        searchTimer = Timer.scheduledTimer(withTimeInterval: Constants.MediaList.Time.searchThrottle, repeats: false, block: { (timer) in
            self.searchSongsWithService(term: trimmedSearchText)
        })
    }
    
    func searchBar(_ searchBar: UISearchBar, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        return !isLoading
    }
}

extension MediaListViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.optionsFilterType.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedOption = optionsFilterType[row]
        self.selectedFilterTpe = selectedOption
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return optionsFilterType[row].description
    }
}

extension MediaListViewController : EntityDetailActionDelegate {
    func mediaDeleted(model: MediaUIModel) {
        self.navigationController?.popToViewController(self, animated: true)
        deleteMedia(model: model)
    }
}
