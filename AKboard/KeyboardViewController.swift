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
    var pageControl: MyPageControl!
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
         //print("view appeared")
    }
    
    private func setup(){
        self.view.backgroundColor = UIColor.white
        self.nextKeyboardButton = UIButton(type: .system)
        //self.nextKeyboardButton.setTitle(NSLocalizedString("Next", comment: "Title for 'Next Keyboard' button"), for: [])
        self.nextKeyboardButton.setImage(UIImage(named: "globe_ios2"), for: .normal)
        self.nextKeyboardButton.sizeToFit()
        self.nextKeyboardButton.translatesAutoresizingMaskIntoConstraints = false
        self.nextKeyboardButton.addTarget(self, action: #selector(handleInputModeList(from:with:)), for: .allTouchEvents)
        self.loadKeyboard()
        self.view.addSubview(self.nextKeyboardButton)
        self.nextKeyboardButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
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
          keyboardView.pageControlDelegate = self
          let keyboardPages = keyboardHandle.getAll()
          keyboardView.setupPageViews(keyboardPages)
          self.view.addSubview(keyboardView)
          NSLayoutConstraint.activate([
           keyboardView.topAnchor.constraint(equalTo: view.topAnchor ),
           keyboardView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
           keyboardView.leftAnchor.constraint(equalTo: view.leftAnchor),
           keyboardView.widthAnchor.constraint(equalTo: view.widthAnchor)
            ])
        
        self.setupPageControl(keyboardPages)
    }

    func setupPageControl(_ keyboardPages: [KeyboardPage]){
        var categories = [PageCategory]();
        for page in keyboardPages.sorted(by: {$0.pageIndex < $1.pageIndex}) {
            categories.append(PageCategory(title: "\(page.pageIndex + 1)"))
        }
        self.pageControl = MyPageControl(categories)
        self.pageControl.stack!.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.delegate = self.keyboardView
        self.view.addSubview(self.pageControl.stack!)
        pageControl.stack!.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        pageControl.stack!.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -8).isActive = true
        //select first page
        pageControl.selectIndex(0)
    }
}


/***
  AKboardAction Delegate implementation
 */
extension KeyboardViewController: AKboardActionDelegate{
    func keyboardPhraseSelected(_ text: String) {
        let proxy = textDocumentProxy as UITextDocumentProxy
        proxy.insertText(text)
    }
}

/***
  MyPageControl Delegate implementation
 */
extension KeyboardViewController : MyPageControlDelegate{
    func selectedIndex(_ index: Int) {
        self.pageControl.selectIndex(index)
    }
}
