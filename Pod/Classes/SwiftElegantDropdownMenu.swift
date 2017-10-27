//
//  SwiftElegantDropdownMenu.swift
//  Demo
//
//  Created by Armin Likic on 22/11/2015.
//  Copyright © 2015 ProgramiranjeOrg. All rights reserved.
//

//  The MIT License (MIT)
//
//  Copyright (c) 2015 arminlikic
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit

open class SwiftElegantDropdownMenu : UIView {
    
    fileprivate var _configuration  : SwiftElegantDropdownMenuConfiguration?
    fileprivate var _title : UILabel?
    fileprivate var _items: [String]?
    fileprivate var _titleText: String!
    fileprivate var _menuButton: UIButton!
    fileprivate var wrapper : UIView? //view in which you wish to present the dropdown
    fileprivate var _dropdownList : SwiftElegantDropdownListTableView?
    fileprivate var _dropdownListWrapper: SwiftElegantDropdownListWrapperView?
    fileprivate var _topBorder : UIView?
    fileprivate var _selectedItem: String?
    fileprivate var _dropdownIcon: UIImageView?
    
    open var onItemSelect: ((_ index: Int, _ item: AnyObject?) -> ())?
    open var onMenuButtonTapped: ((_ willOpen: Bool) -> ())?
    
    open var items : [String]? {
        get {
            return self._items
        } set (value) {
            self._items = value
            self.renderDropdownView()
        }
    }
    
    open var configuration : SwiftElegantDropdownMenuConfiguration! {
        get {
            return self._configuration
        } set(value){
            self._configuration = value
            self.renderDropdownView()
        }
    }
    
    open var title: String? {
        get {
            return self._titleText
        } set(value) {
            self._titleText = value
            self.renderDropdownView()
        }
    }
    
    //available initializers
    convenience public init(title: String, items: [String]) {
        self.init(title: title, items: items, frame: nil, configuration: nil)
    }
    
    convenience public init(title: String, items: [String], wrapper: UIView?) {
        self.init(title: title, items: items, frame: nil, configuration: nil)
        self.wrapper = wrapper
    }
    
    convenience public init(title: String, items: [String], frame: CGRect?) {
        self.init(title: title, items: items, frame: frame, configuration: nil)
    }
    
    convenience public init(title: String, items: [String], frame: CGRect?, wrapper: UIView?) {
        self.init(title: title, items: items, frame: frame, configuration: nil)
        self.wrapper = wrapper
    }
    
    convenience public init(title: String, items: [String], configuration: SwiftElegantDropdownMenuConfiguration?) {
        self.init(title: title, items: items, frame: nil, configuration: configuration)
    }
    
    convenience public init(title: String, items: [String], configuration: SwiftElegantDropdownMenuConfiguration?, wrapper: UIView?) {
        self.init(title: title, items: items, frame: nil, configuration: configuration)
        self.wrapper = wrapper
    }
    
    override public init(frame: CGRect){
        super.init(frame: frame)
    }
    
    init(title: String, items: [String], frame: CGRect?, configuration: SwiftElegantDropdownMenuConfiguration?) {
        
        self._titleText = title
        self._items = items
        
        var _frame = CGRect(x: 0, y: 0, width: 300, height: 100)
        
        if let frame = frame {
            _frame = frame
        }
        
        super.init(frame: _frame)
        
        if let configuration = configuration {
            self._configuration = configuration
        } else {
            self._configuration = SwiftElegantDropdownMenuConfiguration.getDefaultConfiguration(self)
        }
        
        self.renderDropdownView()
        self.registerDropdown()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        
        self._titleText = "Title"
        super.init(coder: aDecoder)
        self._configuration = SwiftElegantDropdownMenuConfiguration.getDefaultConfiguration(self)
        self.renderDropdownView()
        self.registerDropdown()
        
    }
    
    fileprivate func registerDropdown(){
        
        if !SwiftElegantDropdownMenuObserverList.instances.contains(self){
            SwiftElegantDropdownMenuObserverList.instances.append(self)
        }
        
    }
    
    override open func setNeedsLayout() {
        
        super.setNeedsLayout()
        
        if let wrapper = self.wrapper {
            
            let positionInWindow = self.convert(self.bounds, to: nil)
            var verticalOffset = positionInWindow.origin.y + self.frame.size.height
            
            if !UIApplication.shared.isStatusBarHidden {
                verticalOffset += 20
            }
            
            self._dropdownListWrapper!.frame.origin.x = wrapper.frame.origin.x
            self._dropdownListWrapper!.frame.origin.y = verticalOffset
            self._dropdownListWrapper!.frame.size.width = wrapper.frame.size.width
            
            self._dropdownList!.frame.size.width = self._dropdownListWrapper!.frame.width
            self._topBorder?.frame.size.width = self._dropdownList!.frame.size.width
        }
        
    }
    
