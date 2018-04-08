//
//  OverviewCell.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit

class OverviewCell: UICollectionViewCell {
    
    private let activityLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(cocoFont: .semibold, size: 16)
        l.textColor = .white
        return l
    }()
    
    private let durationLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(cocoFont: .regular, size: 16)
        l.textColor = .white
        l.textAlignment = .right
        return l
    }()
    
    private let startTimeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(cocoFont: .light, size: 10)
        l.textColor = UIColor(cocoColor: .whiteBlue)
        return l
    }()
    
    private let endTimeLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(cocoFont: .light, size: 10)
        l.textColor = UIColor(cocoColor: .whiteBlue)
        l.textAlignment = .right
        return l
    }()
    
    private let timelineView: UIView = {
        let l = UIView()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.backgroundColor = UIColor.red
        return l
    }()
    
    private var gradient: CAGradientLayer = CAGradientLayer()
    
    func configure(_ activity: String, duration: String, startTime: String, endTime: String) {
        activityLabel.text = activity
        endTimeLabel.text = endTime
        if duration != "" {
            durationLabel.text = "\(duration) Min"
        }
        
        let start: String = startTime.components(separatedBy: " ").last ?? ""
        startTimeLabel.text = start
        
        if endTime != "" {
            let end: String = endTime.components(separatedBy: " ").last ?? ""
            endTimeLabel.text = end
            configureForEndTime(true)
        } else {
            configureForEndTime(false)
        }
    }
    
    private func configureForEndTime(_ finised: Bool) {
        backgroundColor = UIColor(cocoColor: .washoutBlue)
        
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        gradient.frame = bounds
        gradient.colors = [UIColor(cocoColor: .midnightPurple).withAlphaComponent(0.4).cgColor, UIColor(cocoColor: .midnightPink).withAlphaComponent(0.4).cgColor]
        
        layer.insertSublayer(gradient, at: 0)
        
        gradient.isHidden = finised
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(activityLabel)
        addSubview(durationLabel)
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(timelineView)
        
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addContraints()
    }
    
    private func addContraints() {
        activityLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 24).isActive = true
        activityLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -18).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        timelineView.leadingAnchor.constraint(greaterThanOrEqualTo: activityLabel.trailingAnchor).isActive = true
        timelineView.trailingAnchor.constraint(greaterThanOrEqualTo: durationLabel.leadingAnchor).isActive = true
        timelineView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 8).isActive = true
        timelineView.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 12).isActive = true
        timelineView.widthAnchor.constraint(lessThanOrEqualToConstant: 68).isActive = true
        timelineView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        startTimeLabel.leadingAnchor.constraint(equalTo: timelineView.leadingAnchor).isActive = true
        startTimeLabel.bottomAnchor.constraint(equalTo: timelineView.topAnchor, constant: 0).isActive = true
        
        endTimeLabel.trailingAnchor.constraint(equalTo: timelineView.trailingAnchor).isActive = true
        endTimeLabel.bottomAnchor.constraint(equalTo: timelineView.topAnchor, constant: 0).isActive = true
        
    }
}



