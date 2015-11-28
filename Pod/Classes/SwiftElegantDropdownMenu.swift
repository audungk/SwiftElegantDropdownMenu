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

public class SwiftElegantDropdownMenu : UIView {
    
    private var _configuration  : SwiftElegantDropdownMenuConfiguration?
    private var _title : UILabel?
    private var _items: [String]?
    private var _titleText: String!
    private var _menuButton: UIButton!
    private var wrapper : UIView? //view in which you wish to present the dropdown
    private var _dropdownList : SwiftElegantDropdownListTableView?
    private var _dropdownListWrapper: SwiftElegantDropdownListWrapperView?
    private var _topBorder : UIView?
    private var _selectedItem: String?
    private var _dropdownIcon: UIImageView?
    
    public var onItemSelect: ((index: Int, item: AnyObject?) -> ())?
    
    public var items : [String]? {
        get {
            return self._items
        } set (value) {
            self._items = value
            self.renderDropdownView()
        }
    }
    
    public var configuration : SwiftElegantDropdownMenuConfiguration! {
        get {
            return self._configuration
        } set(value){
            self._configuration = value
            self.renderDropdownView()
        }
    }
    
    public var title: String? {
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
        
        var _frame = CGRectMake(0, 0, 300, 100)
        
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
    
    private func registerDropdown(){
        
        if !SwiftElegantDropdownMenuObserverList.instances.contains(self){
            SwiftElegantDropdownMenuObserverList.instances.append(self)
        }
        
    }
    
    override public func setNeedsLayout() {
        
        super.setNeedsLayout()
        
        if let wrapper = self.wrapper {
            
            var verticalOffset = self.frame.origin.y + self.frame.size.height
            
            if !UIApplication.sharedApplication().statusBarHidden {
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
    public func renderDropdownView() {
        
        if let _title = self._title {
            if _title.isDescendantOfView(self){
                _title.removeFromSuperview()
            }
        }
        
        let buttonFrame = CGRectMake(0, 0, self.frame.width, self.frame.height)
        
        self._title = UILabel(frame: buttonFrame)
        self._title!.text = self._titleText
        self._title!.textAlignment = NSTextAlignment.Center
        self._title!.font = self.configuration.titleFont
        self._title!.textColor = self.configuration.titleColor
        self._title?.backgroundColor = self.configuration.headerBackgroundColor
        
        if let headerViewHeight = self.configuration.headerViewHeight {
            self._title?.frame = CGRectMake(self._title!.frame.origin.x, self._title!.frame.origin.y, self._title!.frame.size.width, headerViewHeight)
        }
        
        self._title?.frame.size.width = (self._title!.text! as NSString).sizeWithAttributes([NSFontAttributeName:self._title!.font]).width
        
        self._title?.center = CGPointMake(self.frame.width / 2, self._title!.frame.height / 2)
        
        self._menuButton = UIButton(frame: buttonFrame)
        
        self.addSubview(self._menuButton)
        self._menuButton.addSubview(self._title!)
        
        if let dropdownIconAsset = self.configuration.dropdownIconAssetName {
            let dropdownIcon = UIImage(named: dropdownIconAsset)
            
            if self._dropdownIcon == nil {
                
                self._dropdownIcon = UIImageView(frame: CGRectMake(self._title!.frame.origin.x + self._title!.frame.size.width, 0, 30, 30))
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
        self._menuButton.addTarget(self, action: "menuButtonTapped:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func menuButtonTapped(sender: UIButton){
        
        for menu in SwiftElegantDropdownMenuObserverList.instances {
            
            if menu != self {
                
                menu.hideList()
                
            }
            
        }
        
        self.toggleList()
    }
    
    private func renderList(){
        if self._dropdownList == nil {
            if self.wrapper == nil {
                var wrapper = self.superview
                
                while wrapper != nil {
                    
                    self.wrapper = wrapper
                    wrapper = wrapper?.superview
                    
                }
            }
            
            if let wrapper = self.wrapper {
                
                var verticalOffset = self.frame.origin.y + self.frame.size.height
                
                if !UIApplication.sharedApplication().statusBarHidden {
                    
                    verticalOffset += 20
                }
                
                let wrapperFrame = CGRectMake(wrapper.frame.origin.x, verticalOffset, wrapper.frame.size.width, wrapper.frame.size.height)
                self._dropdownListWrapper = SwiftElegantDropdownListWrapperView(frame: wrapperFrame)
                self._dropdownListWrapper?.clipsToBounds = true
                self._dropdownListWrapper?.context = self
                
                wrapper.addSubview(self._dropdownListWrapper!)
                
                let tableFrame = CGRectMake(wrapper.frame.origin.x, verticalOffset, wrapper.frame.size.width, 0)
                
                self._dropdownList = SwiftElegantDropdownListTableView(frame: tableFrame, style: UITableViewStyle.Plain, items: self.items!, context: self)
                
                self._dropdownList?.itemSelectHandler = { (index: Int, item: AnyObject?) -> () in
                    
                    if let handler = self.onItemSelect {
                        
                        handler(index: index, item: item)
                        
                    }
                    
                }
                
                if self.items != nil && self.items!.count > 0 && self.items!.count > self.configuration.dropdownListSelectedItemIndex && self.configuration.dropdownListSelectedItemIndex >= 0 {
                    
                    if let title = self.title {
                        
                        if self.items!.contains(title) {
                            
                            if let selectedIndex = self.items!.indexOf(title) {
                                self.configuration.dropdownListSelectedItemIndex = selectedIndex
                            }
                            
                        }
                        
                    }
                    
                    self._dropdownList?.selectRowAtIndexPath(NSIndexPath(forRow: self.configuration.dropdownListSelectedItemIndex, inSection: 0), animated: false, scrollPosition: UITableViewScrollPosition.Top)
                    
                    self.title = self.items![self.configuration.dropdownListSelectedItemIndex]
                    
                }
                
                self._dropdownList!.hidden = true
                
                self._dropdownList?.separatorInset = UIEdgeInsetsZero
                self._dropdownList?.layoutMargins = UIEdgeInsetsZero
                
                // self._dropdownList?.separatorInset.right = (self._dropdownList?.separatorInset.left)!
                
                self._dropdownListWrapper?.addSubview(self._dropdownList!)
                self._topBorder = UIView(frame: CGRectMake(0, 0, self._dropdownListWrapper!.frame.width, 0.5))
                self._topBorder?.hidden = true
                self._dropdownListWrapper?.addSubview(self._topBorder!)
                
            
                
            }
        }
        
        if let configuration = self.configuration, dropdownList = self._dropdownList {
            dropdownList.backgroundColor = configuration.dropdownListBackgroundColor
            dropdownList.layer.borderWidth = configuration.dropdownListBorderWidth
            dropdownList.layer.borderColor = configuration.dropdownListBorderColor.CGColor
            self._topBorder?.backgroundColor = configuration.dropdownListBorderColor
        }
        
    }
    
    private func showList(){
        
        if !self._dropdownList!.isAnimating {
            
            self._dropdownList!.frame = CGRectMake(0, -self._dropdownList!.frame.height, self._dropdownList!.frame.width, self._dropdownList!.frame.height)
            self._dropdownList?.hidden = false
            
            if self._dropdownList!.frame.height > self.configuration.dropdownListMaxHeight {
                
                self._dropdownList!.frame.size.height = self.configuration.dropdownListMaxHeight
                
            }
            
            if let configuration = self.configuration {
                
                self._dropdownList?.isAnimating = true
                
                self._topBorder?.hidden = false
                
                UIView.animateWithDuration(configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    if let dropdownIcon = self._dropdownIcon {
                        if configuration.dropdownIconWillRotate {
                            
                            dropdownIcon.transform = CGAffineTransformMakeRotation(CGFloat(M_PI))
                            
                        }
                    }
                    
                    self._dropdownList?.frame = CGRectMake(0, 30, self._dropdownList!.frame.width, self._dropdownList!.frame.height)
                    }, completion: { (completed) -> Void in
                        
                        UIView.animateWithDuration(configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                            self._dropdownList?.frame = CGRectMake(0, 0, self._dropdownList!.frame.width, self._dropdownList!.frame.height)
                            }, completion: { (completed) -> Void in
                                self._dropdownList?.isAnimating = false
                        })
                })
                
            }
            
        }
        
    }
    
    private func hideList(){
        
        if !self._dropdownList!.isAnimating {
            
            if let configuration = self.configuration {
                
                self._dropdownList?.isAnimating = true
                
                UIView.animateWithDuration(configuration.animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: { () -> Void in
                    
                    if let dropdownIcon = self._dropdownIcon {
                        if configuration.dropdownIconWillRotate {
                            
                            dropdownIcon.transform = CGAffineTransformMakeRotation(CGFloat(0))
                            
                        }
                    }
                    
                    self._dropdownList?.frame = CGRectMake(0, -self._dropdownList!.frame.height, self._dropdownList!.frame.width, self._dropdownList!.frame.height)
                    }, completion: { (completed) -> Void in
                        if completed {
                            
                            self._dropdownList?.isAnimating = false
                            self._dropdownList?.hidden = true
                            self._topBorder?.hidden = true
                            
                        }
                })
                
            }
            
        }
        
    }
    
    private func toggleList(){
        
        if let dropdownList = self._dropdownList {
            
            if dropdownList.hidden {
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
public class SwiftElegantDropdownMenuConfiguration {
    
    private var context : SwiftElegantDropdownMenu?
    
    //attributes for the header of the dropdown
    private var _headerBackgroundColor: UIColor!
    private var _headerViewHeight: CGFloat?
    
    //attributes for the title (selected item)
    private var _titleColor : UIColor!
    private var _titleFont: UIFont!
    
    //attributes for the dropdown list items
    private var _cellHeight : CGFloat!
    private var _dropdownListBackgroundColor: UIColor!
    private var _cellFont: UIFont!
    private var _cellTextColor : UIColor!
    private var _dropdownListBorderColor: UIColor!
    private var _dropdownListBorderWidth: CGFloat!
    private var _dropdownListMaxHeight: CGFloat!
    private var _dropdownListSelectedItemIndex: Int!
    private var _dropdownListSelectedItemBackgroundColor: UIColor!
    private var _dropdownListSelectedItemAccessoryType : UITableViewCellAccessoryType!
    
    //animations
    private var _animationDuration : NSTimeInterval!
    
    //dropdown icon
    private var _dropdownIconAssetName: String?
    private var _dropdownIconWillRotate: Bool!
    
    //returns a prepopulated configuration set
    static public func getDefaultConfiguration(context: SwiftElegantDropdownMenu) -> SwiftElegantDropdownMenuConfiguration{
        
        let configuration = SwiftElegantDropdownMenuConfiguration(context: context)
        
        configuration.headerBackgroundColor = UIColor.clearColor()
        
        configuration.titleColor = UIColor.blackColor()
        configuration.titleFont = UIFont(name: "HelveticaNeue", size: 17)!
        
        configuration.cellHeight = 40
        configuration.animationDuration = 0.3
        
        configuration.cellFont = UIFont(name: "HelveticaNeue", size: 17)!
        configuration.cellTextColor = UIColor.blackColor()
        
        configuration.dropdownListBackgroundColor = UIColor.whiteColor()
        configuration.dropdownListBorderColor = UIColor.lightGrayColor()
        configuration.dropdownListBorderWidth = 0.5
        
        configuration.dropdownListMaxHeight = 200
        configuration.dropdownListSelectedItemIndex = 0
        
        configuration.dropdownListSelectedItemBackgroundColor = UIColor(red: 211/255, green: 234/255, blue: 242/255, alpha: 1.0)
        configuration.dropdownListSelectedItemAccessoryType = UITableViewCellAccessoryType.Checkmark
        
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
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var headerViewHeight: CGFloat? {
        get {
            return self._headerViewHeight
        } set(value){
            self._headerViewHeight = value
            if let context = self.context, _ = context.configuration {
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
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var titleFont: UIFont {
        get {
            return self._titleFont
        } set(value){
            self._titleFont = value
            if let context = self.context, _ = context.configuration {
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
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var animationDuration: NSTimeInterval {
        get {
            return self._animationDuration
        } set(value){
            self._animationDuration = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBackgroundColor: UIColor {
        get {
            return self._dropdownListBackgroundColor
        } set(value){
            self._dropdownListBackgroundColor = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var cellFont: UIFont {
        get {
            return self._cellFont
        } set(value){
            self._cellFont = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var cellTextColor: UIColor {
        get {
            return self._cellTextColor
        } set(value){
            self._cellTextColor = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBorderColor: UIColor {
        get {
            return self._dropdownListBorderColor
        } set(value){
            self._dropdownListBorderColor = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListBorderWidth: CGFloat {
        get {
            return self._dropdownListBorderWidth
        } set(value){
            self._dropdownListBorderWidth = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListMaxHeight: CGFloat {
        get {
            return self._dropdownListMaxHeight
        } set(value){
            self._dropdownListMaxHeight = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemIndex: Int {
        get {
            return self._dropdownListSelectedItemIndex
        } set(value){
            self._dropdownListSelectedItemIndex = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemBackgroundColor: UIColor {
        get {
            return self._dropdownListSelectedItemBackgroundColor
        } set(value){
            self._dropdownListSelectedItemBackgroundColor = value
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    public var dropdownListSelectedItemAccessoryType: UITableViewCellAccessoryType {
        get {
            return self._dropdownListSelectedItemAccessoryType
        } set(value){
            self._dropdownListSelectedItemAccessoryType = value
            if let context = self.context, _ = context.configuration {
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
            if let context = self.context, _ = context.configuration {
                context.renderDropdownView()
            }
        }
    }
    
    public var dropdownIconWillRotate: Bool {
        get {
            return self._dropdownIconWillRotate
        } set(value){
            self._dropdownIconWillRotate = value
            if let context = self.context, _ = context.configuration {
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
    
    var itemSelectHandler: ((index: Int, item: AnyObject?) -> ())?
    
    convenience init(var frame: CGRect, style: UITableViewStyle, items: [String], context: SwiftElegantDropdownMenu) {
        
        var frameHeight = frame.size.height
        var rowHeight : CGFloat = 0
        
        if let configuration = context.configuration {
            
            let cellHeight = configuration.cellHeight
            
            rowHeight = cellHeight
            
            for _ in items {
                frameHeight += cellHeight
            }
            
        }
        
        frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frameHeight)
        
        self.init(frame: frame, style: style)
        
        self.items = items
        self.context = context
        self.rowHeight = rowHeight
        
        self.delegate = self
        self.dataSource = self
        
        self.scrollEnabled = true
        
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if let context = self.context {
            if let configuration = context.configuration {
                
                return configuration.cellHeight
                
            }
        }
        
        return UITableViewAutomaticDimension
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let selectedItem = self.items![indexPath.row]
        self.context?.title = selectedItem
        self.context?.hideList()
        
        //upon selection add the according selection style
        tableView.cellForRowAtIndexPath(indexPath)?.backgroundColor = self.context?.configuration.dropdownListSelectedItemBackgroundColor
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = self.context!.configuration.dropdownListSelectedItemAccessoryType
        
        if let handler = self.itemSelectHandler {
            
            handler(index: indexPath.row, item: selectedItem)
            
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.items?.count)!
    }
    
    
    //if the next row to be selected is not the same as the present one, remove any selection indicators
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        
        let currentIndexPath = tableView.indexPathForSelectedRow
        
        if currentIndexPath != nil {
            
            tableView.cellForRowAtIndexPath(currentIndexPath!)?.backgroundColor = self.context?.configuration.dropdownListBackgroundColor
            tableView.cellForRowAtIndexPath(currentIndexPath!)?.accessoryType = UITableViewCellAccessoryType.None
            
        }
        
        return indexPath
        
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = SwiftElegantDropdownListTableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        
        cell.textLabel?.text = self.items![indexPath.row]
        
        if let context = self.context {
            if let configuration = context.configuration {
                
                cell.textLabel?.textColor = configuration.cellTextColor
                cell.textLabel?.font = configuration.cellFont
                
            }
        }
        
        return cell
    }
    
    //on first cell rendering, if the cell is marked as selected proceed with adding the according style
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.layoutMargins = UIEdgeInsetsZero
        
        if cell.selected {
            
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
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        
        /*if let context = self.context {
            context.hideList()
        }*/
        
        for subview in subviews {
            if !subview.hidden && subview.alpha > 0 && subview.userInteractionEnabled && subview.pointInside(convertPoint(point, toView: subview), withEvent: event) {
                return true
            }
        }
        return false
    }
    
}

class SwiftElegantDropdownListTableViewCell: UITableViewCell {
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clearColor()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clearColor()
    }
    
}
