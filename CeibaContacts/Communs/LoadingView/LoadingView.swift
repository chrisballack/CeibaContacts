//
//  LoadingView.swift
//  CeibaContacts
//
//  Created by Dev IOS on 11/09/22.
//

import UIKit
import Lottie

class LoadingViewController: UIView {
    
    @IBOutlet  var BackView: UIView!
    @IBOutlet  var LoadingView: AnimationView!
    
}

    var loadingView: LoadingViewController?

    func showLoadingView(vista: UIViewController) {
        
        loadingView = (Bundle.main.loadNibNamed("LoadingView", owner: vista, options: nil)?.first as? LoadingViewController)!
        vista.view.addSubview((loadingView!))
        
        loadingView!.frame = CGRect(x: vista.view.center.x - (vista.view.frame.width/2), y: vista.view.center.y - (vista.view.frame.height/2), width: vista.view.frame.width, height: vista.view.frame.height)
        
        let animation = Animation.named("Loading",subdirectory: "Animaciones")
        loadingView!.LoadingView.backgroundColor = .clear
        loadingView!.LoadingView.animation = animation
        loadingView!.LoadingView.contentMode = .scaleAspectFit
        loadingView!.LoadingView.play(fromFrame: 0, toFrame: 200.0, loopMode: .loop, completion: nil)
        loadingView!.isHidden = false
        
    }

    func HideLoadingView(vista: UIViewController) {
        
        DispatchQueue.main.async {
            
            loadingView!.isHidden = true
            loadingView!.removeFromSuperview()
            loadingView = nil
        }
        
    }
