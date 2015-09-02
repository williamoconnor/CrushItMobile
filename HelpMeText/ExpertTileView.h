//
//  ExpertTileView.h
// CrushIt
//
//  Created by William O'Connor on 7/24/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@interface ExpertTileView : UIButton

@property (strong, nonatomic) UILabel* nameLabel;
@property (strong, nonatomic) UIImageView* tileImageView;
@property (strong, nonatomic) UIImage* tileImage;
@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSDictionary* expert;

-(id) initWithFrame:(CGRect)frame andExpert:(NSDictionary*)expert;

@end
