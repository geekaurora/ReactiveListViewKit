# ReactiveListViewKit

[![Version](https://img.shields.io/cocoapods/v/ReactiveListViewKit.svg?style=flat)](http://cocoapods.org/pods/ReactiveListViewKit)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
![Swift Version](https://img.shields.io/badge/swift-3.2-orange.svg)
[![License](https://img.shields.io/cocoapods/l/ReactiveListViewKit.svg?style=flat)](http://cocoapods.org/pods/ReactiveListViewKit)
[![Platform](https://img.shields.io/cocoapods/p/ReactiveListViewKit.svg?style=flat)](http://cocoapods.org/pods/ReactiveListViewKit)

* **MVVM + FLUX reactive facade ViewKit** for Feed based app development
* **Eliminates Massive View Controller** in unidirectional Event/State flow

### Massive View Controller Terminator
 * No more `UICollectionViewDataSource`/`UICollectionViewDelegate` overhead
 * No more giant if statement to manage model/cell mapping, event handling
 * No more coupling Delegation pattern: 1 to n Event-driven pattern, more loosely coupled
 * FLUX one way data flow - solves core problems of MVC: 
   * Central mediator
   * Chaining callback propagration
   * Data binding

### FeedList/FeedDetails FacadeViewClass wraps complex UICollectionView
 * Implement Instagram FeedList within 50 lines of code
 * Embedded `HorizontalSectionAdapterView` simplifies nested horizontal ListView implementation within 10 lines code
 * Adaptive to various CellComponent classes:
   * `UICollectionViewCell`
   * `UIView`
   * `UIViewController` - handles domained events of complex Cell
 * Embedded convenient events set
   * `CZFeedListViewEvent` - `pullToRefresh`/`loadMore` etc.

 
### Unidirectional Data Flow
 * **Dispatcher:** Propagates domained events

 * **Store:** Maintains `State` tree

 * **Subscriber:** Subscribes to `Store` and updates Components with new `State`

 * **Event:** Event driven - more loosely coupled pattern than `Delegation` pattern
    
 * **State:**
   * Waterfall reacting flow
   * Composition: `RootState` is composed of `SubStates`
   * Reacts to `Event` and outputs new `State`, propagates `Event` to children nodes via `State` tree

### Automatic Batch Update
  * Smart Diff Algorithm for ListView incremental update on top of `Longest Common Subsequence` - O(n) time complexity
  * Perform Insert/Delete/Move/Update sections/cells based on internal models diff algorithm

### Declarative/Stateful/Immutable/Predictable
  * Efficient ViewModel tree diff algorithm, no more imperative manual cells update code

  <img src="./Docs/FLUX.png">


### [Instagram Demo](https://github.com/showt1me/CZInstagram)
Implemented on top of **ReactiveListViewKit**

<img src="./Docs/CZInstagram.gif">