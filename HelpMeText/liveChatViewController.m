//
//  liveChatViewController.m
// CrushIt
//
//  Created by William O'Connor on 5/5/15.
//  Copyright (c) 2015 CrushIt. All rights reserved.
//

#import "liveChatViewController.h"
#import "PhotosCollectionViewController.h"
#import "ExpertChatOptionsViewController.h"
#import "DataManager.h"
#import "RenewalView.h"


@interface liveChatViewController ()

@property (strong, nonatomic) NSMutableArray* messages;

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageData;

@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageData;

@property (strong, nonatomic) QBChatDialog* chatDialog;

@property (strong, nonatomic) NSDictionary* account;

@property (strong, nonatomic) NSData* attachmentData;

@property (strong, nonatomic) UIImage* qbMessageAttachmentImage;

@end

@implementation liveChatViewController

-(NSMutableArray*) messages
{
    if (!_messages) {
        _messages = [[NSMutableArray alloc] init];
    }
    return _messages;
}

//-(QBChatDialog*) chatDialog
//{
//    if (!_chatDialog) {
//        _chatDialog =
//    }
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor colorWithRed:37/255.0 green:168/255.0 blue:234/255.0 alpha:1.0];
    self.account = [[NSUserDefaults standardUserDefaults] objectForKey:@"account"];
    // Create session with user
    
    // BAR BUTTON
    UIBarButtonItem *item;
    if (self.account[@"expert_id"] != 0) {
        item = [[UIBarButtonItem alloc] initWithTitle:@"Chat Options"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(expertOptions)];
    }
    else {
        item = [[UIBarButtonItem alloc] initWithTitle:@"Photos"
                                                style:UIBarButtonItemStylePlain
                                               target:self
                                               action:@selector(showPicker)];
    }
    
    [self.navigationItem setRightBarButtonItem:item animated:NO];
    
//SESSION SHOULD ALREADY EXIST
    
    NSString *userLogin = self.account[@"username"];
    NSString *userPassword = self.account[@"password"];
    
    QBSessionParameters *parameters = [QBSessionParameters new];
    parameters.userLogin = userLogin;
    parameters.userPassword = userPassword;
    
    [QBRequest createSessionWithExtendedParameters:parameters successBlock:^(QBResponse *response, QBASession *session) {
        // Sign In to QuickBlox Chat
        QBUUser *currentUser = [QBUUser user];
        currentUser.ID = session.userID; // your current user's ID
        currentUser.password = userPassword; // your current user's password

        //nslog(@"Session creation response: %@", response);
        
        // set Chat delegate
        [[QBChat instance] addDelegate:self];
        
        // login to Chat
        [[QBChat instance] loginWithUser:currentUser];

        
    } errorBlock:^(QBResponse *response) {
        // error handling
        //nslog(@" big error: %@", response.error);
    }];
    
    self.senderId = [NSString stringWithFormat:@"%@", self.account[@"qb_id"]];
    self.senderDisplayName = self.account[@"username"];
    
    JSQMessagesBubbleImageFactory *bubbleFactory = [[JSQMessagesBubbleImageFactory alloc] init];
    
    self.outgoingBubbleImageData = [bubbleFactory outgoingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleGreenColor]];
    self.incomingBubbleImageData = [bubbleFactory incomingMessagesBubbleImageWithColor:[UIColor jsq_messageBubbleLightGrayColor]];
    
    // RENEWAL
    if (self.user[@"expert_id"] == 0) {
        if ((BOOL)self.chat[@"pending_renewal"] == true) {
            [self handleRenewal];
        }
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark -
#pragma mark QBChatDelegate

// Chat delegate
-(void) chatDidLogin{
    // You have successfully signed in to QuickBlox Chat
}

- (void)chatDidNotLogin{
    
}

- (void)chatDidReceiveMessage:(QBChatMessage *)message{
    // this will definitely need some shit
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[PhotosCollectionViewController class]]) {
        PhotosCollectionViewController* dest = segue.destinationViewController;
        dest.displayName = self.senderDisplayName;
    }
    else {
        ExpertChatOptionsViewController* dest = segue.destinationViewController;
        dest.user = self.user;
        dest.expert = self.expert;
        dest.chat = self.chat;
    }
}


#pragma mark - JSQMessagesCollectionViewDataSource


-(id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self.messages objectAtIndex:indexPath.item];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  You may return nil here if you do not want bubbles.
     *  In this case, you should set the background color of your collection view cell's textView.
     *
     *  Otherwise, return your previously created bubble image data objects.
     */
    
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    if ([message.senderId isEqualToString:self.senderId]) {
        return self.outgoingBubbleImageData;
    }
    return self.incomingBubbleImageData;
}


- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    
    /**
     *  iOS7-style sender name labels
     */
    if ([message.senderId isEqualToString:self.senderId]) {
        return nil;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([previousMessage.senderId isEqualToString:message.senderId]) {
            return nil;
        }
    }
    
    /**
     *  Don't specify attributes to use the defaults.
     */
    return [[NSAttributedString alloc] initWithString:message.senderDisplayName];
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  This logic should be consistent with what you return from `heightForCellTopLabelAtIndexPath:`
     *  The other label text delegate methods should follow a similar pattern.
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
        return [[JSQMessagesTimestampFormatter sharedFormatter] attributedTimestampForDate:message.date];
    }
    
    return nil;
}

