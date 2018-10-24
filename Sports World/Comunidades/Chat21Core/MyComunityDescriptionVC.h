//
//  MyComunityDescriptionVC.h
//  Sports World
//
//  Created by Glauco Valdes on 10/21/18.
//  Copyright © 2018 Delberto Martinez Salazar. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyComunityDescriptionVC : UIViewController
@property (strong, nonatomic) NSString *nameText;
@property (strong, nonatomic) NSString *userCountText;
@property (strong, nonatomic) NSString *descriptionText;
@property (strong, nonatomic) NSString *selectedGroupId;
@property (assign, nonatomic) int *typeView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userCountLabel;
@property (weak, nonatomic) IBOutlet UITextView *textViewDescription;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *suscribeButton;

@end

NS_ASSUME_NONNULL_END
