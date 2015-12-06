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
    private var emotion: Emotion!
    private var media: [Media] = [];
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(section == 1){
            return 1;
        }
        return media.count;
    }
    
    func updateMedia(emotion: Emotion, media: [Media]){
        self.emotion = emotion;
        self.media = media;
        self.collectionView.reloadData();
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            //Show Our Emotions
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionCell", forIndexPath: indexPath) as! EmotionCell
            cell.emotionImage.image = self.emotion.image;
            return cell;
        }else{
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("emotionContentCell", forIndexPath: indexPath) as! EmotionContentCell
            cell.showImage.image = media[indexPath.row].image;
            return cell;
        }
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
            return CGSizeMake(249, 140)
        } else {
            return CGSizeMake(249, 140)
        }
    }
}
