//
//  ExpertSpecialtyTile.h
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertSpecialtyTile : UIButton

@property (strong, nonatomic) UILabel* nameLabel;
//@property (strong, nonatomic) UIImageView* tileImageView;
@property (strong, nonatomic) UIImage* tileImage;
@property (strong, nonatomic) NSString* name;

-(id) initWithFrame:(CGRect)frame andName:(NSString*)name/* andImage:(UIImage*)image*/;

@end
