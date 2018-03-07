//
//  MessageSectionController.swift
//  Marslink
//
//  Created by Leejigun on 2018. 3. 6..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import UIKit
import IGListKit
class MessageSectionController: IGListSectionController {
    var message:Message!
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

// MARK: - IGListSectionType
extension MessageSectionController:IGListSectionType{
    /// 섹션 안의 셀의 수는 항상 1개
    ///
    /// - Returns: 1
    func numberOfItems() -> Int {
        return 1
    }
    
    /// 셀의 크기는 안에 있는 text의 사이즈에 따라 정해지며 추가적으로 위의 이름과 상태를 가진 라벨의 사이즈를 추가한 값
    ///
    /// - Parameter index: 셀의 포지션 이 경우 항상 0
    /// - Returns: 셀의 사이즈
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext,let message = message else {return .zero}
        
        let witdh = context.containerSize.width
        
        return MessageCell.cellSize(width: witdh, text: message.text)
    }
    
    /// 셀의 내용 구성
    /// 텍스트와 이름만 구성
    /// - Parameter index: 0
    /// - Returns: 구성된 셀
    func cellForItem(at index: Int) -> UICollectionViewCell {
        
        let cell = collectionContext?.dequeueReusableCell(of: MessageCell.self, for: self, at: index) as! MessageCell
        
        cell.messageLabel.text = message.text
        cell.titleLabel.text = message.user.name.uppercased()
        
        return cell
        
    }
    
    /// 데이터 소스 업데이트
    ///
    /// - Parameter object: datesortable 프로토콜을 준수하는 데이터 소스
    func didUpdate(to object: Any) {
        message = object as? Message
    }
    
    func didSelectItem(at index: Int) {
    }
    
    
}
