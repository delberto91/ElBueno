//
//  ChatMessagesVC.m
//  Chat21
//
//  Created by Dario De Pascalis on 22/03/16.
//  Copyright © 2016 Frontiere21. All rights reserved.
//

#import "ChatMessagesVC.h"

#import "ChatMessage.h"
#import "ChatUtil.h"
#import "ChatDB.h"
#import "ChatConversation.h"
#import "ChatManager.h"
#import "ChatConversationHandler.h"
#import "ChatConversationsVC.h"
#import "ChatStringUtil.h"
#import "ChatGroupInfoVC.h"
#import "QBPopupMenu.h"
#import "QBPopupMenuItem.h"
#import "ChatTitleVC.h"
#import "ChatImageCache.h"
#import "ChatImageWrapper.h"
#import "ChatMessagesTVC.h"
#import "ChatGroup.h"
#import "ChatStatusTitle.h"
#import "ChatGroupsHandler.h"
#import "ChatUIManager.h"
#import "ChatConnectionStatusHandler.h"
#import "ChatPresenceHandler.h"
#import "ChatContactsDB.h"
#import "ChatLocal.h"

@interface ChatMessagesVC (){
    SystemSoundID soundID;
}
@end

@implementation ChatMessagesVC

//int MAX_WIDTH_TEXTCHAT = 230;//250.0;
//int WIDTH_BOX_DATE = 50.0;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customizeTitle];
    
    NSLog(@"self.recipient.fullname: %@", self.recipient.fullname);
    keyboardShow = NO;
    
    self.me = [ChatManager getInstance].loggedUser;
    self.senderId = self.me.userId;
    [self registerForKeyboardNotifications];
    [self backgroundTapToDismissKB:YES];
    
    originalViewHeight = self.view.bounds.size.height;
    heightTable = 0;// self.tableView.bounds.size.height;
    self.bottomReached = YES;
    
    [self setupLabels];
    [self buildUnreadBadge];
    
    //    self.group.name = nil; // TEST DOWNLOAD GRUPPO METADATI PARZIALI
    if (self.recipient) { // online status only in DM mode
        [self setupForDirectMessageMode];
    }
//    else if (self.group && !self.group.completeData) {
//        // group's metadata not available, downloading
//        // the conversationHandler object needs all group's metadata (members)
//        // so it can't be initialized without completing group's info
//        [self loadGroupInfo];
//    }
    else if (self.group) { // all group metadata ok
        [self setupForGroupMode];
    }
    else {
        NSLog(@"Error: impossible configuration! No Group and no recipient!");
    }
    
    if (self.isModal) {
        UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAction)];
        [self.navigationItem setLeftBarButtonItem:leftBarButton];
        //self.cancelButton.title = NSLocalizedString(@"cancel", nil);
    }
    [self setContainer];
    self.navigationItem.hidesBackButton = YES;
    [self.messageTextField becomeFirstResponder];
    [self.messageTextField.layer setBorderWidth:1.0f];
    [self.messageTextField.layer setCornerRadius:8.0f];
    [[self.messageTextField layer] setBorderColor:[[UIColor redColor]CGColor]];
    
    
    
    /*[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault]; //UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.shadowImage = [UIImage new];////UIImageNamed:@"transparent.png"
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.view.backgroundColor = [UIColor clearColor];*/
}

-(BOOL)ImInGroup {
    NSLog(@"can I write in this group?");
    if (!self.group) {
        return NO;
    }
    NSDictionary *members = self.group.members;
    NSString *user_found = [members objectForKey:self.me.userId];
    return user_found ? YES : NO;
}

-(void)setupForDirectMessageMode {
    [self setupConnectionStatus];
    [self initConversationHandler];
    [self setupRecipientOnlineStatus];
    [self sendTextAsChatOpens];
    self.recipient.fullname ? [self setTitle:self.recipient.fullname] : [self setTitle:self.recipient.userId];
}

-(void)setupForGroupMode {
    self.activityIndicator.hidden = YES;
    [self initConversationHandler];
    [self writeBoxEnabled];
    if ([self ImInGroup]) {
        [self sendTextAsChatOpens];
    }
    //    [self.usernameButton setTitle:self.group.name forState:UIControlStateNormal];
    [self setTitle:self.group.name];
    [self.group completeGroupMembersMetadataWithCompletionBlock:^() {
        [self setSubTitle:[ChatUtil groupMembersFullnamesAsStringForUI:self.group.membersFull]];
    }];
//    ChatContactsDB *db = [ChatContactsDB getSharedInstance];
//    NSArray<NSString *> *contact_ids = [self.group.members allKeys];
//    [db getMultipleContactsByIdsSyncronized:contact_ids completion:^(NSArray<ChatUser *> *contacts) {
//        self.group.membersFull = contacts;
//        [self setSubTitle:[ChatUtil groupMembersFullnamesAsStringForUI:contacts]];
//    }];
}

