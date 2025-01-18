//
//  FormView.swift
//  ForexSwift
//
//  Created by liuxu on 2022/11/14.
//

import Foundation
import UIKit


class FormView: BaseView {
    
    private var datas: [[String]] = []
    private var rows: Int = 0
    private var itemHeights: [CGFloat] = []
    private var columns: Int = 0
    private var itemWidth: CGFloat = 0
    private var collection: UICollectionView!
    private var viewWidth: CGFloat = 0
    
    private var backgroundImageView: UIImageView!
    
    convenience init(viewWidth: CGFloat, datas: [[String]]) {
        self.init(frame: .zero)
        self.datas = datas
        self.viewWidth = viewWidth
        handleDatas()
        setupViews()
        draw()
    }
    
    private func draw() {
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, UIScreen.main.scale)
        let context = UIGraphicsGetCurrentContext()
        
        let view = UIView(frame: bounds).bgColor(Color.background)
        view.layer.render(in: context!)
        
        // 周边圆角
        context?.move(to: CGPoint(x: 4, y: 0))
        context?.addLine(to: CGPoint(x: frame.width - 4, y: 0))
        let offset = Double.pi * 0
        context?.addArc(center: CGPoint(x: frame.width - 4, y: 4), radius: 4, startAngle: -Double.pi / 2 + offset, endAngle: 0 + offset, clockwise: false)
        context?.addLine(to: CGPoint(x: frame.width, y: frame.height - 4))
        context?.addArc(center: CGPoint(x: frame.width - 4, y: frame.height - 4), radius: 4, startAngle: 0 + offset, endAngle: Double.pi / 2 + offset, clockwise: false)
        context?.addLine(to: CGPoint(x: 4, y: frame.height))
        context?.addArc(center: CGPoint(x: 4, y: frame.height - 4), radius: 4, startAngle: Double.pi / 2 + offset, endAngle: Double.pi + offset, clockwise: false)
        context?.addLine(to: CGPoint(x: 0, y: 4))
        context?.addArc(center: CGPoint(x: 4, y: 4), radius: 4, startAngle: Double.pi + offset, endAngle: Double.pi * 1.5 + offset, clockwise: false)
        context?.closePath()
        context?.setFillColor(Color.background.cgColor)
        context?.setStrokeColor(Color.text.cgColor)
        context?.setLineWidth(pixel)
        context?.drawPath(using: .fillStroke)
        
        
        
        var y: CGFloat = 0
        for i in 0 ..< rows - 1 {
            y += itemHeights[i]
            context?.move(to: CGPoint(x: 0, y: y))
            context?.addLine(to: CGPoint(x: viewWidth, y: y))
        }
        
        var x: CGFloat = 0
        for _ in 0 ..< columns - 1 {
            x += itemWidth
            context?.move(to: CGPoint(x: x, y: 0))
            context?.addLine(to: CGPoint(x: x, y: frame.height))
        }
        
        context?.setStrokeColor(Color.text.cgColor)
        context?.setLineWidth(pixel)
        context?.drawPath(using: .fillStroke)
        
        let image = UIGraphicsGetImageFromCurrentImageContext()
        backgroundImageView.image = image
        UIGraphicsEndImageContext()
    }
    
    private func handleDatas() {
        
        backgroundColor = Color.background
        
        rows = datas.count
        self.columns = datas.reduce(0, { partialResult, data in
            return partialResult >= data.count ? partialResult : data.count
        })
        self.itemWidth = viewWidth / CGFloat(columns)
        
        self.itemHeights = datas.map({ data in
            var itemHeights: CGFloat = 0
            itemHeights = data.reduce(itemHeights, { partialResult, text in
                var textHeight = text.sizeFor(maxW: self.itemWidth - 30, maxH: CGFloat(MAXFLOAT), font: .system(12)).height + 1 + 16
                if textHeight < 50 {
                    textHeight = 50
                }
                return partialResult >= textHeight ? partialResult : textHeight
            })
            return itemHeights
        })
        
        let viewHeight = itemHeights.reduce(0) { partialResult, height in
            return partialResult + height
        }
        self.frame = CGRect(x: 0, y: 0, width: viewWidth, height: viewHeight)
    }
    
    private func setupViews() {
        backgroundImageView = UIImageView().bgColor(Color.background)
        backgroundImageView.frame = bounds
        addSubview(backgroundImageView)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .vertical
        
        collection = UICollectionView(frame: bounds, collectionViewLayout: layout).bgColor(.clear)
        collection.delegate = self
        collection.dataSource = self
        collection.register(all: [FormCell.self])
        addSubview(collection)
    }
}

extension FormView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datas[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FormCell.cellID(), for: indexPath) as! FormCell
        cell.text = datas[indexPath.section][indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: itemWidth, height: itemHeights[indexPath.section])
    }
}

class FormCell: BaseCollectionViewCell {
    
    var text = "" {
        didSet {
            textLabel.text = text
        }
    }
    
    private var textLabel: EdgeLabel!

    override func setupViews() {
        super.setupViews()
        
        contentView.bgColor(.clear)
        
        textLabel = EdgeLabel().bgColor(.clear)
            .edge(UIEdgeInsets(top: 8, left: 15, bottom: 8, right: 15))
            .textColor(Color.text)
            .font(.system(12))
            .txtAlignment(.center)
            .numOfLines(0)
        addSubview(textLabel)
        
        textLabel.snp.makeConstraints { make in
            make.edges.equalTo(UIEdgeInsets.zero)
        }
    }
    
    
}
