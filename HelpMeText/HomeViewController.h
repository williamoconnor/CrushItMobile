//
//  HomeViewController.h
// CrushIt
//
//  Created by William O'Connor on 5/4/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"

@interface HomeViewController : UIViewController <UIAlertViewDelegate, CustomIOSAlertViewDelegate>

@property (strong, nonatomic) NSString* isNew;

@end