- (NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark - JSMessage View Controller method overrides

- (void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date
{
    /**
     *  Sending a message. Your implementation of this method should do *at least* the following:
     *
     *  1. Play sound (optional)
     *  2. Add new id<JSQMessageData> object to your data source
     *  3. Call `finishSendingMessage`
     */
//    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:senderId senderDisplayName:senderDisplayName date:date text:text];
    [self.messages addObject:message];
    [self.collectionView reloadData];
    
    [self finishSendingMessage];
    
    //send message
    QBChatMessage *qbMessage = [QBChatMessage message];
    [qbMessage setText:text];
    //
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"save_to_history"] = @YES;
    [qbMessage setCustomParameters:params];
    //
    [qbMessage setRecipientID:self.recipientID]; // ID initially passed in
    [qbMessage setSenderID:[self.senderId integerValue]];
    //
    [[QBChat instance] sendMessage:qbMessage];

    //nslog(@"sent: %@ to: %lu from: %lu" , [QBChat instance], qbMessage.recipientID, qbMessage.senderID);
    
}

- (void)didPressAccessoryButton:(UIButton *)sender
{
    ////nslog(@"Camera pressed!");
    /**
     *  Accessory button has no default functionality, yet.
     */
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *_picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
            
            [self presentViewController:_picker animated:YES completion:nil];
            
        }
//        else {
//
//        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error accessing photo library"
                                                        message:@"your device does not support photo library"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
    }
}

#pragma mark - UICollectionView DataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    ////nslog(@"%i", [self.messages count]);
    return [self.messages count];
}

- (UICollectionViewCell *)collectionView:(JSQMessagesCollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Override point for customizing cells
     */
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    
    /**
     *  Configure almost *anything* on the cell
     *
     *  Text colors, label text, label colors, etc.
     *
     *
     *  DO NOT set `cell.textView.font` !
     *  Instead, you need to set `self.collectionView.collectionViewLayout.messageBubbleFont` to the font you want in `viewDidLoad`
     *
     *
     *  DO NOT manipulate cell layout information!
     *  Instead, override the properties you want on `self.collectionView.collectionViewLayout` from `viewDidLoad`
     */
    
    JSQMessage *msg = [self.messages objectAtIndex:indexPath.item];
    
    if ([msg.senderId isEqualToString:self.senderId]) {
        cell.textView.textColor = [UIColor whiteColor];
    }
    else {
        cell.textView.textColor = [UIColor blackColor];
    }
    
    cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                          NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    cell.textView.text = msg.text;
    
    return cell;
}

#pragma mark - JSQMessages collection view flow layout delegate

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForMessageBubbleTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  iOS7-style sender name labels
     */
    JSQMessage *currentMessage = [self.messages objectAtIndex:indexPath.item];
    if ([currentMessage.senderId isEqualToString:self.senderId]) {
        return 0.0f;
    }
    
    if (indexPath.item - 1 > 0) {
        JSQMessage *previousMessage = [self.messages objectAtIndex:indexPath.item - 1];
        if ([previousMessage.senderId isEqualToString:currentMessage.senderId]) {
            return 0.0f;
        }
    }
    
    return kJSQMessagesCollectionViewCellLabelHeightDefault;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath
{
    return 0.0f;
}

- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView
                   layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellTopLabelAtIndexPath:(NSIndexPath *)indexPath
{
    /**
     *  Each label in a cell has a `height` delegate method that corresponds to its text dataSource method
     */
    
    /**
     *  This logic should be consistent with what you return from `attributedTextForCellTopLabelAtIndexPath:`
     *  The other label height delegate methods should follow similarly
     *
     *  Show a timestamp for every 3rd message
     */
    if (indexPath.item % 3 == 0) {
        return kJSQMessagesCollectionViewCellLabelHeightDefault;
    }
    
    return 0.0f;
}

- (void)collectionView:(JSQMessagesCollectionView *)collectionView
                header:(JSQMessagesLoadEarlierHeaderView *)headerView didTapLoadEarlierMessagesButton:(UIButton *)sender
{
    //nslog(@"Load earlier messages");
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}


#pragma mark - helpers

-(JSQMessage*)QBMessageToJSQMessage:(QBChatMessage*)qbMessage
{
    NSString *userId = [NSString stringWithFormat:@"%ld", qbMessage.senderID];
    
    JSQMessage* JSQMessageMessage = [[JSQMessage alloc] initWithSenderId:userId senderDisplayName:[NSString stringWithFormat:@"user_%@",userId] date:qbMessage.datetime text:qbMessage.text];
    // will want to query our database to get the username for that qb id. (need to save the qb id with the user)
    
    
    return JSQMessageMessage;
}

