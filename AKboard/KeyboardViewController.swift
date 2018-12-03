//
//  KeyboardViewController.swift
//  AKboard
//
//  Created by Ebrima Tunkara on 11/29/18.
//  Copyright © 2018 Ebrima Tunkara. All rights reserved.
//

import UIKit

class KeyboardViewController: UIInputViewController {

    @IBOutlet var nextKeyboardButton: UIButton!
    
    var dataHandle: DataHandle = KeyboardDataHandle()
    
    var keyboardView: UIView!
    var pageControl = UIPageControl()
    var myPageControl: MyPageControl!

    override func updateViewConstraints() {
        super.updateViewConstraints()
        // Add custom view sizing constraints here
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        KeyboardDataStore.registerDefaultsFromSettingsBundle()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.dataHandle = KeyboardDataHandle()
        // Perform custom UI setup here
        self.view.backgroundColor = UIColor.white
        self.nextKeyboardButton = UIButton(type: .system)
        
        self.nextKeyboardButton.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        
        self.loadKeyboard()
        self.view.addSubview(self.nextKeyboardButton)
   
        
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        // The app has just changed the document's contents, the document context has been updated.
        
        var textColor: UIColor
        let proxy = self.textDocumentProxy
        if proxy.keyboardAppearance == UIKeyboardAppearance.dark {
            textColor = UIColor.white
        } else {
            textColor = UIColor.black
        }
        self.nextKeyboardButton.setTitleColor(textColor, for: [])
    }

    
    func loadKeyboard(){
        // load the nib file
          let keyboardNib = UINib(nibName: "AKboard", bundle: nil)
          // instantiate the view
          keyboardView = keyboardNib.instantiate(withOwner: self)[0] as? AKboardView
          // add the interface to the main view
         // self.keyboardView.translatesAutoresizingMaskIntoConstraints = false
          self.view.addSubview(keyboardView)
        
        
          //self.nextKeyboardButton.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
          //self.nextKeyboardButton.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true

          //self.keyboardView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
          //self.view.to
         NSLayoutConstraint.activate([
           keyboardView.topAnchor.constraint(equalTo: view.topAnchor ),
           keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
           keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
           keyboardView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
           


            
            // copy the background color
            //view.backgroundColor = calculatorView.backgroundColor
        //self.setupPageControl();
        setupMyPageControl()
    }
    
    func setupPageControl(){
        
        // *** ADD PAGECONTROLL *** //
        // [1]
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        
        //pageControl.bringSubviewToFront(self.view)
        self.view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        // [2]
        pageControl.numberOfPages = 3;
        // [3]
        //pageControl.addTarget(self, action: #selector(pageControlTapped(sender:)), for: .valueChanged)
    }
    
    func setupMyPageControl(){
        var categories = [PageCategory]();
        categories.append(PageCategory(title: "A"))
        categories.append(PageCategory(title: "B"))
        categories.append(PageCategory(title: "C"))
        categories.append(PageCategory(title: "D"))
        categories.append(PageCategory(title: "E"))

        self.myPageControl = MyPageControl(categories)
        self.myPageControl.stack!.translatesAutoresizingMaskIntoConstraints = false
        //myPageControl.stack?.sizeToFit()
        self.view.addSubview(self.myPageControl.stack!)
        myPageControl.stack!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myPageControl.stack!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
    }
    
    @objc func pageControlTapped(sender: UIPageControl) {
        /*let pageWidth = self.view.bounds.width
        let offset = sender.currentPage * Int(pageWidth)
       / UIView.animate(withDuration: 0.33, animations: { [weak self] in
            self?.scrollView.contentOffset.x = CGFloat(offset)
        })
      */
    }
}


extension KeyboardViewController: AKboardViewActionDelegate{
    func setupControls() {
        
    }
}
