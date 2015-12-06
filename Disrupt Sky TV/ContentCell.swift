//
//  ContentCell.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    @IBOutlet weak var collectionView: UICollectionView!
    var emotion: Emotion!
    var media: [Media]!
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            //Show Our Emotions
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! EmotionCell
            
            return cell;
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionContentCell", forIndexPath: indexPath) as! EmotionContentCell
            return cell;
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib();
    }
}
