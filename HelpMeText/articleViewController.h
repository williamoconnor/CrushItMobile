//
//  articleViewController.h
// CrushIt
//
//  Created by William O'Connor on 6/2/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface articleViewController : UIViewController <UIWebViewDelegate>

@property (strong, nonatomic) NSDictionary* article;

@end
