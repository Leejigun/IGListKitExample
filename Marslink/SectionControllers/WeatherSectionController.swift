//
//  WeatherSectionController.swift
//  Marslink
//
//  Created by Leejigun on 2018. 3. 6..
//  Copyright © 2018년 Ray Wenderlich. All rights reserved.
//

import IGListKit

class WeatherSectionController: IGListSectionController {

    var weather:Weather!
    var expanded = false
    
    override init() {
        super.init()
        inset = UIEdgeInsets(top: 0, left: 0, bottom: 15, right: 0)
    }
}

extension WeatherSectionController:IGListSectionType{
    /// 확장될 수 있는 섹션이기 때문에 cell의 갯수가 다르다.
    ///
    /// - Returns: 표시될 셀의 수
    func numberOfItems() -> Int {
        return expanded ? 5:1
    }
    
    /// 셀의 높이
    ///
    /// - Parameter index: 인덱스
    /// - Returns: 높이
    func sizeForItem(at index: Int) -> CGSize {
        guard let context = collectionContext else {
            return .zero
        }
        
        let width = context.containerSize.width
        
        if index == 0 {
            return CGSize(width: width, height: 70)
        }
        else{
            return CGSize(width: width, height: 40)
        }
    }
    
    func cellForItem(at index: Int) -> UICollectionViewCell {
        let cellClass:AnyClass = index == 0 ? WeatherSummaryCell.self : WeatherDetailCell.self
        
        let cell = collectionContext!.dequeueReusableCell(of: cellClass, for: self, at:index)
        
        if let cell = cell as? WeatherSummaryCell {
            cell.setExpanded(expanded)
        }
        else if let cell = cell as? WeatherDetailCell{
            var title:String!
            var text:String!
            switch index {
            case 1:
                title = "SUNRISE"
                text = weather.sunrise
            case 2:
                title = "SUNSET"
                text = weather.sunset
            case 3:
                title = "HIGH"
                text = "\(weather.high) C"
            case 4:
                title = "LOW"
                text = "\(weather.low) C"
            default:
                title = "out of range"
                text = "out of range"
            }
            cell.titleLabel.text = title
            cell.detailLabel.text = text
        }
        
        return cell
    }
    
    func didUpdate(to object: Any) {
        weather = object as? Weather
    }
    
    func didSelectItem(at index: Int) {
        expanded = !expanded
        collectionContext?.reload(self)
    }
    
    
}