    //renders the dropdown view
    open func renderDropdownView() {
        
        if let _title = self._title {
            if _title.isDescendant(of: self){
                _title.removeFromSuperview()
            }
        }
        
        let buttonFrame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        
        self._title = UILabel(frame: buttonFrame)
        self._title!.text = self._titleText
        self._title!.textAlignment = NSTextAlignment.center
        self._title!.font = self.configuration.titleFont
        self._title!.textColor = self.configuration.titleColor
        self._title?.backgroundColor = self.configuration.headerBackgroundColor
        
        if let headerViewHeight = self.configuration.headerViewHeight {
            self._title?.frame = CGRect(x: self._title!.frame.origin.x, y: self._title!.frame.origin.y, width: self._title!.frame.size.width, height: headerViewHeight)
        }
        
        self._title?.frame.size.width = (self._title!.text! as NSString).size(attributes: [NSFontAttributeName:self._title!.font]).width
        
        self._title?.center = CGPoint(x: self.frame.width / 2, y: self._title!.frame.height / 2)
        
        self._menuButton = UIButton(frame: buttonFrame)
        
        self.addSubview(self._menuButton)
        self._menuButton.addSubview(self._title!)
        
        if let dropdownIconAsset = self.configuration.dropdownIconAssetName {
            let dropdownIcon = UIImage(named: dropdownIconAsset)
            
            if self._dropdownIcon == nil {
                
                self._dropdownIcon = UIImageView(frame: CGRect(x: self._title!.frame.origin.x + self._title!.frame.size.width, y: 0, width: 30, height: 30))
                self._dropdownIcon?.image = dropdownIcon
                
                self._menuButton.addSubview(self._dropdownIcon!)
                
            } else {
                
                self._dropdownIcon?.frame.origin.x = self._title!.frame.origin.x + self._title!.frame.size.width
                
            }
            
        }
        
        if self.items != nil {
            self.renderList()
        }
        
        self.setNeedsLayout()
        self._menuButton.addTarget(self, action: #selector(SwiftElegantDropdownMenu.menuButtonTapped(_:)), for: UIControlEvents.touchUpInside)
        
    }
    
    func menuButtonTapped(_ sender: UIButton){
        
        for menu in SwiftElegantDropdownMenuObserverList.instances {
            
            if menu != self {
                
                menu.hideList()
                
            }
            
        }
        
        if let handler = self.onMenuButtonTapped {
            
            if let dropdownList = self._dropdownList {
                
                handler(dropdownList.isHidden)
                
            }
            
        }
        
        self.toggleList()
        
    }
    
    fileprivate func renderList(){
        if self._dropdownList == nil && self.items != nil {
            if self.wrapper == nil {
                var wrapper = self.superview
                
                while wrapper != nil {
                    
                    self.wrapper = wrapper
                    wrapper = wrapper?.superview
                    
                }
            }
            
            if let wrapper = self.wrapper {
                
                let positionInWindow = self.convert(self.bounds, to: nil)
                var verticalOffset = positionInWindow.origin.y + self.frame.size.height
                
                if !UIApplication.shared.isStatusBarHidden {
                    
                    verticalOffset += 20
                }
                
                let wrapperFrame = CGRect(x: wrapper.frame.origin.x, y: verticalOffset, width: wrapper.frame.size.width, height: wrapper.frame.size.height)
                self._dropdownListWrapper = SwiftElegantDropdownListWrapperView(frame: wrapperFrame)
                self._dropdownListWrapper?.clipsToBounds = true
                self._dropdownListWrapper?.context = self
                
                wrapper.addSubview(self._dropdownListWrapper!)
                
                let tableFrame = CGRect(x: wrapper.frame.origin.x, y: verticalOffset, width: wrapper.frame.size.width, height: 0)
                
                self._dropdownList = SwiftElegantDropdownListTableView(frame: tableFrame, style: UITableViewStyle.plain, items: self.items!, context: self)
                
                self._dropdownList?.itemSelectHandler = { (index: Int, item: AnyObject?) -> () in
                    
                    if let handler = self.onItemSelect {
                        
                        handler(index, item)
                        
                    }
                    
                }
                
                if self.items != nil && self.items!.count > 0 && self.items!.count > self.configuration.dropdownListSelectedItemIndex && self.configuration.dropdownListSelectedItemIndex >= 0 {
                    
                    if let title = self.title {
                        
                        if self.items!.contains(title) {
                            
                            if let selectedIndex = self.items!.index(of: title) {
                                self.configuration.dropdownListSelectedItemIndex = selectedIndex
                            }
                            
                        }
                        
                    }
                    
                    self._dropdownList?.selectRow(at: IndexPath(row: self.configuration.dropdownListSelectedItemIndex, section: 0), animated: false, scrollPosition: UITableViewScrollPosition.top)
                    
                    self.title = self.items![self.configuration.dropdownListSelectedItemIndex]
                    
                }
                
                self._dropdownList!.isHidden = true
                
                self._dropdownList?.separatorInset = UIEdgeInsets.zero
                self._dropdownList?.layoutMargins = UIEdgeInsets.zero
                
                // self._dropdownList?.separatorInset.right = (self._dropdownList?.separatorInset.left)!
                
                self._dropdownListWrapper?.addSubview(self._dropdownList!)
                self._topBorder = UIView(frame: CGRect(x: 0, y: 0, width: self._dropdownListWrapper!.frame.width, height: 0.5))
                self._topBorder?.isHidden = true
                self._dropdownListWrapper?.addSubview(self._topBorder!)
                
            
                
            }
        }
        
        if let configuration = self.configuration, let dropdownList = self._dropdownList {
            dropdownList.backgroundColor = configuration.dropdownListBackgroundColor
            dropdownList.layer.borderWidth = configuration.dropdownListBorderWidth
            dropdownList.layer.borderColor = configuration.dropdownListBorderColor.cgColor
            self._topBorder?.backgroundColor = configuration.dropdownListBorderColor
        }
        
    }
    
    fileprivate func showList(){
        
        if !self._dropdownList!.isAnimating {
            
            self._dropdownList!.frame = CGRect(x: 0, y: -self._dropdownList!.frame.height, width: self._dropdownList!.frame.width, height: self._dropdownList!.frame.height)
            self._dropdownList?.isHidden = false
            
            if self._dropdownList!.frame.height > self.configuration.dropdownListMaxHeight {
                
                self._dropdownList!.frame.size.height = self.configuration.dropdownListMaxHeight
                
            }
            
            if let configuration = self.configuration {
                
                self._dropdownList?.isAnimating = true
                
                self._topBorder?.isHidden = false
                
                UIView.animate(withDuration: configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    
                    if let dropdownIcon = self._dropdownIcon {
                        if configuration.dropdownIconWillRotate {
                            
                            dropdownIcon.transform = CGAffineTransform(rotationAngle: CGFloat(M_PI))
                            
                        }
                    }
                    
                    self._dropdownList?.frame = CGRect(x: 0, y: 30, width: self._dropdownList!.frame.width, height: self._dropdownList!.frame.height)
                    }, completion: { (completed) -> Void in
                        
                        UIView.animate(withDuration: configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                            self._dropdownList?.frame = CGRect(x: 0, y: 0, width: self._dropdownList!.frame.width, height: self._dropdownList!.frame.height)
                            }, completion: { (completed) -> Void in
                                self._dropdownList?.isAnimating = false
                        })
                })
                
            }
            
        }
        
    }
    
    fileprivate func hideList(){
        
        if !self._dropdownList!.isAnimating {
            
            if let configuration = self.configuration {
                
                self._dropdownList?.isAnimating = true
                
                UIView.animate(withDuration: configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.curveEaseOut, animations: { () -> Void in
                    
                    if let dropdownIcon = self._dropdownIcon {
                        if configuration.dropdownIconWillRotate {
                            
                            dropdownIcon.transform = CGAffineTransform(rotationAngle: CGFloat(0))
                            
                        }
                    }
                    
                    self._dropdownList?.frame = CGRect(x: 0, y: -self._dropdownList!.frame.height, width: self._dropdownList!.frame.width, height: self._dropdownList!.frame.height)
                    }, completion: { (completed) -> Void in
                        if completed {
                            
                            self._dropdownList?.isAnimating = false
                            self._dropdownList?.isHidden = true
                            self._topBorder?.isHidden = true
                            
                        }
                })
                
            }
            
        }
        
    }
    
    fileprivate func toggleList(){
        
        if let dropdownList = self._dropdownList {
            
            if dropdownList.isHidden {
                self.showList()
            } else {
                self.hideList()
            }
            
        } else {
            
            self.renderList()
            self.showList()
            
        }
    }
}

