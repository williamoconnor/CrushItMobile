//
//  ExpertsViewController2.h
// CrushIt
//
//  Created by William O'Connor on 7/24/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomIOSAlertView.h"
#import "QualifiedExpertLoadingView.h"
#import "GetCorrespondencesView.h"

@interface ExpertsViewController2 : UIViewController <CustomIOSAlertViewDelegate, QualifiedExpertsLoadingDelegate, BuyCorrespondencesDelegate>

@end
