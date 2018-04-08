//
//  OverviewCell.swift
//  Coco
//
//  Created by Hugo Prinsloo on 2018/04/07.
//  Copyright © 2018 Over. All rights reserved.
//

import UIKit
import Lottie

class OverviewCell: UICollectionViewCell {
    
    enum State {
        case open
        case closed
    }
    
    var currentState: State = .open
    
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
        l.font = UIFont(cocoFont: .medium, size: 14)
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
        l.backgroundColor = UIColor(cocoColor: .freshBlue)
        return l
    }()
    
    private let animationView: AnimationView = {
        let a = AnimationView(animation: "waves_", contentMode: .scaleToFill)
        a.translatesAutoresizingMaskIntoConstraints = false
        a.isHidden = true
        a.alpha = 0.5
        return a
    }()

    func configure(state: State, activity: String, startTime: String?, endTime: String?, duration: String?) {
        activityLabel.text = activity
        
        switch state {
        case .open:
            animationView.isHidden = false
            animationView.startAnimation()
            
            startTimeLabel.alpha = 0
            endTimeLabel.alpha = 0
            timelineView.alpha = 0
            durationLabel.alpha = 0
            print("Open \n")
        case .closed:
            animationView.stopAnimation()
            animationView.isHidden = true
            
            let start: String = startTime?.components(separatedBy: " ").last ?? ""
            startTimeLabel.text = start
            let end: String = endTime?.components(separatedBy: " ").last ?? ""
            endTimeLabel.text = end
            
            durationLabel.text = duration
            
            startTimeLabel.alpha = 1
            endTimeLabel.alpha = 1
            timelineView.alpha = 1
            durationLabel.alpha = 1
            print("Closed \n")
        }
    }
    
    /*
    func configure(_ activity: String, duration: String, startTime: String, endTime: String) {
        activityLabel.text = activity
        endTimeLabel.text = endTime
        if duration != "" {
            durationLabel.text = "\(duration)"
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
 
 */

    //    private func configureForEndTime(_ finised: Bool) {
//        backgroundColor = UIColor(cocoColor: .washoutBlue)
//
//        if finised {
//
//            let animator = UIViewPropertyAnimator(duration: 5, curve: .easeOut, animations: nil)
//            animator.addAnimations({ [weak self] in
//                self?.startTimeLabel.alpha = 1
//                self?.endTimeLabel.alpha = 1
//                self?.timelineView.alpha = 1
//                self?.animationView.alpha = 0
//            })
//            animator.addCompletion({ [weak self] (_) in
//                self?.animationView.stopAnimation()
//                self?.animationView.removeFromSuperview()
//            })
//            animator.startAnimation()
//
//
//        } else {
//            animationView.startAnimation()
//            activityLabel.transform = CGAffineTransform(translationX: 1.5, y: 2)
//            startTimeLabel.alpha = 0
//            endTimeLabel.alpha = 0
//            timelineView.alpha = 0
//        }
//
//        animationView.isHidden = finised
//    }
//
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        addSubview(animationView)
        addSubview(activityLabel)
        addSubview(durationLabel)
        addSubview(startTimeLabel)
        addSubview(endTimeLabel)
        addSubview(timelineView)
        
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addContraints()
        
        backgroundColor = UIColor(cocoColor: .washoutBlue)
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
        
        animationView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        animationView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        animationView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        animationView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        animationView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true        
    }
}

class AnimationView: UIView {
    
    private let animationView: LOTAnimationView
    
    init(animation: String, contentMode: UIViewContentMode = .scaleAspectFit) {
        animationView = LOTAnimationView(name: animation)
        super.init(frame: .zero)
        animationView.contentMode = contentMode
        addSubview(animationView)
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        animationView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func startAnimation() {
        animationView.play()
        animationView.loopAnimation = true
    }
    
    func stopAnimation() {
        animationView.stop()
    }
}



