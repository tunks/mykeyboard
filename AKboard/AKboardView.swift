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
    //var viewActionDelegate: AKboardViewActionDelegate?
    private var scrollView = UIScrollView(frame: .zero)
    private var stackView = UIStackView(frame: .zero)
    private var views:[UIView] = []
    var pageControl = UIPageControl()
    
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
        // [1]
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.backgroundColor = .black
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        
        // [2]
        self.addSubview(scrollView)
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            // [1]
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: -10),
            // [2]
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        // *** SETUP STACKVIEW AND ADD SUBVIEWS *** //
        // [1]
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.distribution = .equalSpacing
        stackView.spacing = 20
        
        // [2]
        scrollView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 10),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -10)
            ])
        
        // Initializing the views we'll put in the scrollView and adding them to an array for convenience
        let pageView1 = PageView(index: 0, backgroundColor: .red)
        let pageView2 = PageView(index: 1, backgroundColor: .orange)
        let pageView3 = PageView(index: 2, backgroundColor: .blue)
        let pageView4 = PageView(index: 3, backgroundColor: .green)

        
        views.append(pageView1)
        views.append(pageView2)
        views.append(pageView3)
        views.append(pageView4)
        // [1]
        views.forEach { (view) in
            view.translatesAutoresizingMaskIntoConstraints = false
            // [2]
            stackView.addArrangedSubview(view)
            view.heightAnchor.constraint(equalTo: self.heightAnchor).isActive = true
            view.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        }
        
       // setupPageControls()
    }
    
    func setupPageControls(){
        // *** ADD PAGECONTROLL *** //
        // [1]
        //pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(pageControl)
        //pageControl.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        //pageControl.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -20).isActive = true
        // [2]
        pageControl.numberOfPages = 3;//views.count
        // [3]
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



protocol AKboardViewActionDelegate {
    func setupControls();
}
