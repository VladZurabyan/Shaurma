//
//  DetailViewController.swift
//  shaurma
//
//  Created by Admin on 8/8/20.
//  Copyright © 2020 Admin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var passedData = (title: "Name", img: #imageLiteral(resourceName: "3"), location: "Erevan")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        
        setupViews()
        lblLocation.numberOfLines = 0
    }
    
    func setupViews() {
        
        self.view.addSubview(myScrollView)
        myScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive=true
        myScrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive=true
        myScrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive=true
        myScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        myScrollView.contentSize.height = 1000
        
        myScrollView.addSubview(containerView)
        containerView.centerXAnchor.constraint(equalTo: myScrollView.centerXAnchor).isActive=true
        containerView.topAnchor.constraint(equalTo: myScrollView.topAnchor).isActive=true
        containerView.widthAnchor.constraint(equalTo: myScrollView.widthAnchor).isActive=true
        containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive=true
        
        containerView.addSubview(imgView)
        imgView.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive=true
        imgView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: -43).isActive=true
        imgView.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive=true
        imgView.heightAnchor.constraint(equalToConstant: 400).isActive=true
        imgView.image = passedData.img
        
        containerView.addSubview(lblTitle)
        lblTitle.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 15).isActive=true
        lblTitle.topAnchor.constraint(equalTo: imgView.bottomAnchor).isActive=true
        lblTitle.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -15).isActive=true
        lblTitle.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblTitle.textAlignment = .center
        lblTitle.text = passedData.title
        
        
        containerView.addSubview(lblRating)
        lblRating.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 290).isActive=true
        lblRating.topAnchor.constraint(equalTo: imgView.bottomAnchor, constant: -52).isActive=true
        lblRating.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive=true
        lblRating.heightAnchor.constraint(equalToConstant: 50).isActive=true
        lblRating.textAlignment = .right
        

        containerView.addSubview(lblLocation)
        lblLocation.leftAnchor.constraint(equalTo: lblTitle.leftAnchor).isActive=true
        lblLocation.topAnchor.constraint(equalTo: lblTitle.bottomAnchor).isActive=true
        lblLocation.rightAnchor.constraint(equalTo: lblTitle.rightAnchor).isActive=true
        lblLocation.heightAnchor.constraint(equalToConstant: 60).isActive=true
        lblLocation.text = "\(passedData.location)"
        
        containerView.addSubview(commentButton)
        commentButton.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 30).isActive=true
        commentButton.topAnchor.constraint(equalTo: lblLocation.bottomAnchor, constant: 100).isActive=true
        commentButton.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -30).isActive=true
        commentButton.heightAnchor.constraint(equalToConstant: 60).isActive=true
    }
    
    let myScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints=false
        scrollView.showsVerticalScrollIndicator=false
        scrollView.showsHorizontalScrollIndicator=false
        return scrollView
    }()
    
    let containerView: UIView = {
        let v=UIView()
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let imgView: UIImageView = {
        let v=UIImageView()
        v.image = #imageLiteral(resourceName: "3")
        v.contentMode = .scaleAspectFill
        v.clipsToBounds=true
        v.translatesAutoresizingMaskIntoConstraints=false
        return v
    }()
    
    let lblTitle: UILabel = {
        let lbl=UILabel()
        lbl.text = "Name"
        lbl.font=UIFont.systemFont(ofSize: 28)
        lbl.textColor = UIColor.black
        lbl.translatesAutoresizingMaskIntoConstraints=false
        return lbl
    }()
    
    let lblRating: UILabel = {
        let lbl=UILabel()
        lbl.text = "7.6⭐️"
        lbl.font=UIFont.systemFont(ofSize: 28)
        lbl.textColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        lbl.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        lbl.layer.cornerRadius = 15
        lbl.clipsToBounds = true
        return lbl
    }()
    
    
    let lblLocation: UILabel = {
        let lbl=UILabel()
        lbl.text = "Location"
        lbl.font=UIFont.boldSystemFont(ofSize: 24)
        lbl.textColor = UIColor(white: 0.5, alpha: 1)
        lbl.translatesAutoresizingMaskIntoConstraints=false
        lbl.numberOfLines = 0
        lbl.minimumScaleFactor = 15
        return lbl
    }()
    
    let commentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Add Comment", for: .normal)
        button.backgroundColor = #colorLiteral(red: 0.6666666865, green: 0.6666666865, blue: 0.6666666865, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonAction(sender: UIButton!)
    {
        let commentVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "CommentViewController") as! CommentViewController
        self.present(commentVC, animated: true, completion: nil)
    }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let dest = segue.destination as? AddViewController {
//            dest.locationText.text = lblLocation.text
//            dest.photo.image = imgView.image
//            dest.nameText.text = title
//        }
//    }
    
    
    
}