//-(void)loadGroupInfo {
//    self.usernameButton.hidden = YES;
//    self.activityIndicator.hidden = NO;
//    [self.activityIndicator startAnimating];
//    [self setSubTitle:@""];
//    //    self.statusLabel.text = @"";
//    ChatManager *chatm = [ChatManager getInstance];
//    NSString *group_id = self.group.groupId;
//    __weak ChatMessagesVC *weakSelf = self;
//    [chatm loadGroup:group_id completion:^(ChatGroup *group, BOOL error) {
//        NSLog(@"Group %@ info loaded", group.name);
//        weakSelf.usernameButton.hidden = NO;
//        weakSelf.activityIndicator.hidden = YES;
//        [weakSelf.activityIndicator stopAnimating];
//        if (error) {
//            [weakSelf setSubTitle:@"Errore gruppo"];
//            //            weakSelf.statusLabel.text = @"Errore gruppo";
//        }
//        else {
//            weakSelf.group = group;
//            [weakSelf setupForGroupMode];
//        }
//    }];
//}

//-(void)loadGroupInfo:(ChatGroup *)group completion:(void (^)(BOOL error))callback {
//    FIRDatabaseReference *rootRef = [[FIRDatabase database] reference];
//    NSString *groups_path = [ChatUtil groupsPath];
//    NSString *path = [[NSString alloc] initWithFormat:@"%@/%@", groups_path, group.groupId];
//    NSLog(@"Load Group on path: %@", path);
//    FIRDatabaseReference *groupRef = [rootRef child:path];
//
//    [groupRef observeEventType:FIRDataEventTypeValue withBlock:^(FIRDataSnapshot *snapshot) {
//        NSLog(@"NEW GROUP SNAPSHOT: %@", snapshot);
//        if (!snapshot || ![snapshot exists]) {
//            NSLog(@"Errore gruppo: !snapshot || !snapshot.exists");
//            callback(YES);
//        }
//        self.group = [ChatManager groupFromSnapshotFactory:snapshot];
//        ChatGroupsHandler *gh = [ChatManager getSharedInstance].groupsHandler;
//        [gh insertOrUpdateGroup:group];
//        callback(NO);
//    } withCancelBlock:^(NSError *error) {
//        NSLog(@"%@", error.description);
//    }];
//}

-(void)writeBoxEnabled {
    [self ImInGroup] ? [self hideBottomView:NO] : [self hideBottomView:YES];
}

-(void)hideBottomView:(BOOL)hide {
    if (hide) {
        NSLog(@"Hide write box");
        self.bottomView.hidden = YES;
        self.bottomViewHeightConstraint.constant = 0.0;
    } else {
        NSLog(@"Show write box");
        self.bottomView.hidden = NO;
        self.bottomViewHeightConstraint.constant = 44.0;
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden=YES;
    [containerTVC scrollToLastMessage:NO];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
    [self updateUnreadMessagesCount];
}

-(void)subscribeForMessages:(ChatConversationHandler  *)handler {
    self.added_handle = [handler observeEvent:ChatEventMessageAdded withCallback:^(ChatMessage *message) {
        [self messageReceived:message];
    }];
    self.changed_handle = [handler observeEvent:ChatEventMessageChanged withCallback:^(ChatMessage *message) {
        [self messageUpdated:message];
    }];
    self.deleted_handle = [handler observeEvent:ChatEventMessageDeleted withCallback:^(ChatMessage *message) {
        [self messageDeleted:message];
    }];
//    if (self.group) {
//        [self monitorGroupUpdates];
//    }
//    NSLog(@"added_handle: %lu, changed_handle: %lu, deleted_handle: %lu", (unsigned long)self.added_handle, (unsigned long)self.changed_handle, (unsigned long)self.deleted_handle);
}

-(void)monitorGroupUpdates {
    [[ChatManager getInstance].groupsHandler addSubscriber:self];
}
-(void)removeSubscribers {
    if (self.conversationHandler) {
        [self.conversationHandler removeObserverWithHandle:self.added_handle];
        [self.conversationHandler removeObserverWithHandle:self.changed_handle];
        [self.conversationHandler removeObserverWithHandle:self.deleted_handle];
    }
    self.added_handle = 0;
    self.changed_handle = 0;
    self.deleted_handle = 0;
    //    [self.connectedRef removeObserverWithHandle:self.connectedRefHandle];
    ChatManager *chatm = [ChatManager getInstance];
    [chatm.connectionStatusHandler removeObserverWithHandle:self.connectedHandle];
    [chatm.connectionStatusHandler removeObserverWithHandle:self.disconnectedHandle];
    self.connectedHandle = 0;
    self.disconnectedHandle = 0;
}

-(void)sendTextAsChatOpens {
    if (self.textToSendAsChatOpens) {
        [self sendMessage:self.textToSendAsChatOpens attributes:self.attributesToSendAsChatOpens];
        self.textToSendAsChatOpens = nil;
        self.attributesToSendAsChatOpens = nil;
        [self.messageTextField becomeFirstResponder];
    }
}


-(void)viewWillDisappear:(BOOL)animated {
    NSLog(@"VIEW WILL DISAPPEAR... %@", self);
    [super viewWillDisappear:animated];
    [self dismissKeyboard];
    [self removeUnreadBadge];
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }
    if (self.isMovingFromParentViewController) {
        NSLog(@"isMovingFromParentViewController: OK");
        [self resetTitleView];
        self.tabBarController.tabBar.hidden=NO;
        [self removeSubscribers];
        [[ChatManager getInstance].groupsHandler removeSubscriber:self];
        
        //        for (NSString *k in self.imageDownloadsInProgress) {
        //            NSLog(@"Removing downloader: %@", k);
        //            SHPImageDownloader *iconDownloader = [self.imageDownloadsInProgress objectForKey:k];
        //            [iconDownloader cancelDownload];
        //            iconDownloader.delegate = nil;
        //        }
        [self freeKeyboardNotifications];
        containerTVC.vc = nil;
        containerTVC.conversationHandler = nil;
    }
}

