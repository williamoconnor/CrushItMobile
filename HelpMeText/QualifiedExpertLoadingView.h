//
//  QualifiedExpertLoadingView.h
//  CrushIt
//
//  Created by William O'Connor on 8/11/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol QualifiedExpertsLoadingDelegate <NSObject>

- (void) continueToQualifiedChat;
- (NSDictionary*) findExpert;

@end

@interface QualifiedExpertLoadingView : UIView

@property (strong, nonatomic) UIButton* continueButton;
@property (strong, nonatomic) UILabel* loadingTextLabel;
//@property (strong, nonatomic) UIButton* findExpertButton;
@property (nonatomic) id <QualifiedExpertsLoadingDelegate> delegate;

- (id) initWithFrame:(CGRect)frame;
- (void) noExpertsAvailable;
- (void) findExpert;

@end