//defines the looks and feels of the dropdown
open class SwiftElegantDropdownMenuConfiguration {
    
    fileprivate var context : SwiftElegantDropdownMenu?
    
    //attributes for the header of the dropdown
    fileprivate var _headerBackgroundColor: UIColor!
    fileprivate var _headerViewHeight: CGFloat?
    
    //attributes for the title (selected item)
    fileprivate var _titleColor : UIColor!
    fileprivate var _titleFont: UIFont!
    
    //attributes for the dropdown list items
    fileprivate var _cellHeight : CGFloat!
    fileprivate var _dropdownListBackgroundColor: UIColor!
    fileprivate var _cellFont: UIFont!
    fileprivate var _cellTextColor : UIColor!
    fileprivate var _dropdownListBorderColor: UIColor!
    fileprivate var _dropdownListBorderWidth: CGFloat!
    fileprivate var _dropdownListMaxHeight: CGFloat!
    fileprivate var _dropdownListSelectedItemIndex: Int!
    fileprivate var _dropdownListSelectedItemBackgroundColor: UIColor!
    fileprivate var _dropdownListSelectedItemAccessoryType : UITableViewCellAccessoryType!
    
    //animations
    fileprivate var _animationDuration : TimeInterval!
    
    //dropdown icon
    fileprivate var _dropdownIconAssetName: String?
    fileprivate var _dropdownIconWillRotate: Bool!
    
