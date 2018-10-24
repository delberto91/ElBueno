//
//  MyComunityDescriptionVC.m
//  Sports World
//
//  Created by Glauco Valdes on 10/21/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

#import "MyComunityDescriptionVC.h"
#import "ChatMessagesVC.h"
#import "ChatGroupMembersVC.h"
#import "ChatManager.h"
#import "ChatGroup.h"
#import "ChatUtil.h"
#import "ChatImageCache.h"
#import "ChatImageWrapper.h"
#import "ChatUser.h"
#import "ChatSelectUserLocalVC.h"
#import "ChatUser.h"
#import "ChatUIManager.h"
#import "ChatLocal.h"

@interface MyComunityDescriptionVC ()

@end

@implementation MyComunityDescriptionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [[self userCountLabel] setText:[self userCountText]];
    [[self nameLabel] setText:[self nameText]];
    [[self textViewDescription] setText:[self descriptionText]];
    
    [self.suscribeButton layer].cornerRadius = 8.0f;
    [self.suscribeButton layer].cornerRadius = 8.0f;
    [self.suscribeButton setBackgroundColor:[UIColor redColor]];
    [self.suscribeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    if(self.typeView == 1){
        [self.suscribeButton setHidden:YES];
    }else{
        [self.chatButton setHidden:YES];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[self navigationController] setNavigationBarHidden:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[self navigationController] setNavigationBarHidden:NO];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)goToAviso:(id)sender {
}
- (IBAction)goBack:(id)sender {
    [[self navigationController] popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([[segue identifier] isEqualToString:@"CHAT_SEGUE"]) {
        NSLog(@"Preparing chat_segue...");
        ChatMessagesVC *vc = (ChatMessagesVC *)[segue destinationViewController];
        
        NSLog(@"vc %@", vc);
        // conversationsHandler will update status of new conversations (they come with is_new = true) with is_new = false (because the conversation is open and so new messages are all read)
        /*self.conversationsHandler.currentOpenConversationId = self.selectedConversationId;
        NSLog(@"self.selectedConversationId = %@", self.selectedConversationId);
        NSLog(@"self.conversationsHandler.currentOpenConversationId = %@", self.selectedConversationId);
        NSLog(@"self.selectedRecipient: %@", self.selectedRecipientId);
        if (self.selectedRecipientId) {
            ChatUser *recipient = [[ChatUser alloc] init:self.selectedRecipientId fullname:self.selectedRecipientFullname];
            vc.recipient = recipient;
        }
        else {
            vc.recipient = nil;
        }*/
        if (self.selectedGroupId) {
            vc.group = [[ChatManager getInstance] groupById:self.selectedGroupId];
            
        }
        
        
        
        
    }
}
- (IBAction)suscribe:(id)sender {
    NSString *user_id = [ChatManager getInstance].loggedUser.userId;
    ChatGroup *group = [[ChatManager getInstance] groupById:self.selectedGroupId];
    [[ChatManager getInstance] addMember:user_id toGroup:group withCompletionBlock:^(NSError *error) {
        if (error) {
            NSLog(@"Member %@ not added. Error %@",user_id, error);
        } else {
            NSLog(@"Member %@ successfully added.", user_id);
            [group.members setObject:user_id forKey:user_id];
            [group completeGroupMembersMetadataWithCompletionBlock:^() {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSegueWithIdentifier:@"CHAT_SEGUE" sender:self];
                });
            }];
        }
    }];


}


@end
