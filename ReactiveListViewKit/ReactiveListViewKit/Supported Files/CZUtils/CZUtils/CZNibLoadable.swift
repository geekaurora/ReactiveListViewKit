//
//  CZNibLoadable.swift
//
//  Created by Cheng Zhang on 4/19/16.
//  Copyright © 2016 Cheng Zhang. All rights reserved.
//

import UIKit

/// A view that has an accompanying xib file by the same name and make use of `loadFromNib`
public protocol CZNibLoadable: class {
    /// xib filename: same as View className by default. If you need to customize xibName, just override `var xibName: String` in your class
    var xibName: String? {get}
    /// Content view loaded from nib file
    var nibContentView: UIView! {get set}
}

// MARK: - CZNibLoadableView
/// - Brief: Base class for view which is loaded from xib file.
///
/// - Usage:
///   1. Create xib file with the same name as SubViewClass
///   2. Set SubViewClass as xib file's owner
///   3. xibName: same as View className by default. If you need to customize xibName, just override `var xibName: String` in your class
///
/// - Note:
///   1. nibContentView, the first top level view in nib file, is added and overlapped on SubViewClass with zero inset
///   2. override setupViews() for customized initialization if needed, required to invoke super.setupViews()
@objc open class CZNibLoadableView: UIView, CZNibLoadable {
    open var xibName: String? { return nil }
    open var nibContentView: UIView!
    
    // MARK: - Lifecycle
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    // MARK: - Setup
    open func setupViews() {
        _loadAndOverlay(on: self)
    }
}

// MARK: - CZNibLoadableTableViewCell
@objc open class CZNibLoadableTableViewCell: UITableViewCell, CZNibLoadable {
    open var xibName: String? { return nil }
    open var nibContentView: UIView!
    fileprivate var nibIsLoaded: Bool = false
    
    // MARK: - Lifecycle
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override public init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Setup
    open func setupViews() {
        guard !nibIsLoaded else {return}
        nibIsLoaded = true
        _loadAndOverlay(on: self)
    }
}

// MARK: - CZNibLoadableCollectionViewCells
@objc open class CZNibLoadableCollectionViewCell: UICollectionViewCell, CZNibLoadable {
    open var nibContentView: UIView!
    open var xibName: String? { return nil }
    fileprivate var nibIsLoaded: Bool = false
    
    // MARK: - Lifecycle
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    override open func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    // MARK: - Setup
    open func setupViews() {
        guard !nibIsLoaded else {return}
        nibIsLoaded = true
        // should be self, contentView doesn't overlap?
        _loadAndOverlay(on: self)
    }
}

// MARK: - Private Methods

/// extension of UIView conforms to CZNibLoadable
fileprivate extension CZNibLoadable where Self: UIView {
    /// Load form nib file and overlay the contentView on superView
    func _loadAndOverlay(on superView: UIView) {
        nibContentView = loadAndOverlay(on: superView, xibName: xibName)
    }
}

extension UIView {
    /// Load form nib file and overlay the contentView on superView
    @discardableResult
    public func loadAndOverlay(on superView: UIView, xibName: String? = nil) -> UIView {
        // Unarchive and own properties of nibFile.
        // Note: During runtime, loadFromNib traverses from leaf(subestClass) to root(superestClass) to find appropriate nib file, so we can put loadFromNib in superClass, instead subclasses.
        // It climbs via the path "SubClassName.xib" => "UIView.xib" => "UIResponder.xib" => "NSObject.xib" to get the appropriate archived nib file.
        // This is also the mechanism how iOS decides which class's function to invoke in class inheritation tree during runtime, it attempts to objc_msgSend from leaf(subestClass) to root(superestClass) until it gets a matcher or reaches the root of the class inheritation tree which is NSObject class.
        // Load the first view in views array unarchieved from nib
        guard let nibContentView = loadFromNibFile(xibName: xibName)?.first else {
            fatalError("Failed to load nibContentView for class `\(object_getClass(self)!)`: please refer nibContentView outlet to class `\(object_getClass(self)!)` in nib file.")
        }
        // Add and overlap nibContentView on self
        superView.addSubview(nibContentView)
        nibContentView.translatesAutoresizingMaskIntoConstraints = false
        nibContentView.overlayOnSuperview()
        return nibContentView
    }
    
    /// Unarchive and own properties of nibFile
    ///
    /// - Parameters:
    ///   - xibName : xib filename. `nil` by default
    ///   - bundle  : bundle to load nib file.
    /// - Returns   : views array unarchived from nib file
    @discardableResult
    public func loadFromNibFile(xibName: String? = nil, bundle: Bundle = Bundle.main) -> [UIView]? {
        var views: [UIView]?
        // Class of the current object
        var classRef: AnyClass? = object_getClass(self)
        while let currClassRef = classRef, views == nil {
            // Get nibName from className of current level
            var nibName = xibName ?? NSStringFromClass(currClassRef)
            // Swift class name prefix with module name, so we need to extract the last part of seperate components for Swift class
            nibName = nibName.components(separatedBy: ".").last!
            // Unarchive views from nibFile
            views = bundle.loadNibNamed(nibName, owner: self, options: nil) as? [UIView]
            // Climb up higher level through class inheritance tree
            classRef = currClassRef.superclass()
        }
        assert(views != nil, "Fail to loadFromNibFile for class `\(object_getClass(self)!)`.\n")
        return views
    }
    
    /// Overlap on superView, being added as subview of `superviewIn` if receiver has no superview
    public func overlayOnSuperview(_ superviewIn: UIView? = nil, inset: UIEdgeInsets = .zero) {
        if superview == nil {
            superviewIn?.addSubview(self)
        }
        guard let superview = self.superview else {return}
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: inset.left),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -inset.right),
            topAnchor.constraint(equalTo: superview.topAnchor, constant: inset.top),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -inset.bottom)
            ]
        )
    }

    public func overlayOnSuperViewController(_ controller: UIViewController) {
        guard let containerView = controller.view else {
            assertionFailure("\(#function): superview is nil.")
            return
        }
        if superview == nil {
            containerView.addSubview(self)
        }
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            leadingAnchor.constraint(equalTo: containerView.leadingAnchor),
            trailingAnchor.constraint(equalTo: containerView.trailingAnchor),
            //topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor),
            topAnchor.constraint(equalTo: controller.view.topAnchor, constant: 64),
            bottomAnchor.constraint(equalTo: containerView.bottomAnchor)
            ]
        )
    }
}
