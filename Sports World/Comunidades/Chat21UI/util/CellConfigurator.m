//
//  CellConfigurator.m
//  Chat21
//
//  Created by Andrea Sponziello on 28/03/16.
//  Copyright © 2016 Frontiere21. All rights reserved.
//

#import "CellConfigurator.h"
#import "ChatConversation.h"
#import "ChatImageCache.h"
#import "ChatConversationsVC.h"
#import "ChatImageWrapper.h"
#import "ChatManager.h"
#import "ChatGroupsHandler.h"
#import "ChatGroup.h"
#import "ChatUtil.h"
#import "ChatContactsDB.h"

@implementation CellConfigurator

+(UITableViewCell *)configureConversationCell:(ChatConversation *)conversation tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath conversationsVC:(ChatConversationsVC *)vc {
    //    NSLog(@"CNF CELL groupname: %@, groupId: %@, text: %@", conversation.groupName, conversation.groupId, conversation.last_message_text);
    UITableViewCell *cell;
    if (!conversation.isDirect) {
        cell = [CellConfigurator configureGroupConversationCell:conversation tableView:tableView indexPath:indexPath conversationsVC:vc];
    } else {
        cell = [CellConfigurator configureDirectConversationCell:conversation tableView:tableView indexPath:indexPath conversationsVC:vc];
    }
    return cell;
}

+(UITableViewCell *)configureGroupConversationCell:(ChatConversation *)conversation tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath conversationsVC:(ChatConversationsVC *)vc {
    
    //    NSLog(@"Configuring group cell.");
    
    ChatGroup *group = [[ChatManager getInstance] groupById:conversation.recipient];
    
    NSString *me = [ChatManager getInstance].loggedUser.userId;
    static NSString *conversationCellName = @"conversationGroupCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conversationCellName forIndexPath:indexPath];
    //UILabel *subject_label = (UILabel *)[cell viewWithTag:2];
    //UILabel *message_label = (UILabel *)[cell viewWithTag:3];
    //UILabel *group_message_label = (UILabel *)[cell viewWithTag:22];
    //UILabel *sender_label = (UILabel *)[cell viewWithTag:20];
    
    //UILabel *date_label = (UILabel *)[cell viewWithTag:4];
    
    
    UILabel *comunity_label = (UILabel *)[cell viewWithTag:101];
    UILabel *count_label = (UILabel *)[cell viewWithTag:102];
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:104];
    UIView *back_view = (UIView *)[cell viewWithTag:105];
    UIButton *button = (UIButton *)[cell viewWithTag:106];
    [[back_view layer] setCornerRadius:10.0];
    // SUBJECT LABEL
    
    button.tag = indexPath.row;
    [button addTarget:vc action:@selector(openChat:) forControlEvents:UIControlEventTouchUpInside];
    NSString *groupName = conversation.recipientFullname;
    comunity_label.text = groupName;
    count_label.text = [NSString stringWithFormat:@"%lu Integrantes",(unsigned long)group.members.count];
    
    NSString *strImgURLAsString = group.image;
    [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            // pass the img to your imageview
            image_view.layer.cornerRadius = image_view.frame.size.height /2;
            image_view.layer.masksToBounds = YES;
            image_view.layer.borderWidth = 0;
            [image_view setImage:img];
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
    
    /*if (conversation.status == CONV_STATUS_FAILED) {
        //message_label.hidden = NO;
        sender_label.hidden = YES;
        //group_message_label.hidden = YES;
        message_label.text = [[NSString alloc] initWithFormat:@"Errore nella creazione del gruppo. Tocca per riprovare"];
    }
    else if (conversation.status == CONV_STATUS_JUST_CREATED) {
        //message_label.hidden = NO;
        sender_label.hidden = YES;
        //group_message_label.hidden = YES;
        message_label.text = conversation.last_message_text;
    }
    else if (conversation.status == CONV_STATUS_LAST_MESSAGE) {
        //message_label.hidden = YES;
        sender_label.hidden = NO;
        //group_message_label.hidden = NO;
        message_label.text = [conversation textForLastMessage:me];
        NSString *sender_display_text = [CellConfigurator displayUserOfGroupConversation:conversation];
        sender_label.text = sender_display_text;
    }
    
    message_label.hidden = NO;
    // CONVERSATION IMAGE
    //    UIImageView *image_view = (UIImageView *)[cell viewWithTag:1];
    //    image_view.image = [UIImage imageNamed:@"group-conversation-avatar"];
    
    // CONVERSATION IMAGE
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:1];
    NSString *imageURL = group.iconUrl;
    ChatImageWrapper *cached_image_wrap = (ChatImageWrapper *)[vc.imageCache getImage:imageURL];
    UIImage *image = cached_image_wrap.image;
    if(!cached_image_wrap) { // image == nil if image saving gone wrong!
        //        [vc startIconDownload:imageURL forIndexPath:indexPath];
        // if a download is deferred or in progress, return a placeholder image
        UIImage *circled = [ChatUtil circleImage:[UIImage imageNamed:@"group-conversation-avatar"]];
        image_view.image = circled;
    } else {
        image_view.image = [ChatUtil circleImage:image];
        // update too old images
        double now = [[NSDate alloc] init].timeIntervalSince1970;
        double reload_timer_secs = 3600; // one hour
        if (now - cached_image_wrap.createdTime.timeIntervalSince1970 > reload_timer_secs) {
            //            [vc startIconDownload:imageURL forIndexPath:indexPath];
        } else {
            //
        }
    }
    
    date_label.text = [conversation dateFormattedForListView];
    
    if (conversation.is_new) {
        // BOLD STYLE
        subject_label.font = [UIFont boldSystemFontOfSize:subject_label.font.pointSize];
        // CONV_STATUS_JUST_CREATED
        message_label.textColor = [UIColor blackColor];
        message_label.font = [UIFont boldSystemFontOfSize:message_label.font.pointSize];
        // CONV_STATUS_LAST_MESSAGE
        message_label.textColor = [UIColor blackColor];
        message_label.font = [UIFont boldSystemFontOfSize:message_label.font.pointSize];
    }
    else {
        // NORMAL STYLE
        subject_label.font = [UIFont systemFontOfSize:subject_label.font.pointSize];
        // CONV_STATUS_JUST_CREATED
        message_label.textColor = [UIColor lightGrayColor];
        message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
        // CONV_STATUS_LAST_MESSAGE
        message_label.textColor = [UIColor lightGrayColor];
        message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
    }*/
    return cell;
}

