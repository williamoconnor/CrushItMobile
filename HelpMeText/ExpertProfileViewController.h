//
//  ExpertProfileViewController.h
// CrushIt
//
//  Created by William O'Connor on 7/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ExpertProfileViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSDictionary* expert;
@property (strong, nonatomic) UIImage* expertImage;

@end
