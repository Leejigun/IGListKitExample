//
//  JournalSectionController.swift
//  Marslink
//
//  Created by Leejigun on 2018. 3. 6..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import IGListKit
class JournalSectionController: IGListSectionController {
    /// 데이터 소스를 받아올 때 사용할 모델 클래스
    var entry:JournalEntry!
    /// 날짜를 Sol Format으로 변환시켜주는 메소드를 제공하는 클래스
    let solFormatter = SolFormatter()
    
    override init() {
        super.init()
        //섹션간에 패팅을 줘서 다닥다닥 붙어서 나오는 것을 방지
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: - IGListKit Section Controller protocol
extension JournalSectionController:IGListSectionType{
    
    /// 섹션별 아이템의 숫자
    ///
    /// - Returns: 표시할 아이템의 숫자
    func numberOfItems() -> Int {
        return 2
    }
    
    /// 컨테이너의 정보를 가지고 아이템의 크기를 정한다.
    /// 이 경우 첫 셀이면 높이 30, 나머지 아이템이면 텍스트의 높이만큼 셀을 그리도록 한다.
    /// 너비를 화면만큼 줘서 TableView 처럼 사용하고 있다.
    /// - Parameter index: cell의 인덱스
    /// - Returns: 셀의 Size
    func sizeForItem(at index: Int) -> CGSize {
        guard  let context = collectionContext, let entry = entry else {
            return .zero
        }
        
        let width = context.containerSize.width
        
        if index == 0 {
            return CGSize(width: width, height: 30)
        }
        else{
            return JournalEntryCell.cellSize(width: width, text: entry.text)
        }
    }
    
    /// 실제 셀을 만들고 반환하는 메소드
    ///
    /// - Parameter index: section 안에서 cell의 인덱스
    /// - Returns: 구성된 UICollectionViewCell
    func cellForItem(at index: Int) -> UICollectionViewCell {
        //항상 날짜를 나타내는 셀과 그 뒤를 따라는 텍스트로 구성된다.
        let cellClass:AnyClass = index == 0 ?
            JournalEntryDateCell.self : JournalEntryCell.self
        
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at: index)
        
        if let cell = cell as? JournalEntryDateCell{
            cell.label.text = "Sol \(solFormatter.sols(fromDate: entry.date))"
        }
        else if let cell = cell as? JournalEntryCell{
            cell.label.text = entry.text
        }
        
        return cell
    }
    
    /// 객체를 Section Controller로 전달하기 위해 사용된다.
    /// 항상 cell 프로토콜의 메소드보다 먼저 실행되서 dataSource를 설정하는 역할을 한다.
    /// - Parameter object: data entry
    func didUpdate(to object: Any) {
        entry = object as? JournalEntry
    }
    
    /// 누군가가 셀을 탭 했을 경우 보여줄 이벤트
    /// 여기서는 이벤트가 없기 때문에 무시한다.
    /// - Parameter index: 셀의 인덱스
    func didSelectItem(at index: Int) {
    }
    
    
}