+(UITableViewCell *)configureGroupConversationCellByGroup:(ChatGroup *)group tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath conversationsVC:(ChatConversationsVC *)vc {
    
    //    NSLog(@"Configuring group cell.");
    
    
    
    NSString *me = [ChatManager getInstance].loggedUser.userId;
    static NSString *conversationCellName = @"conversationGroupCellAll";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conversationCellName forIndexPath:indexPath];
    //UILabel *subject_label = (UILabel *)[cell viewWithTag:2];
    //UILabel *message_label = (UILabel *)[cell viewWithTag:3];
    //UILabel *group_message_label = (UILabel *)[cell viewWithTag:22];
    //UILabel *sender_label = (UILabel *)[cell viewWithTag:20];
    
    //UILabel *date_label = (UILabel *)[cell viewWithTag:4];
    
    
    UILabel *comunity_label = (UILabel *)[cell viewWithTag:101];
    UILabel *count_label = (UILabel *)[cell viewWithTag:102];
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:104];
    UIView *back_view = (UIView *)[cell viewWithTag:105];
    UIButton *button = (UIButton *)[cell viewWithTag:106];
    [[back_view layer] setCornerRadius:10.0];
    // SUBJECT LABEL
    
    button.tag = indexPath.row;
    [button addTarget:vc action:@selector(openDescription:) forControlEvents:UIControlEventTouchUpInside];
    NSString *groupName = group.name;
    comunity_label.text = groupName;
    count_label.text = [NSString stringWithFormat:@"%lu Integrantes",(unsigned long)group.members.count];
    
    NSString *strImgURLAsString = group.image;
    [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            UIImage *img = [[UIImage alloc] initWithData:data];
            // pass the img to your imageview
            image_view.layer.cornerRadius = image_view.frame.size.height /2;
            image_view.layer.masksToBounds = YES;
            image_view.layer.borderWidth = 0;
            [image_view setImage:img];
        }else{
            NSLog(@"%@",connectionError);
        }
    }];
    
    /*if (conversation.status == CONV_STATUS_FAILED) {
     //message_label.hidden = NO;
     sender_label.hidden = YES;
     //group_message_label.hidden = YES;
     message_label.text = [[NSString alloc] initWithFormat:@"Errore nella creazione del gruppo. Tocca per riprovare"];
     }
     else if (conversation.status == CONV_STATUS_JUST_CREATED) {
     //message_label.hidden = NO;
     sender_label.hidden = YES;
     //group_message_label.hidden = YES;
     message_label.text = conversation.last_message_text;
     }
     else if (conversation.status == CONV_STATUS_LAST_MESSAGE) {
     //message_label.hidden = YES;
     sender_label.hidden = NO;
     //group_message_label.hidden = NO;
     message_label.text = [conversation textForLastMessage:me];
     NSString *sender_display_text = [CellConfigurator displayUserOfGroupConversation:conversation];
     sender_label.text = sender_display_text;
     }
     
     message_label.hidden = NO;
     // CONVERSATION IMAGE
     //    UIImageView *image_view = (UIImageView *)[cell viewWithTag:1];
     //    image_view.image = [UIImage imageNamed:@"group-conversation-avatar"];
     
     // CONVERSATION IMAGE
     UIImageView *image_view = (UIImageView *)[cell viewWithTag:1];
     NSString *imageURL = group.iconUrl;
     ChatImageWrapper *cached_image_wrap = (ChatImageWrapper *)[vc.imageCache getImage:imageURL];
     UIImage *image = cached_image_wrap.image;
     if(!cached_image_wrap) { // image == nil if image saving gone wrong!
     //        [vc startIconDownload:imageURL forIndexPath:indexPath];
     // if a download is deferred or in progress, return a placeholder image
     UIImage *circled = [ChatUtil circleImage:[UIImage imageNamed:@"group-conversation-avatar"]];
     image_view.image = circled;
     } else {
     image_view.image = [ChatUtil circleImage:image];
     // update too old images
     double now = [[NSDate alloc] init].timeIntervalSince1970;
     double reload_timer_secs = 3600; // one hour
     if (now - cached_image_wrap.createdTime.timeIntervalSince1970 > reload_timer_secs) {
     //            [vc startIconDownload:imageURL forIndexPath:indexPath];
     } else {
     //
     }
     }
     
     date_label.text = [conversation dateFormattedForListView];
     
     if (conversation.is_new) {
     // BOLD STYLE
     subject_label.font = [UIFont boldSystemFontOfSize:subject_label.font.pointSize];
     // CONV_STATUS_JUST_CREATED
     message_label.textColor = [UIColor blackColor];
     message_label.font = [UIFont boldSystemFontOfSize:message_label.font.pointSize];
     // CONV_STATUS_LAST_MESSAGE
     message_label.textColor = [UIColor blackColor];
     message_label.font = [UIFont boldSystemFontOfSize:message_label.font.pointSize];
     }
     else {
     // NORMAL STYLE
     subject_label.font = [UIFont systemFontOfSize:subject_label.font.pointSize];
     // CONV_STATUS_JUST_CREATED
     message_label.textColor = [UIColor lightGrayColor];
     message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
     // CONV_STATUS_LAST_MESSAGE
     message_label.textColor = [UIColor lightGrayColor];
     message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
     }*/
    return cell;
}
-(void)event_button_click:(id)sender
{
    
    //custom code
}
+(UITableViewCell *)configureDirectConversationCell:(ChatConversation *)conversation tableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath conversationsVC:(ChatConversationsVC *)vc {
    //    NSLog(@"-------------- DIRECT %@ SENDR %@" , conversation.last_message_text, conversation.sender);
    NSString *me = [ChatManager getInstance].loggedUser.userId;
    static NSString *conversationCellName = @"conversationDMCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:conversationCellName forIndexPath:indexPath];
    UILabel *subject_label = (UILabel *)[cell viewWithTag:2];
    UILabel *message_label = (UILabel *)[cell viewWithTag:3];
    //    UILabel *sender_label = (UILabel *)[cell viewWithTag:20];
    
    UILabel *date_label = (UILabel *)[cell viewWithTag:4];
    //    NSLog(@"DATELABEL..... %@", date_label);
    subject_label.text = conversation.conversWith_fullname ? conversation.conversWith_fullname : conversation.conversWith;
    
    message_label.hidden = NO;
    //    sender_label.hidden = YES;
    message_label.text = [conversation textForLastMessage:me];
    
    // CONVERSATION IMAGE
    UIImageView *image_view = (UIImageView *)[cell viewWithTag:1];
    NSString *imageURL = @""; //[SHPUser photoUrlByUsername:conversation.conversWith];
    ChatContactsDB *db = [ChatContactsDB getSharedInstance];
    [db searchContactsByUIDSynchronized:conversation.conversationId completion:^(NSArray<ChatUser *> *users) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if([users count] > 0){
                NSString *imageURL = users[0].imageurl;
                ChatImageWrapper *cached_image_wrap = (ChatImageWrapper *)[vc.imageCache getImage:imageURL];
                UIImage *user_image = cached_image_wrap.image;
                if(!cached_image_wrap) { // user_image == nil if image saving gone wrong!
                    //[vc startIconDownload:imageURL forIndexPath:indexPath];
                    // if a download is deferred or in progress, return a placeholder image
                    UIImage *circled = [ChatUtil circleImage:[UIImage imageNamed:@"avatar"]];
                    image_view.image = circled;
                } else {
                    //NSLog(@"USER IMAGE CACHED. %@", conversation.conversWith);
                    image_view.image = [ChatUtil circleImage:user_image];
                    // update too old images
                    double now = [[NSDate alloc] init].timeIntervalSince1970;
                    double reload_timer_secs = 3600; // one hour
                    if (now - cached_image_wrap.createdTime.timeIntervalSince1970 > reload_timer_secs) {
                        //NSLog(@"EXPIRED image for user %@. Created: %@ - Now: %@. Reloading...", conversation.conversWith, cached_image_wrap.createdTime, [[NSDate alloc] init]);
                        //            [vc startIconDownload:imageURL forIndexPath:indexPath];
                    } else {
                        //NSLog(@"VALID image for user %@. Created %@ - Now %@", conversation.conversWith, cached_image_wrap.createdTime, [[NSDate alloc] init]);
                    }
                }
                
                
                NSString *strImgURLAsString = imageURL;
                [strImgURLAsString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                NSURL *imgURL = [NSURL URLWithString:strImgURLAsString];
                [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:imgURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                    if (!connectionError) {
                        UIImage *img = [[UIImage alloc] initWithData:data];
                        // pass the img to your imageview
                        image_view.layer.cornerRadius = image_view.frame.size.height /2;
                        image_view.layer.masksToBounds = YES;
                        image_view.layer.borderWidth = 0;
                        [image_view setImage:img];
                    }else{
                        NSLog(@"%@",connectionError);
                    }
                }];
            }
        });
    }];
    ChatImageWrapper *cached_image_wrap = (ChatImageWrapper *)[vc.imageCache getImage:imageURL];
    UIImage *user_image = cached_image_wrap.image;
    if(!cached_image_wrap) { // user_image == nil if image saving gone wrong!
        //        [vc startIconDownload:imageURL forIndexPath:indexPath];
        // if a download is deferred or in progress, return a placeholder image
        UIImage *circled = [ChatUtil circleImage:[UIImage imageNamed:@"avatar"]];
        image_view.image = circled;
    } else {
        //NSLog(@"USER IMAGE CACHED. %@", conversation.conversWith);
        image_view.image = [ChatUtil circleImage:user_image];
        // update too old images
        double now = [[NSDate alloc] init].timeIntervalSince1970;
        double reload_timer_secs = 3600; // one hour
        if (now - cached_image_wrap.createdTime.timeIntervalSince1970 > reload_timer_secs) {
            //NSLog(@"EXPIRED image for user %@. Created: %@ - Now: %@. Reloading...", conversation.conversWith, cached_image_wrap.createdTime, [[NSDate alloc] init]);
            //            [vc startIconDownload:imageURL forIndexPath:indexPath];
        } else {
            //NSLog(@"VALID image for user %@. Created %@ - Now %@", conversation.conversWith, cached_image_wrap.createdTime, [[NSDate alloc] init]);
        }
    }
    
    date_label.text = [conversation dateFormattedForListView];
    //    NSLog(@"date lebel text %@", date_label.text);
    
    if (conversation.status == CONV_STATUS_LAST_MESSAGE) {
        if (conversation.is_new) {
            // BOLD STYLE
            subject_label.font = [UIFont boldSystemFontOfSize:subject_label.font.pointSize];
            message_label.textColor = [UIColor blackColor];
            message_label.font = [UIFont boldSystemFontOfSize:message_label.font.pointSize];
        }
        else {
            // NORMAL STYLE
            subject_label.font = [UIFont systemFontOfSize:subject_label.font.pointSize];
            // direct
            message_label.textColor = [UIColor lightGrayColor];
            message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
        }
    } else {
        // NORMAL STYLE
        subject_label.font = [UIFont systemFontOfSize:subject_label.font.pointSize];
        message_label.textColor = [UIColor lightGrayColor];
        message_label.font = [UIFont systemFontOfSize:message_label.font.pointSize];
    }
    return cell;
}

+(NSString *)displayUserOfGroupConversation:(ChatConversation *)c {
    NSString *displayName;
    // use fullname if available
    if (c.senderFullname) {
        NSString *trimmedFullname = [c.senderFullname stringByTrimmingCharactersInSet:
                                     [NSCharacterSet whitespaceCharacterSet]];
        if (trimmedFullname.length > 0) {
            displayName = trimmedFullname;
        }
    }
    
    // if fullname not available use username instead
    if (!displayName) {
        displayName = c.sender;
    }
    NSString *_displayName = [[NSString alloc] initWithFormat:@"%@:", displayName];
    return _displayName;
}

@end

