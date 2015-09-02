//
//  RatingView.h
// CrushIt
//
//  Created by William O'Connor on 7/19/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RatingView : UIView

@property (strong, nonatomic) UISlider* ratingSlider;
@property (strong, nonatomic) UILabel* ratingSliderLabel;
@property (strong, nonatomic) NSDictionary* expert;
@property (strong, nonatomic) NSDictionary* chat;

- (id) initWithFrame:(CGRect)frame andExpert:(NSDictionary*) expert andChat:(NSDictionary*)chat;

@end
