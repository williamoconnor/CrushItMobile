//
//  liveChatViewController.h
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Quickblox/Quickblox.h>
#import "JSQMessages.h"
#import "CustomIOSAlertView.h"


@interface liveChatViewController : JSQMessagesViewController <QBChatDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, CustomIOSAlertViewDelegate, UIAlertViewDelegate>

@property NSUInteger recipientID;

//only for experts
@property (strong, nonatomic) NSDictionary* user;
@property (strong, nonatomic) NSDictionary* expert;
@property (strong, nonatomic) NSString* dialog_id;
@property (strong, nonatomic) NSDictionary* chat;

@end
