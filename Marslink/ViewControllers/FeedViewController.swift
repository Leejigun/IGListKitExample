//
//  FeedViewController.swift
//  Marslink
//
//  Created by Leejigun on 2018. 3. 6..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit

class FeedViewController: UIViewController {
    
    /// make 일지 기록들의 entries array
    let loader = JournalEntryLoader()
    
    /// 메세징 시스템
    let pathfinder = Pathfinder()
    
    /// 날씨 보기 텝
    let wxScanner = WxScanner()
    
    /// make IG UICollectionView 아직 내용이 없으니 CGRect.zero
    let collectionView:IGListCollectionView = {
        let view = IGListCollectionView(frame: CGRect.zero,
                                        collectionViewLayout: UICollectionViewFlowLayout())
        view.backgroundColor = UIColor.black
        return view
    }()
    
    /// Updater는 행과 섹션의 업데이트를 처리하여 Delegate를 충족, workingRange는 더 어려운 개념이라 나중에 따로 학습
    lazy var adapter:IGListAdapter = {
        return IGListAdapter(updater: IGListAdapterUpdater(), viewController: self, workingRangeSize: 0)
    }()
    
    override func viewDidLoad() {
        view.addSubview(collectionView)
        //여러개의 섹션을 가지는 배열을 생성
        loader.loadLatest()
        
        collectionView.frame = view.frame
        
        adapter.collectionView = collectionView
        
        adapter.dataSource = self
    }
    
}

extension FeedViewController:IGListAdapterDataSource{
    
    /// 컬렉션 뷰에 나타날 데이터 객체의 배열을 반환한다.
    /// 여기서 adapter에게 데이터 소스 객체를 전달
    ///
    /// - Parameter listAdapter: adapter
    /// - Returns: 뷰에 뿌릴 데이터의 배열
    func objects(for listAdapter: IGListAdapter) -> [IGListDiffable] {
        
        var items:[IGListDiffable] = [wxScanner.currentWeather]
        items += loader.entries as [IGListDiffable]
        items += pathfinder.messages as [IGListDiffable]
        
        ///items에는 지금 [[Weather][message],[journal]]의 형태로 구성된 것
        ///모든 아이템들이 dateSortable을 준수하기 때문에 시간순으로 정렬된 것
        return items.sorted(by: {(left:Any,right:Any) -> Bool in
            if let left = left as? DateSortable, let right = right as? DateSortable {
                return left.date > right.date
            }
            return false
        })
    }
    
    /// 각각의 데이터 타입에 해당하는 Section Controller를 반환
    /// 섹션의 수 만큼 호출된다.
    /// - Parameters:
    ///   - listAdapter: adapter
    ///   - object: 데이터 배열
    /// - Returns: Section Controller
    func listAdapter(_ listAdapter: IGListAdapter, sectionControllerFor object: Any) -> IGListSectionController {
        //2가지 형태의 ViewType이 존재하는 것
        if object is Message {
            return MessageSectionController()
        }
        else if object is Weather{
            return WeatherSectionController()
        }
        else{
            return JournalSectionController()
        }
        
    }
    
    /// 출력될 리스트가 비어있을 때 보여줄 뷰를 리턴한다.
    ///
    /// - Parameter listAdapter: adapter
    /// - Returns: nil
    func emptyView(for listAdapter: IGListAdapter) -> UIView? {
        return nil
    }
    
    
}
