//
//  PhotosCollectionViewController.h
// CrushIt
//
//  Created by William O'Connor on 6/22/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface PhotosCollectionViewController : UICollectionViewController <QBChatDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) NSString* displayName;

@end