// TIP: why this method? http://www.yichizhang.info/2015/03/02/prescroll-a-uitableview.html
-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
//    [containerTVC scrollToLastMessage:NO];
}

//---------------------------------------------------//
//START FUNCTIONS
//---------------------------------------------------//
-(void)setContainer {
    containerTVC = [self.childViewControllers objectAtIndex:0];
    containerTVC.vc = self;
    containerTVC.conversationHandler = self.conversationHandler;
    [containerTVC reloadDataTableView];
    [containerTVC scrollToLastMessage:NO];
}

-(void)setupLabels {
    //[self.sendButton setTitle:[ChatLocal translate:@"ChatSend"] forState:UIControlStateNormal];
    self.messageTextField.placeholder = @"Escribe tu mensaje";//[ChatLocal translate:@"digit message"];
}

//-(void)initImageCache {
//    // cache setup
//    self.imageCache = (ChatImageCache *) [self.applicationContext getVariable:@"chatUserIcons"];
//    if (!self.imageCache) {
//        self.imageCache = [[ChatImageCache alloc] init];
//        self.imageCache.cacheName = @"chatUserIcons";
//        [self.applicationContext setVariable:@"chatUserIcons" withValue:self.imageCache];
//    }
//}

// ************************
// *** ONLINE / OFFLINE ***
// ************************


-(void)setupConnectionStatus {
    // initial status UI
    [self offlineStatus];
    
    ChatManager *chatm = [ChatManager getInstance];
    ChatConnectionStatusHandler *connectionStatusHandler = chatm.connectionStatusHandler;
    if (connectionStatusHandler) {
        [connectionStatusHandler isStatusConnectedWithCompletionBlock:^(BOOL connected, NSError *error) {
            if (connectionStatusHandler) {
                [self connectedStatus];
            }
            else {
                [self offlineStatus];
            }
        }];
    }
}

-(void)connectedStatus {
    self.usernameButton.hidden = NO;
    self.activityIndicator.hidden = YES;
    self.sendButton.enabled = YES;
    [self.activityIndicator stopAnimating];
    [self onlineStatus];
}

-(void)offlineStatus {
    self.usernameButton.hidden = YES;
    self.activityIndicator.hidden = NO;
    self.sendButton.enabled = NO;
    [self.activityIndicator startAnimating];
    [self setSubTitle:[ChatLocal translate:@"ChatDisconnected"]];
}

-(void)onlineStatus {
    if (self.online) {
        [self setSubTitle:[ChatLocal translate:@"online"]];
    } else {
        NSString *last_online_status;
        if (self.lastOnline) {
            NSString *last_seen = [ChatLocal translate:@"last seen"];
            NSString *short_date = [ChatStringUtil timeFromNowToString:self.lastOnline];
            last_online_status = [[NSString alloc] initWithFormat:@"%@ %@",last_seen, short_date];
        } else {
            last_online_status = [ChatLocal translate:@"offline"];
        }
        [self setSubTitle:last_online_status];
    }
}

-(void)setupRecipientOnlineStatus {
    
    ChatManager *chatm = [ChatManager getInstance];
    [chatm.presenceHandler onlineStatusForUser:self.recipient.userId withCallback:^(BOOL status) {
        self.online = status;
        [self onlineStatus];
    }];
    
    [chatm.presenceHandler lastOnlineDateForUser:self.recipient.userId withCallback:^(NSDate *lastOnlineDate) {
        self.lastOnline = lastOnlineDate;
        [self onlineStatus];
    }];
}

