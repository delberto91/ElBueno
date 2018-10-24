//
//  ChatUIManager.m
//  chat21
//
//  Created by Andrea Sponziello on 06/12/2017.
//  Copyright © 2017 Frontiere21. All rights reserved.
//

#import "ChatUIManager.h"
#import "ChatConversationsVC.h"
#import "ChatMessagesVC.h"
#import "ChatManager.h"
#import "NotificationAlertView.h"
#import "ChatSelectUserLocalVC.h"
#import "ChatCreateGroupVC.h"
#import "ChatGroup.h"
#import "ChatSelectGroupLocalTVC.h"
#import "ChatContactsDB.h"

static ChatUIManager *sharedInstance = nil;
static NotificationAlertView *notificationAlertInstance = nil;

@implementation ChatUIManager

+(ChatUIManager *)getInstance {
    if (!sharedInstance) {
        sharedInstance = [[ChatUIManager alloc] init];
        NSDictionary *dictionary = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Chat-Info" ofType:@"plist"]];
        sharedInstance.tabBarIndex = [[dictionary objectForKey:@"conversations-tabbar-index"] integerValue];
    }
    return sharedInstance;
}

-(void)openConversationsViewAsModal:(UIViewController *)vc withCompletionBlock:(void (^)())completionBlock {
    UINavigationController * nc = [self getConversationsViewController];
    ChatConversationsVC *conversationsVc = (ChatConversationsVC *)[[nc viewControllers] objectAtIndex:0];
    conversationsVc.isModal = YES;
    conversationsVc.dismissModalCallback = completionBlock;
    [vc presentViewController:nc animated:YES completion:^{
        //
    }];
}

-(void)openConversationMessagesViewAsModalWith:(ChatUser *)recipient viewController:(UIViewController *)vc withCompletionBlock:(void (^)())completionBlock {
    UINavigationController * nc = [self getMessagesViewController];
    ChatMessagesVC *messagesVc = (ChatMessagesVC *)[[nc viewControllers] objectAtIndex:0];
    messagesVc.recipient = recipient;
    messagesVc.isModal = YES;
    messagesVc.dismissModalCallback = completionBlock;
    [vc presentViewController:nc animated:YES completion:^{
        // NO CALLBACK AFTER PRESENT ACTION COMPLETION
    }];
}

-(void)openSelectContactViewAsModal:(UIViewController *)vc withCompletionBlock:(void (^)(ChatUser *contact, BOOL canceled))completionBlock {
    UINavigationController * nc = [self getSelectContactViewController];
    ChatSelectUserLocalVC *selectContactVC = (ChatSelectUserLocalVC *)[[nc viewControllers] objectAtIndex:0];
//    selectContactVC.isModal = YES;
    selectContactVC.completionCallback = completionBlock;
    [vc presentViewController:nc animated:YES completion:^{
        // NO CALLBACK AFTER PRESENT ACTION COMPLETION
    }];
}

-(void)openCreateGroupViewAsModal:(UIViewController *)vc withCompletionBlock:(void (^)(ChatGroup *group, BOOL canceled))completionBlock {
    UINavigationController * nc = [self getCreateGroupViewController];
    ChatCreateGroupVC *VC = (ChatCreateGroupVC *)[[nc viewControllers] objectAtIndex:0];
    VC.completionCallback = completionBlock;
    [vc presentViewController:nc animated:YES completion:^{
        // NO CALLBACK AFTER PRESENT ACTION COMPLETION
    }];
}

-(void)openSelectGroupViewAsModal:(UIViewController *)vc withCompletionBlock:(void (^)(ChatGroup *group, BOOL canceled))completionBlock {
    UINavigationController * nc = [self getSelectGroupViewController];
    ChatSelectGroupLocalTVC *VC = (ChatSelectGroupLocalTVC *)[[nc viewControllers] objectAtIndex:0];
    VC.completionCallback = completionBlock;
    [vc presentViewController:nc animated:YES completion:^{
        // NO CALLBACK AFTER PRESENT ACTION COMPLETION
    }];
}

-(UINavigationController *)getConversationsViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *chatNC = [sb instantiateViewControllerWithIdentifier:@"ChatNavigationController"];
    NSLog(@"conversationsViewController instance %@", chatNC);
    return chatNC;
}

-(UINavigationController *)getMessagesViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *chatNC = [sb instantiateViewControllerWithIdentifier:@"MessagesNavigationController"];
    return chatNC;
}



