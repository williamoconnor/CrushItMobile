//
//  ExpertsViewController.h
// CrushIt
//
//  Created by William O'Connor on 6/14/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>

@interface ExpertsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, QBChatDelegate>

@property (strong, nonatomic) NSString* specialty;

@end
