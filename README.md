# ReactiveListViewKit

* **MVVM + FLUX reactive facade ViewKit** for feed based app development
* **Eliminates Massive View Controller** in unidirectional Event/State flow manner

### Massive View Controller Terminator
 * No more UICollectionViewDataSource/UICollectionViewDelegate overhead
 * No more long if statement to manage model/cell mapping, event handling
 * No more delegation - event driven, loosely coupled pattern
 * FLUX one way data flow solves core problems of MVC: 
   * Central Mediator
   * Event Propagration
   * Data Binding

### FeedList/FeedDetails Facade ViewClass wraps complex UICollectionView
 * Implement Instagram FeedList within 50 lines of code
 * Embedded `HorizontalSectionAdapterView` makes nested horizontal ListView implementation within 10 lines code
 * Adaptive to various CellComponent classes:
   * UICollectionViewCell
   * UIView
   * UIViewController - domained event handling for complex cell
 * Embedded pagination events 
   * `CZFeedListViewEvent` - `pullToRefresh`/`loadMore` etc.

 
### Unidirectional Data Flow
 * **Dispatcher:** Propagates domained events

 * **Store:** Maintains the `State` tree

 * **Subscriber:** Subscribes to `Store` and update Components/Views with new State

 * **Event:** Event driven - more loosely coupled than `Delegation`
    
 * **State:**
   * Waterfall reacting flow
   * Composition: `rootState` is composited of `subStates`
   * Reacts to `Event` and outputs new `State`, propagates `Event` to its children nodes via `State` tree

### Automatic Batch Update
  * Smart Diff Algorithm for ListView batch update on top of Longest Common Subsequence
  * Perform Insert/Delete/Move sections/cells based on internal models diff algorithm

### Declarative/Immutable/Predictable
  * Efficient ViewModel tree diff algorithm, no more imperative manual cells update coding

  <img src="./Documents/FLUX.png">


### [Instagram Demo](https://github.com/showt1me/CZInstagram)
Implemented on top of **ReactiveListViewKit**

<img src="./Documents/CZInstagram.gif">