-(UINavigationController *)getSelectContactViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *NC = [sb instantiateViewControllerWithIdentifier:@"SelectContactNavController"];
    return NC;
}

-(UINavigationController *)getCreateGroupViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *NC = [sb instantiateViewControllerWithIdentifier:@"CreateGroupNavController"];
    return NC;
}

-(UINavigationController *)getSelectGroupViewController {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Chat" bundle:nil];
    UINavigationController *NC = [sb instantiateViewControllerWithIdentifier:@"SelectGroupNavController"];
    return NC;
}

// only for tabbed applications
+(void)moveToConversationViewWithUser:(ChatUser *)user {
    [ChatUIManager moveToConversationViewWithUser:user orGroup:nil sendMessage:nil attributes:nil];
}

// only for tabbed applications
+(void)moveToConversationViewWithUser:(ChatUser *)user sendMessage:(NSString *)message {
    [ChatUIManager moveToConversationViewWithUser:user orGroup:nil sendMessage:message attributes:nil];
}

// only for tabbed applications
+(void)moveToConversationViewWithGroup:(ChatGroup *)group {
    [ChatUIManager moveToConversationViewWithUser:nil orGroup:group sendMessage:nil attributes:nil];
}

// only for tabbed applications
+(void)moveToConversationViewWithGroup:(ChatGroup *)group sendMessage:(NSString *)message {
    [ChatUIManager moveToConversationViewWithUser:nil orGroup:group sendMessage:message attributes:nil];
}

// only for tabbed applications
+(void)moveToConversationViewWithUser:(ChatUser *)user orGroup:(ChatGroup *)group sendMessage:(NSString *)message attributes:(NSDictionary *)attributes {
    NSInteger chat_tab_index = [ChatUIManager getInstance].tabBarIndex;
    NSLog(@"processRemoteNotification: messages_tab_index %ld", (long)chat_tab_index);
    // move to the converstations tab
    if (chat_tab_index >= 0) {
        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UITabBarController *tabController = (UITabBarController *)window.rootViewController;
        NSArray *controllers = [tabController viewControllers];
        UIViewController *currentVc = [controllers objectAtIndex:tabController.selectedIndex];
        [currentVc dismissViewControllerAnimated:NO completion:nil];
        UINavigationController *conversationsNC = [controllers objectAtIndex:chat_tab_index];
        ChatConversationsVC *conversationsVC = conversationsNC.viewControllers[0];
        NSLog(@"openConversationWithRecipient:%@ orGroup: %@ sendText:%@", user.userId, group.groupId, message);
        tabController.selectedIndex = chat_tab_index;
        [conversationsVC openConversationWithUser:user orGroup:group sendMessage:message attributes:attributes];
    } else {
        NSLog(@"No Chat Tab configured");
    }
}

+(NotificationAlertView*)getNotificationAlertInstance {
    if (!notificationAlertInstance) {
        NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"notification_view" owner:self options:nil];
        NotificationAlertView *view = [subviewArray objectAtIndex:0];
        [view initViewWithHeight:60];
        notificationAlertInstance = view;
    }
    return notificationAlertInstance;
}

+(void)showNotificationWithMessage:(NSString *)message image:(NSString *)image sender:(NSString *)sender senderFullname:(NSString *)senderFullname {
    NotificationAlertView *alert = [ChatUIManager getNotificationAlertInstance];
    NSString *imageURL = @""; //[SHPUser photoUrlByUsername:conversation.conversWith];
    ChatContactsDB *db = [ChatContactsDB getSharedInstance];
    [db searchContactsByUIDSynchronized:image completion:^(NSArray<ChatUser *> *users) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([users count] > 0){
                
                NSString *strImgURLAsString = users[0].imageurl;
                [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (!connectionError) {
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        // pass the img to your imageview
                        alert.userImage.layer.cornerRadius = alert.userImage.frame.size.height /2;
                        alert.userImage.layer.masksToBounds = YES;
                        alert.userImage.layer.borderWidth = 0;
                        [alert.userImage setImage:img];
                        alert.messageLabel.text = message;
                        alert.senderLabel.text = senderFullname ? senderFullname : sender;
                        //alert.userImage.image = image;
                        alert.sender = sender;
                        [alert animateShow];
                    }else{
                        NSLog(@"%@",connectionError);
                    }
                }];
            }
        });
    }];
    
    
}

@end
