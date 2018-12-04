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
    var keyboardHandle: KeyboardDataHandle = KeyboardDataHandle()
    var pageControl = UIPageControl()
    var myPageControl: MyPageControl!
    // instantiate the view
    let keyboardView = UINib(nibName: "AKboard", bundle: nil).instantiate(withOwner: self)[0] as! AKboardView
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    override func viewDidAppear(_ animated: Bool) {
         print("view appeared")
    }
    
    private func setup(){
        self.view.backgroundColor = UIColor.white
        self.nextKeyboardButton = UIButton(type: .system)
        //self.nextKeyboardButton.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.setImage(UIImage(named: "globe_ios"), for: .normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.loadKeyboard()
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        self.nextKeyboardButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -10).isActive = true
    }
    
    override func textWillChange(_ textInput: UITextInput?) {
        // The app is about to change the document's contents. Perform any preparation here.
    }
    
    override func textDidChange(_ textInput: UITextInput?) {
        
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
          keyboardView.keyboardDelegate = self
          keyboardView.setupPageViews(keyboardHandle.getAll())
          self.view.addSubview(keyboardView)
          NSLayoutConstraint.activate([
           keyboardView.topAnchor.constraint(equalTo: view.topAnchor ),
           keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
           keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
           keyboardView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        setupMyPageControl()
    }
    
    func setupPageControl(){
        // *** ADD PAGECONTROLL *** //
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(pageControl)
        pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        //pageControl.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: ).isActive = true
        pageControl.numberOfPages = 3;
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
        self.view.addSubview(self.myPageControl.stack!)
        myPageControl.stack!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        myPageControl.stack!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -5).isActive = true
    }
}


extension KeyboardViewController: AKboardActionDelegate{
    func keyboardPhraseSelected(_ text: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(text)
    }
}