// ************************
// *** ONLINE / OFFLINE ***
// ************************
// ********* END **********
// ************************


-(void)buildUnreadBadge {
    self.unreadLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, 4, 16, 16)];
    [self.unreadLabel setBackgroundColor:[UIColor redColor]];
    [self.unreadLabel setTextColor:[UIColor whiteColor]];
    self.unreadLabel.font = [UIFont systemFontOfSize:11];
    self.unreadLabel.textAlignment = NSTextAlignmentCenter;
    self.unreadLabel.layer.masksToBounds = YES;
    self.unreadLabel.layer.cornerRadius = 8.0;
    [self.navigationController.navigationBar addSubview:self.unreadLabel];
    self.unreadLabel.hidden = YES;
}

-(void)updateUnreadMessagesCount {
    if (self.unread_count > 0) {
        self.unreadLabel.hidden = NO;
        self.unreadLabel.text = [[NSString alloc] initWithFormat:@"%d", self.unread_count];
    } else {
        self.unreadLabel.hidden = YES;
    }
}

-(void)removeUnreadBadge {
    NSLog(@"Removing unread label... %@", self.unreadLabel);
    [self.unreadLabel removeFromSuperview];
}

-(void)setTitle:(NSString *)title {
    self.navigationItem.title = title;
    [self.usernameButton setTitle:title forState:UIControlStateNormal];
}

-(void)setSubTitle:(NSString *)subtitle {
    self.statusLabel.text = subtitle;
}