    //returns a prepopulated configuration set
    static open func getDefaultConfiguration(_ context: SwiftElegantDropdownMenu) -> SwiftElegantDropdownMenuConfiguration{
        
        let configuration = SwiftElegantDropdownMenuConfiguration(context: context)
        
        configuration.headerBackgroundColor = UIColor.clear
        
        configuration.titleColor = UIColor.black
        configuration.titleFont = UIFont(name: "HelveticaNeue", size: 17)!
        
        configuration.cellHeight = 40
        configuration.animationDuration = 0.3
        
        configuration.cellFont = UIFont(name: "HelveticaNeue", size: 17)!
        configuration.cellTextColor = UIColor.black
        
        configuration.dropdownListBackgroundColor = UIColor.white
        configuration.dropdownListBorderColor = UIColor.lightGray
        configuration.dropdownListBorderWidth = 0.5
        
        configuration.dropdownListMaxHeight = 200
        configuration.dropdownListSelectedItemIndex = 0
        
        configuration.dropdownListSelectedItemBackgroundColor = UIColor(red: 211/255, green: 234/255, blue: 242/255, alpha: 1.0)
        configuration.dropdownListSelectedItemAccessoryType = UITableViewCellAccessoryType.checkmark
        
        configuration.dropdownIconAssetName = "arrow"
        configuration.dropdownIconWillRotate = true
        
        
        return configuration
        
    }
    
    init(context: SwiftElegantDropdownMenu) {
        self.context = context
    }
    
}

//access methods
extension SwiftElegantDropdownMenuConfiguration {
    
