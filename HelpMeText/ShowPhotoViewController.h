//
//  ShowPhotoViewController.h
// CrushIt
//
//  Created by William O'Connor on 6/22/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShowPhotoViewController : UICollectionViewController

@property (strong, nonatomic) UIImage* image;
@property (strong, nonatomic) NSString* displayName;
@property (strong, nonatomic) NSString* dateString;

@end