-(void)customizeTitle {
    self.navigationItem.titleView = nil;
    
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"status_title_ios11" owner:self options:nil];
    ChatStatusTitle *view = [subviewArray objectAtIndex:0];
    //    view.frame = CGRectMake(0, 0, 200, 40);
    self.statusLabel = view.statusLabel;
    self.activityIndicator = view.activityIndicator;
    self.usernameButton = view.usernameButton;
    //    [view.usernameButton setTitle:title forState:UIControlStateNormal];
    [view.usernameButton addTarget:self
                            action:@selector(goToProfile:)
                  forControlEvents:UIControlEventTouchUpInside];
    [view.createChatImage setHidden:YES];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(back:)];
    singleTap.numberOfTapsRequired = 1;
    [view.backImage setUserInteractionEnabled:YES];
    [view.backImage addGestureRecognizer:singleTap];
    
    
    UIImage *newImage = [view.backImage.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(view.backImage.image.size, NO, view.backImage.image.scale);
    [[UIColor whiteColor] set];
    [newImage drawInRect:CGRectMake(0, 0, view.backImage.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    view.backImage.image = newImage;
    
    [view.backImage setHidden:NO];
    self.navigationItem.titleView = view;
}
- (IBAction)back:(id)sender {
    //    [self performSegueWithIdentifier:@"SelectUser" sender:self];
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)resetTitleView {
    NSLog(@"RESETTING TITLE VIEW");
    self.usernameButton = nil;
    self.statusLabel = nil;
    self.activityIndicator = nil;
    self.navigationItem.titleView = nil;
    self.titleVC = nil;
}

-(void)chatTitleButtonPressed {
    NSLog(@"title button pressed");
}

-(void)goToProfile:(UIButton*)sender {
    NSLog(@"RECIPIENT FULL NAME: %@", self.recipient.fullname);
    if (self.group) {
        [self performSegueWithIdentifier:@"GroupInfo" sender:self];
    } else {
        if (![ChatUIManager getInstance].pushProfileCallback) {
            NSLog(@"Default profile view not implemented.");
        }
        else {
            ChatUser *user = [[ChatUser alloc] init];
            user.userId = self.recipient.userId;
            user.fullname = self.recipient.fullname;
            [ChatUIManager getInstance].pushProfileCallback(user, self);
        }
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    return NO;
}

-(void)initConversationHandler {
    ChatManager *chatm = [ChatManager getInstance];
    ChatConversationHandler *handler;
    if (self.recipient) {
        handler = [chatm getConversationHandlerForRecipient:self.recipient];
    } else {
        NSLog(@"*** CONVERSATION HANDLER IN GROUP MOD!!!!!!!");
        handler = [chatm getConversationHandlerForGroup:self.group];
        [self monitorGroupUpdates];
    }
    [handler connect];
    [self subscribeForMessages:handler];
    self.conversationHandler = handler;
}

-(void)configureIfImGroupMember {
    if (self.group) {
        if ([self.group isMember:self.me.userId]) {
            [self subscribeForMessages:self.conversationHandler];
            [self.conversationHandler connect];
        }
        else {
            [self.conversationHandler dispose];
        }
    }
}

//---------------------------------------------------//
// KEYBOARD HANDLING
//---------------------------------------------------//
-(void)backgroundTapToDismissKB:(BOOL)activate
{
    if (activate) {
        if (!self.tapToDismissKB) {
            self.tapToDismissKB = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
            self.tapToDismissKB.cancelsTouchesInView = YES;// without this, tap on buttons is captured by the view
        }
        [self.view addGestureRecognizer:self.tapToDismissKB];
    } else if (self.tapToDismissKB) {
        [self.view removeGestureRecognizer:self.tapToDismissKB];
    }
}

- (IBAction)addContentAction:(id)sender {
    //    UIAlertController * view=   [UIAlertController
    //                                 alertControllerWithTitle:nil
    //                                 message:@"Allega"
    //                                 preferredStyle:UIAlertControllerStyleActionSheet];
    //
    //    UIAlertAction* documenti = [UIAlertAction
    //                           actionWithTitle:@"Documenti"
    //                           style:UIAlertActionStyleDefault
    //                           handler:^(UIAlertAction * action)
    //                           {
    //                               NSLog(@"Documenti");
    //                               UIStoryboard *sb = [UIStoryboard storyboardWithName:@"DocNavigator" bundle:nil];
    //                               UINavigationController *nc = [sb instantiateViewControllerWithIdentifier:@"NavigatorController"];
    //                               DocNavigatorTVC *navigatorVC = (DocNavigatorTVC *)[[nc viewControllers] objectAtIndex:0];
    //                               navigatorVC.selectionMode = YES;
    //                               navigatorVC.selectionDelegate = self;
    //                               [self.navigationController presentViewController:nc animated:YES completion:nil];
    //                           }];
    ////    UIAlertAction* dropbox = [UIAlertAction
    ////                           actionWithTitle:@"Dropbox"
    ////                           style:UIAlertActionStyleDefault
    ////                           handler:^(UIAlertAction * action)
    ////                           {
    ////                               NSLog(@"Open dropbox");
    ////                               [self openDropbox];
    ////                           }];
    //    UIAlertAction* cancel = [UIAlertAction
    //                             actionWithTitle:NSLocalizedString(@"CancelLKey", nil)
    //                             style:UIAlertActionStyleCancel
    //                             handler:^(UIAlertAction * action)
    //                             {
    //                                 NSLog(@"cancel");
    //                             }];
    //    [view addAction:documenti];
    ////    [view addAction:dropbox];
    //    [view addAction:cancel];
    //    [self presentViewController:view animated:YES completion:nil];
}

-(void)dismissKeyboardFromTableView:(BOOL)activated {
    //    NSLog(@"DISMISSING");
    [self backgroundTapToDismissKB:activated];
}

-(void)dismissKeyboard {
    //    NSLog(@"dismissing keyboard");
    [self.view endEditing:YES];
}

-(void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}


-(void) freeKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


-(void)keyboardWasShown:(NSNotification*)aNotification
{
    NSLog(@"Keyboard was shown %ld",(long)self.messageTextField.autocorrectionType);
    if(keyboardShow == NO){
        NSLog(@"KEYBOARD-SHOW == NO!");
        //CGFloat content_h = self.tableView.contentSize.height;
        NSDictionary* info = [aNotification userInfo];
        NSTimeInterval animationDuration;
        UIViewAnimationCurve animationCurve;
        CGRect keyboardFrame;
        [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:animationDuration animations:^{
            self.layoutContraintBottomBarMessageBottomView.constant = keyboardFrame.size.height;
            [self.view layoutIfNeeded];
            [containerTVC scrollToLastMessage:YES];
        }];
        
        keyboardShow = YES;
    }
    else {
        NSLog(@"Suggestion hide/show");
        NSLog(@"KEYBOARD-SHOW == YES!");
        //START apertura e chiusura suggerimenti keyboard
        NSDictionary* info = [aNotification userInfo];
        CGRect keyboardFrame;
        [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
        CGFloat beginHeightKeyboard = keyboardFrame.size.height;
        NSLog(@"Keyboard info1 %f",beginHeightKeyboard);
        [[info objectForKey:UIKeyboardFrameEndUserInfoKey] getValue:&keyboardFrame];
        CGFloat endHeightKeyboard = keyboardFrame.size.height;
        NSLog(@"Keyboard info2 %f",endHeightKeyboard);
        CGFloat difference = beginHeightKeyboard-endHeightKeyboard;
        
        NSLog(@"Difference: %f", difference);
        NSTimeInterval animationDuration;
        [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
        //        CGFloat viewport_h_with_kb = self.view.frame.size.height + difference;
        //        CGFloat viewport_final_h = viewport_h_with_kb;
        
        [self.view layoutIfNeeded];
        [UIView animateWithDuration:animationDuration animations:^{
            self.layoutContraintBottomBarMessageBottomView.constant = keyboardFrame.size.height;
            [self.view layoutIfNeeded];
            [containerTVC scrollToLastMessage:YES];
        }];
    }
}

-(void) keyboardWillHide:(NSNotification*)aNotification
{
    NSLog(@"KEYBOARD HIDING...");
    NSDictionary* info = [aNotification userInfo];
    NSTimeInterval animationDuration;
    UIViewAnimationCurve animationCurve;
    CGRect keyboardFrame;
    [[info objectForKey:UIKeyboardAnimationCurveUserInfoKey] getValue:&animationCurve];
    [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] getValue:&animationDuration];
    [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] getValue:&keyboardFrame];
    
    //START ANIMATION VIEW
    [self.view layoutIfNeeded];
    [UIView animateWithDuration:animationDuration animations:^{
        self.layoutContraintBottomBarMessageBottomView.constant = 0;
        [self.view layoutIfNeeded];
    }];
    keyboardShow = NO;
    //END ANIMATION VIEW
}
//---------------------------------------------------//
// END KEYBOARD HANDLING
//---------------------------------------------------//

-(NSString*)formatDateMessage:(int)numberDaysBetweenChats message:(ChatMessage*)message row:(CGFloat)row {
    NSString *dateChat;
    if(numberDaysBetweenChats>0 || row==0){
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDate *today;
        today = [NSDate date];
        int days = (int)[ChatStringUtil daysBetweenDate:message.date andDate:today];
        if(days==0){
            dateChat = [ChatLocal translate:@"today"];
        }
        else if(days==1){
            dateChat = [ChatLocal translate:@"yesterday"];
        }
        else if(days<8){
            [dateFormatter setDateFormat:@"EEEE"];
            dateChat = [dateFormatter stringFromDate:message.date];
        }
        else{
            [dateFormatter setDateFormat:@"dd MMM"];
            dateChat = [dateFormatter stringFromDate:message.date];
        }
    }
    return dateChat;
}

- (IBAction)sendAction:(id)sender {
    NSLog(@"sendAction()");
    NSString *text = self.messageTextField.text;
    [self sendMessage:text];
}

-(void)sendMessage:(NSString *)text {
    [self sendMessage:text attributes:nil];
}

-(void)sendMessage:(NSString *)text attributes:(NSDictionary *)attributes {
    
    // check: if in a group, are you still a member?
    if (self.group) {
        if (![self.group isMember:self.me.userId]) {
            [self hideBottomView:YES];
            [self.messageTextField resignFirstResponder];
            return;
        }
    }
    
    NSString *trimmed_text = [text stringByTrimmingCharactersInSet:
                              [NSCharacterSet whitespaceCharacterSet]];
    if(trimmed_text.length > 0) {
        [self.conversationHandler sendTextMessage:text attributes:attributes completion:^(ChatMessage *message, NSError *error) {
            NSLog(@"Message %@ successfully sent. ID: %@", message.text, message.messageId);
        }];
        self.messageTextField.text = @"";
    }
}

//-(void)sendDropboxMessage:(NSString *)name link:(NSString *)link size:(NSNumber *)size iconURL:(NSString *)iconURL thumbs:(NSDictionary *)thumbs {
//
//    // check: if in a group, are you still a member?
//    if (self.group) {
//        if ([self.group isMember:self.me.userId]) {
//        } else {
//            [self hideBottomView:YES];
//            [self.messageTextField resignFirstResponder];
//            return;
//        }
//    }
//
//    NSMutableDictionary *attributes = [[NSMutableDictionary alloc] init];
//    NSLog(@"dropbox.link: %@", link);
//    NSLog(@"dropbox.size: %@", size);
//    NSLog(@"dropbox.iconurl: %@", iconURL);
//
//    [attributes setValue:link forKey:@"link"];
//    [attributes setValue:size forKey:@"size"];
//    [attributes setValue:iconURL forKey:@"iconURL"];
//    if (thumbs) {
//        NSArray*keys=[thumbs allKeys];
//        for (NSString *k in keys) {
//            NSURL *turl = (NSURL *)thumbs[k];
//            [attributes setValue:[turl absoluteString] forKey:k];
//        }
//    }
//    NSString *text = [NSString stringWithFormat:@"%@ %@", name, link];
//    [self.conversationHandler sendTextMessage:text attributes:attributes completion:^(ChatMessage *message, NSError *error) {
//        NSLog(@"Dropbox message %@ successfully sent. ID: %@", message.text, message.messageId);
//    }];
//}

-(void)messageUpdated:(ChatMessage *)message {
    [containerTVC reloadDataTableView];
}

-(void)messageDeleted:(ChatMessage *)message {
    [containerTVC reloadDataTableView];
}

-(void)messageReceived:(ChatMessage *)message {
    if (!self.messagesArriving) { // self.messagesArriving = YES => bulk messages update
        [self startNewMessageTimer];
        self.messagesArriving = YES;
        // fist message always shown
        [self renderMessages];
        [self playSound];
    }
    else {
        NSLog(@"MESSAGES STILL ARRIVING, NOT RENDERING!");
    }
}

static float messageTime = 0.5;

-(void)startNewMessageTimer {
    if (self.messageTimer != nil) {
        [self.messageTimer invalidate];
        self.messageTimer = nil;
    }
    self.messageTimer = [NSTimer scheduledTimerWithTimeInterval:messageTime target:self selector:@selector(endNewMessageTimer) userInfo:nil repeats:NO];
}

-(void)endNewMessageTimer {
    NSLog(@"END RECEIVING MESSAGES. RENDERING.");
    [self.messageTimer invalidate];
    self.messageTimer = nil;
    self.messagesArriving = NO;
    [self renderMessages];
}

-(void)renderMessages {
    dispatch_async(dispatch_get_main_queue(), ^{
        [containerTVC reloadDataTableViewOnIndex:self.conversationHandler.messages.count - 1];
        [containerTVC scrollToLastMessage:NO];
//        [self scrollTo];
    });
}

//-(void)scrollTo {
//    [containerTVC scrollToLastMessage:NO];
//}

-(void)groupConfigurationChanged:(ChatGroup *)group {
    NSLog(@"Notified to view that %@ changed. Checking possible view changes.", group.name);
    dispatch_async(dispatch_get_main_queue(), ^{
        self.group = group;
        [self configureIfImGroupMember];
        [self writeBoxEnabled];
        [self setTitle:self.group.name];
        [self.group completeGroupMembersMetadataWithCompletionBlock:^() {
            [self setSubTitle:[ChatUtil groupMembersFullnamesAsStringForUI:self.group.membersFull]];
        }];
    });
}

-(void)playSound {
//    double now = [[NSDate alloc] init].timeIntervalSince1970;
//    if (now - self.lastPlayedSoundTime < 3) {
//        NSLog(@"TOO EARLY TO PLAY ANOTHER SOUND");
//        return;
//    }
    // help: https://github.com/TUNER88/iOSSystemSoundsLibrary
    // help: http://developer.boxcar.io/blog/2014-10-08-notification_sounds/
    NSString *path = [NSString stringWithFormat:@"%@/inline.caf", [[NSBundle mainBundle] resourcePath]];
    NSURL *fileURL = [NSURL fileURLWithPath:path];
    AudioServicesCreateSystemSoundID((__bridge_retained CFURLRef)fileURL,&soundID);
    AudioServicesPlaySystemSound(soundID);
    //    [self startSoundTimer];
    
//    double now = [[NSDate alloc] init].timeIntervalSince1970;
//    self.lastMessageArrivedTime = now;
}

-(void)dealloc {
    NSLog(@"Deallocating MessagesViewController.");
}

//EXTRA
-(void)customRoundImage:(UIView *)customImageView
{
    customImageView.layer.cornerRadius = 15;
    customImageView.layer.masksToBounds = NO;
    customImageView.layer.borderWidth = 0;
    customImageView.layer.borderColor = [UIColor grayColor].CGColor;
}

-(void)customcornerRadius:(UIView *)customImageView cornerRadius:(CGFloat)cornerRadius
{
    customImageView.layer.cornerRadius = cornerRadius;
    customImageView.layer.masksToBounds = NO;
    customImageView.layer.borderWidth = 0;
}

- (IBAction)menuAction:(id)sender {
    //[self.menuSheet showInView:self.parentViewController.tabBarController.view];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    //    if (actionSheet == self.menuSheet) {
    //        NSString *option = [actionSheet buttonTitleAtIndex:buttonIndex];
    //
    //        if ([option isEqualToString:@"Info gruppo"]) {
    //            [self performSegueWithIdentifier:@"GroupInfo" sender:self];
    //        }
    //        else if ([option isEqualToString:@"Invia immagine"]) {
    //            NSLog(@"invia immagine");
    //            [self.photoMenuSheet showInView:self.parentViewController.tabBarController.view];
    //        }
    //    } else {
    //        switch (buttonIndex) {
    //            case 0:
    //            {
    //                [self takePhoto];
    //                break;
    //            }
    //            case 1:
    //            {
    //                [self chooseExisting];
    //                break;
    //            }
    //        }
    //    }
}

// ChatGroupsSubscriber protocol

-(void)groupAddedOrChanged:(ChatGroup *)group {
    NSLog(@"Group added or changed delegate. Group name: %@", group.name);
    if (![group.groupId isEqualToString:self.group.groupId]) {
        return;
    }
    [self groupConfigurationChanged:group];
//    if ([group isMember:self.me.userId]) {
//        [self.conversationHandler connect];
//        [self groupConfigurationChanged:group];
//    }
//    else {
//        [self.conversationHandler dispose];
//        [self groupConfigurationChanged:group];
//    }
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"GroupInfo"]) {
        ChatGroupInfoVC *vc = (ChatGroupInfoVC *)[segue destinationViewController];
        NSLog(@"vc %@", vc);
        //        vc.applicationContext = self.applicationContext;
        vc.group = self.group;
    }
}

// **************************************************
// **************** TAKE PHOTO SECTION **************
// **************************************************

- (void)takePhoto {
    //    NSLog(@"taking photo with user %@...", self.applicationContext.loggedUser);
    if (self.imagePickerController == nil) {
        [self initializeCamera];
    }
    [self presentViewController:self.imagePickerController animated:YES completion:^{NSLog(@"FINITO!");}];
}

- (void)chooseExisting {
    NSLog(@"choose existing...");
    if (self.photoLibraryController == nil) {
        [self initializePhotoLibrary];
    }
    [self presentViewController:self.photoLibraryController animated:YES completion:nil];
}

-(void)initializeCamera {
    NSLog(@"cinitializeCamera...");
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.delegate = self;
    self.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    // enable to crop
    self.imagePickerController.allowsEditing = YES;
}

-(void)initializePhotoLibrary {
    NSLog(@"initializePhotoLibrary...");
    self.photoLibraryController = [[UIImagePickerController alloc] init];
    self.photoLibraryController.delegate = self;
    self.photoLibraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;// SavedPhotosAlbum;// SavedPhotosAlbum;
    self.photoLibraryController.allowsEditing = YES;
    //self.photoLibraryController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self afterPickerCompletion:picker withInfo:info];
}

-(void)afterPickerCompletion:(UIImagePickerController *)picker withInfo:(NSDictionary *)info {
    //    self.bigImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    NSLog(@"BIG IMAGE: %@", self.bigImage);
    //    // enable to crop
    //    // self.scaledImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    //    NSLog(@"edited image w:%f h:%f", self.bigImage.size.width, self.bigImage.size.height);
    //    if (!self.bigImage) {
    //        self.bigImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    //        NSLog(@"original image w:%f h:%f", self.bigImage.size.width, self.bigImage.size.height);
    //    }
    //    // end
    //
    //    self.scaledImage = [SHPImageUtil scaleImage:self.bigImage toSize:CGSizeMake(self.applicationContext.settings.uploadImageSize, self.applicationContext.settings.uploadImageSize)];
    //    NSLog(@"SCALED IMAGE w:%f h:%f", self.scaledImage.size.width, self.scaledImage.size.height);
    //
    //    if (picker == self.imagePickerController) {
    //        UIImageWriteToSavedPhotosAlbum(self.bigImage, self,
    //                                       @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //    }
    //
    //    NSLog(@"image: %@", self.scaledImage);
    
    
    //    UIImage *imageEXIFAdjusted = [SHPImageUtil adjustEXIF:self.scaledImage];
    //    NSData *imageData = UIImageJPEGRepresentation(imageEXIFAdjusted, 90);
    
    //    PFFile *imageFile = [PFFile fileWithName:@"image.png" data:imageData];
    //    NSLog(@"imageFile: %@", imageFile);
    //
    //    PFObject *userPhoto = [PFObject objectWithClassName:@"Image"];
    //    NSLog(@"userPhoto: %@", userPhoto);
    //    userPhoto[@"file"] = imageFile;
    //    [userPhoto saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
    //        if (succeeded) {
    //            NSLog(@"Image saved.");
    //            PFFile *imageFile = userPhoto[@"file"];
    //            [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
    //                if (!error) {
    //                    NSLog(@"Downloading image...");
    //                    UIImage *image = [UIImage imageWithData:imageData];
    //                    UIImageWriteToSavedPhotosAlbum(image, self,
    //                                                   @selector(image:didFinishSavingWithError:contextInfo:), nil);
    //                }
    //            }];
    //        }
    //    }];
    //    NSLog(@"userPhoto: %@", userPhoto);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error != NULL) {
        NSLog(@"(SHPTakePhotoViewController) Error saving image to camera roll.");
    }
    else {
        //NSLog(@"(SHPTakePhotoViewController) Image saved to camera roll. w:%f h:%f", self.image.size.width, self.image.size.height);
    }
}

// **************************************************
// *************** END PHOTO SECTION ****************
// **************************************************

- (void)cancelAction {
    NSLog(@"Dismissing Messages view.");
    [self dismissViewControllerAnimated:YES completion:^{
        if (self.dismissModalCallback) {
            self.dismissModalCallback();
        }
    }];
}

@end