-(JSQMessage*)QBChatHistoryMessageToJSQMessage:(QBChatHistoryMessage*)qbMessage
{
    NSString *userId = [NSString stringWithFormat:@"%ld", qbMessage.senderID];
    NSString* displayName;
    if ([userId isEqualToString: self.account[@"qb_id"]]) {
        displayName = self.account[@"username"];
    }
    else {
        displayName = @"Help Me Text"; //may want to get the username for the id
    }
    
    JSQMessage* jsqmessage = [[JSQMessage alloc] initWithSenderId:@"1234" senderDisplayName:@"1234" date:[NSDate date] text:@"img"];
    if (!([qbMessage.text isEqualToString:@"img"] && qbMessage.attachments.count > 0)) {
        jsqmessage = [[JSQMessage alloc] initWithSenderId:[NSString stringWithFormat:@"%lu", (unsigned long)qbMessage.senderID] senderDisplayName:displayName date:qbMessage.datetime text:qbMessage.text];
    }
    
    
    return jsqmessage;
}

- (void) loadMessages
{
    QBResponsePage *resPage = [QBResponsePage responsePageWithLimit:20 skip:0];
    
    [QBRequest messagesWithDialogID:self.dialog_id extendedRequest:nil forPage:resPage successBlock:^(QBResponse *response, NSArray *messages, QBResponsePage *responsePage) {
//        //nslog(@"sample message: %@", [messages[0] className]);
        for (QBChatHistoryMessage* message in messages) {
            JSQMessage* jsqmessage = [self QBChatHistoryMessageToJSQMessage:message];
            NSString *userId = [NSString stringWithFormat:@"%ld", message.senderID];
            NSString* displayName;
            if ([userId isEqualToString: self.account[@"qb_id"]]) {
                displayName = self.account[@"username"];
            }
            else {
                displayName = @"Help Me Text";
            }
            if ([jsqmessage.senderId isEqualToString:@"1234"]) {
                //nslog(@"hello");
            }
            else{
                [self.messages addObject:jsqmessage];
            }
        }
        [self.collectionView reloadData];
    } errorBlock:^(QBResponse *response) {
        //nslog(@"error: %@", response.error);
    }];
    
}

#pragma mark - image picker

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* myImage = [info objectForKey:UIImagePickerControllerOriginalImage];
//    QBChatAttachment *textAttachment = [[QBChatAttachment alloc] init];
//    textAttachment.type = @"image";

    self.attachmentData = UIImagePNGRepresentation(myImage);

    
    //fuck it, just send it immediately
    [QBRequest TUploadFile:self.attachmentData fileName:@"image.jpg" contentType:@"image/jpg" isPublic:NO successBlock:^(QBResponse *response, QBCBlob *blob) {
        //success
        NSUInteger uploadID = blob.ID;
        
        QBChatMessage* message = [[QBChatMessage alloc] init];
        QBChatAttachment* attachment = QBChatAttachment.new;
        attachment.type = @"image";
        attachment.ID = [NSString stringWithFormat:@"%lu", (unsigned long)uploadID];
        
        [message setAttachments:@[attachment]];
        [message setRecipientID:self.recipientID];
        [message setText:@"img"];
        // send message??
        [[QBChat instance] sendMessage:message];
        
        // add jsqMediaMessage, too
        NSDate* date = [NSDate date];
        
        JSQMessage *jsqmessage = [[JSQMessage alloc] initWithSenderId:self.senderId senderDisplayName:self.senderDisplayName date:date text:@"photo added"];
        //nslog(@"MediaMessage: %@", message);
        [self.messages addObject:jsqmessage];
        [self.collectionView reloadData];
                
    } statusBlock:^(QBRequest *request, QBRequestStatus *status) {
        //handle progress
        //nslog(@"Here's the status: %f", status.percentOfCompletion);
    } errorBlock:^(QBResponse *response) {
        //error
        //nslog(@"fuck! there was an error: %@", response);
    }];
    
    
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)showPicker
{
    [self performSegueWithIdentifier:@"photosSegue" sender:self];
}

-(void) expertOptions
{
    [self performSegueWithIdentifier:@"expertOptionsSegue" sender:self];
}

#pragma mark - Renewal

-(void) handleRenewal
{
    // custom alert view asking if the user would like to renew the chat or end it
    CustomIOSAlertView* alertView = [[CustomIOSAlertView alloc] init];
    alertView.buttonTitles = @[@"End", @"Renew"];
    RenewalView* customView = [[RenewalView alloc] initWithFrame:CGRectMake(0.0, 5.0, 300.0, 200.0) andChat:self.chat andExpert:self.expert];
    [alertView setContainerView:customView];
    [alertView show];
    
}

- (void)customIOS7dialogButtonTouchUpInside: (CustomIOSAlertView *)alertView clickedButtonAtIndex: (NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // end chat
        UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"End Chat", nil];
        [confirm show];
    }
    else if (buttonIndex == 1){ // renew chat
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        params[@"chat_id"] = self.chat[@"id"];
        [DataManager renewChat:params];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) { // cancel
        
    }
    else if (buttonIndex == 1) { // end chat
        NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
        params[@"chat_id"] = self.chat[@"id"];
        [DataManager endChat:params];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
