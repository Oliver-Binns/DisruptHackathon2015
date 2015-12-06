//
//  ContentCell.swift
//  Disrupt Sky TV
//
//  Created by Andrew Walker on 05/12/2015.
//  Copyright © 2015 Andrew Walker. All rights reserved.
//

import UIKit

class ContentCell: UICollectionViewCell, UICollectionViewDelegate, UICollectionViewDataSource{
    
    
    @IBOutlet weak var showCounterLabel: UILabel!
    @IBOutlet var emotionImage: UIImageView!
    @IBOutlet var collectionView: UICollectionView!
    
    private var emotion: Emotion!
    private var media: [Media] = [];
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return media.count;
    }
    
    func updateMedia(emotion: Emotion, media: [Media]){
        self.emotion = emotion;
        self.emotionImage.image = emotion.image;
        self.media = media;
        showCounterLabel.text = String(media.count)
        dispatch_async(dispatch_get_main_queue(), {
            self.collectionView.reloadData();
        });
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionContentCell", forIndexPath: indexPath) as! EmotionContentCell
        cell.showImage.image = media[indexPath.row].image
        cell.showTitle.text = media[indexPath.row].title
        return cell;
    }
    
    override func awakeFromNib() {
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        super.awakeFromNib();
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let contentHeight = self.frame.height;
        let contentWidth = (self.frame.height / 9.0) * 16;
        
        if indexPath.section == 0 {
            return CGSizeMake(contentWidth, contentHeight)
        } else {
            return CGSizeMake(contentWidth, contentHeight)
        }
    }
}
