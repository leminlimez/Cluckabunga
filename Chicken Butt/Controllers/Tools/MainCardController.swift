//
//  MainCardController.swift
//  ID Changer
//
//  Created by lemin on 8/29/23.
//

import Foundation
import SwiftUI

struct Card: Identifiable {
    var id = UUID()
    var cardPath: String
    var vnodeOrig: UInt64
    var imagePath: String
    var changingImage: Bool
    var newImage: UIImage
}

func respring() {
    UIImpactFeedbackGenerator(style: .soft).impactOccurred()
    
    let animator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1) {
        let windows: [UIWindow] = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap(\.windows)
        
        for window in windows {
            window.alpha = 0
            window.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
        }
    }
    
    animator.addCompletion { _ in
        if #available(iOS 16.2, *) {
            restartFrontboard()
        } else if UserDefaults.standard.string(forKey: "RespringType") ?? "Backboard" == "Backboard" {
            restartBackboard()
        } else {
            restartFrontboard()
        }
        
        sleep(2) // give the springboard some time to restart before exiting
        exit(0)
    }
    
    animator.startAnimation()
}

class MainCardController {
    // Code adapted from Cowabunga
    
    private static let cardTypes: [String] = [
        "cardBackground@2x.png",
        "cardBackgroundCombined@2x.png",
        "cardBackgroundCombined-watch@2x.png"
    ]
    
    public static var kopened: Bool = false
    
    // MARK: General Card Methods
    
    static func rmMountedDir() {
        let fm = FileManager.default
        if fm.fileExists(atPath: NSHomeDirectory() + "/Documents/mounted") {
            do {
                try fm.removeItem(atPath: NSHomeDirectory() + "/Documents/mounted")
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func getPasses(fullPath: String) -> [Card]
    {
        let fm = FileManager.default
        var path = fullPath + "/"
        if #available(iOS 16.2, *) {
            path += "Cards/"
        }
        var data = [Card]()
        
        do {
            let passes = try fm.contentsOfDirectory(atPath: path).filter {
                $0.hasSuffix("pkpass");
            }
            
            for pass in passes {
                var vnode: UInt64 = 0
                if #available(iOS 16.2, *) {
                    // kfd need to redirect
                    vnode = redirectCardFolder(pass + "/")
                }
                let files = try fm.contentsOfDirectory(atPath: fullPath + "/" + pass)
                
                var added = false
                
                for cardType in cardTypes {
                    if files.contains(cardType) {
                        data.append(.init(cardPath: pass, vnodeOrig: vnode, imagePath: cardType, changingImage: false, newImage: UIImage()))
                        added = true
                        break
                    }
                }
                
                if !added, #available(iOS 16.2, *) {
                    UnRedirectAndRemoveFolder(vnode, path + pass)
                }
            }
            print(data)
            return data
            
        } catch {
            print(error.localizedDescription)
            return []
        }
    }
    
    static func canReset(card: Card, fullPath: String) -> Bool {
        let fm = FileManager.default
        
        if fm.fileExists(atPath: "\(fullPath)/\(card.cardPath)/\(card.imagePath).backup") {
            return true
        }
        
        return false
    }
    
    // apply changes to card
    static func setChanges(_ kfd: UInt64, vnodeOrig: UInt64, cards: [Card], fullPath: String) {
        let fm = FileManager.default
        
        for card in cards {
            // set the image
            if card.changingImage {
                setImage(card: card, fullPath: fullPath)
                
                if #available(iOS 16.2, *) {
                    // kfd fallback
                    try? fm.removeItem(atPath: "\(fullPath)/Cards/" + card.cardPath.replacingOccurrences(of: "pkpass", with: "cache"))
                    UnRedirectAndRemoveFolder(card.vnodeOrig, fullPath + "/\(card.cardPath)/")
                } else {
                    // do not force delete in case it is already not there
                    try? fm.removeItem(atPath: "\(fullPath)/" + card.cardPath.replacingOccurrences(of: "pkpass", with: "cache"))
                }
            }
        }
        
        // for kfd, kclose
        if #available(iOS 16.2, *) {
            UnRedirectAndRemoveFolder(vnodeOrig, fullPath + "/Cards/");
            do_kclose(kfd)
        }
        
        // respring to apply changes
        respring()
    }
    
    // revert changes to card
    static func resetChanges(_ kfd: UInt64, vnodeOrig: UInt64, card: Card, fullPath: String) {
        let fm = FileManager.default
        
        // reset the image
        resetImage(card: card, fullPath: fullPath)
        
        // do not force delete in case it is already not there
        do {
            try fm.removeItem(atPath: "\(fullPath)/" + card.cardPath.replacingOccurrences(of: "pkpass", with: "cache"))
        } catch {
            print(error.localizedDescription)
        }
        
        // for kfd, kclose
        if #available(iOS 16.2, *) {
            UnRedirectAndRemoveFolder(vnodeOrig, fullPath);
            do_kclose(kfd)
        }
        
        // respring to apply changes
        respring()
    }
    
    
    // MARK: Image Methods
    
    static func setImage(card: Card, fullPath: String) {
        if let data = card.newImage.pngData() {
            do {
                let fm = FileManager.default
                
                let path = "\(fullPath)/\(card.cardPath)/\(card.imagePath)"
                
                if #available(iOS 16.2, *) {
                    // use kfd method
                    kfdOverwriteImage(filePath: path, image: data)
                    usleep(500)
                    return
                }
                
                if !fm.fileExists(atPath: path + ".backup") {
                    try fm.moveItem(atPath: path, toPath: path + ".backup")
                }
                try data.write(to: URL(fileURLWithPath: path))
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    static func kfdOverwriteImage(filePath: String, image: Data) {
        do {
            let imgPath = NSHomeDirectory() + "/Documents/temp.png"
            if FileManager.default.fileExists(atPath: imgPath) {
                try? FileManager.default.removeItem(atPath: imgPath)
            }
            try image.write(to: URL(fileURLWithPath: imgPath))
            
            overwritePath(filePath, imgPath)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    static func resetImage(card: Card, fullPath: String) {
        let fm = FileManager.default
        
        let imgPath = "\(fullPath)/\(card.cardPath)/\(card.imagePath)"
        if fm.fileExists(atPath: imgPath + ".backup") {
            do {
                try? fm.removeItem(atPath: imgPath)
                try fm.moveItem(atPath: imgPath + ".backup", toPath: imgPath)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
