//
//  SHSettingViewController.h
//  INewsX
//
//  Created by sherwin.chen on 2019/10/16.
//  Copyright © 2019 Sherwin.Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SHSettingViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *swImage;
@property (weak, nonatomic) IBOutlet UITextField *tfFontSize;
@property (weak, nonatomic) IBOutlet UITextField *tfBgColor;
@property (weak, nonatomic) IBOutlet UILabel *lbShowText;


- (IBAction)fontSizeEditingDidEnd:(UITextField *)sender;
- (IBAction)bgColorEditingDidEnd:(UITextField *)sender;
- (IBAction)actionEndEdit:(UITapGestureRecognizer *)sender;

@end

NS_ASSUME_NONNULL_END
