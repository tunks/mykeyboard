//
//  AKboardUIView.swift
//  AKboard
//
//  Created by Ebrima Tunkara on 11/30/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import Foundation
import UIKit

class AKboardView: UIView{
    private var scrollView = UIScrollView(frame: .zero)
    private var stackView = UIStackView(frame: .zero)
    private var views:[UIView] = []
    var pageControl = UIPageControl()
    var keyboardDelegate: AKboardActionDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       setup()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
    }
    
    private func setup() {
        // *** SETUP SCROLLVIEW *** //
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .white
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self

        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -10),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10)
            ])
        
        scrollView.isUserInteractionEnabled = true
    }
    
    func setupPageViews( _ keypages: [KeyboardPage]){
        for page in keypages.sorted(by: { $0.pageIndex < $1.pageIndex}){
            let pageView = page.pageView()
            pageView.keyboardDelegate = keyboardDelegate
            views.append(pageView)
        }
        
        // [1]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            stackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: self.heightAnchor, multiplier: (3/4)).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
            
        }
    }
    
    func setupPageControls(){
        // *** ADD PAGECONTROLL *** //
        self.addSubview(pageControl)
        pageControl.numberOfPages = 3;
        pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
        let pageWidth = scrollView.bounds.width
        let offset = sender.currentPage * Int(pageWidth)
        UIView.animate(withDuration: 0.33, animations: { [weak self] in
            self?.scrollView.contentOffset.x = CGFloat(offset)
        })
    }
}


extension AKboardView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        let pageFraction = scrollView.contentOffset.x/pageWidth
        pageControl.currentPage = Int((round(pageFraction)))
    }
}

protocol AKboardActionDelegate {
    func keyboardPhraseSelected(_ text: String)
}
