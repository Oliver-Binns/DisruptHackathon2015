//
//  ContentCell.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet var emotionImage: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    private var emotion: Emotion!
    private var media: [Media] = [];
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count;
    }
    
    func updateMedia(emotion: Emotion, media: [Media]){
        self.emotion = emotion;
        self.emotionImage.image = emotion.image;
        self.media = media;
        
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData();
        });
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionContentCell", forIndexPath: indexPath) as! EmotionContentCell
        cell.showImage.image = media[indexPath.row].image;
        return cell;
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        super.awakeFromNib();
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        _ = floor(self.frame.width)
        //let contentWidth = floor(view.frame.width / 4)
        
        if indexPath.section == 0 {
            return CGSizeMake(249 - 10, 140)
        } else {
            return CGSizeMake(249 - 10, 140)
        }
    }
}