    //attributes for the header of the dropdown
    public var headerBackgroundColor: UIColor {
        get {
            return self._headerBackgroundColor
        } set(value){
            self._headerBackgroundColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var headerViewHeight: CGFloat? {
        get {
            return self._headerViewHeight
        } set(value){
            self._headerViewHeight = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
    //attributes for the title (selected item)
    public var titleColor : UIColor {
        get {
            return self._titleColor
        } set(value) {
            self._titleColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var titleFont: UIFont {
        get {
            return self._titleFont
        } set(value){
            self._titleFont = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
    //attributes for the dropdown list items
    public var cellHeight : CGFloat {
        get {
            return self._cellHeight
        } set(value){
            self._cellHeight = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var animationDuration: TimeInterval {
        get {
            return self._animationDuration
        } set(value){
            self._animationDuration = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBackgroundColor: UIColor {
        get {
            return self._dropdownListBackgroundColor
        } set(value){
            self._dropdownListBackgroundColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var cellFont: UIFont {
        get {
            return self._cellFont
        } set(value){
            self._cellFont = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var cellTextColor: UIColor {
        get {
            return self._cellTextColor
        } set(value){
            self._cellTextColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBorderColor: UIColor {
        get {
            return self._dropdownListBorderColor
        } set(value){
            self._dropdownListBorderColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBorderWidth: CGFloat {
        get {
            return self._dropdownListBorderWidth
        } set(value){
            self._dropdownListBorderWidth = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListMaxHeight: CGFloat {
        get {
            return self._dropdownListMaxHeight
        } set(value){
            self._dropdownListMaxHeight = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemIndex: Int {
        get {
            return self._dropdownListSelectedItemIndex
        } set(value){
            self._dropdownListSelectedItemIndex = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemBackgroundColor: UIColor {
        get {
            return self._dropdownListSelectedItemBackgroundColor
        } set(value){
            self._dropdownListSelectedItemBackgroundColor = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemAccessoryType: UITableViewCellAccessoryType {
        get {
            return self._dropdownListSelectedItemAccessoryType
        } set(value){
            self._dropdownListSelectedItemAccessoryType = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
    //dropdown icon
    public var dropdownIconAssetName: String? {
        get {
            return self._dropdownIconAssetName
        } set(value){
            self._dropdownIconAssetName = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
    public var dropdownIconWillRotate: Bool {
        get {
            return self._dropdownIconWillRotate
        } set(value){
            self._dropdownIconWillRotate = value
            if let context = self.context, let _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
}

//dropdown menu list items
class SwiftElegantDropdownListTableView : UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var context: SwiftElegantDropdownMenu?
    var items: [String]?
    
    var isAnimating = false
    
    var itemSelectHandler: ((_ index: Int, _ item: AnyObject?) -> ())?
    
    convenience init(frame: CGRect, style: UITableViewStyle, items: [String], context: SwiftElegantDropdownMenu) {
        var frame = frame
        
        var frameHeight = frame.size.height
        var rowHeight : CGFloat = 0
        
        if let configuration = context.configuration {
            
            let cellHeight = configuration.cellHeight
            
            rowHeight = cellHeight
            
            for _ in items {
                frameHeight += cellHeight
            }
            
        }
        
        frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: frame.size.width, height: frameHeight)
        
        self.init(frame: frame, style: style)
        
        self.items = items
        self.context = context
        self.rowHeight = rowHeight
        
        self.delegate = self
        self.dataSource = self
        
        self.isScrollEnabled = true
        
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if let context = self.context {
            if let configuration = context.configuration {
                
                return configuration.cellHeight
                
            }
        }
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedItem = self.items![(indexPath as NSIndexPath).row]
        self.context?.title = selectedItem
        self.context?.hideList()
        
        //upon selection add the according selection style
        tableView.cellForRow(at: indexPath)?.backgroundColor = self.context?.configuration.dropdownListSelectedItemBackgroundColor
        tableView.cellForRow(at: indexPath)?.accessoryType = self.context!.configuration.dropdownListSelectedItemAccessoryType
        
        if let handler = self.itemSelectHandler {
            
            handler((indexPath as NSIndexPath).row, selectedItem as AnyObject?)
            
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.items?.count)!
    }
    
    
    //if the next row to be selected is not the same as the present one, remove any selection indicators
    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        
        let currentIndexPath = tableView.indexPathForSelectedRow
        
        if currentIndexPath != nil {
            
            tableView.cellForRow(at: currentIndexPath!)?.backgroundColor = self.context?.configuration.dropdownListBackgroundColor
            tableView.cellForRow(at: currentIndexPath!)?.accessoryType = UITableViewCellAccessoryType.none
            
        }
        
        return indexPath
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SwiftElegantDropdownListTableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = self.items![(indexPath as NSIndexPath).row]
        
        if let context = self.context {
            if let configuration = context.configuration {
                
                cell.textLabel?.textColor = configuration.cellTextColor
                cell.textLabel?.font = configuration.cellFont
                
            }
        }
        
        return cell
    }
    
    //on first cell rendering, if the cell is marked as selected proceed with adding the according style
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.layoutMargins = UIEdgeInsets.zero
        
        if cell.isSelected {
            
            cell.backgroundColor = self.context?.configuration.dropdownListSelectedItemBackgroundColor
            cell.accessoryType = self.context!.configuration.dropdownListSelectedItemAccessoryType
            
        }
        
    }
    
}

class SwiftElegantDropdownMenuObserverList {
    
    static var instances = [SwiftElegantDropdownMenu]()
    
}

class SwiftElegantDropdownListWrapperView: UIView {
    
    internal var context: SwiftElegantDropdownMenu?
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        
        /*if let context = self.context {
            context.hideList()
        }*/
        
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
    
}

class SwiftElegantDropdownListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }
    
}
