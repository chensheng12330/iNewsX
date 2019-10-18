//
//  SHSettingViewController.m
//  INewsX
//
//  Created by sherwin.chen on 2019/10/16.
//  Copyright © 2019 Sherwin.Chen. All rights reserved.
//

#import "SHSettingViewController.h"

#import "iCloudHandle.h"
#import "QMUITips.h"

@interface SHSettingViewController ()

@end

@implementation SHSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"设置＆同步";

    [self.view endEditing:YES];

    [self loadKetValueICloudStore];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - key-value storage

- (IBAction)SwitchValueChanged:(UISwitch *)sender {
    [iCloudHandle setUpKeyValueICloudStoreWithKey:kImageSwitch value:sender.on==YES?@"1":@"0"];
}

//! 数据同步
- (IBAction)action4DataSys:(UIButton *)sender {

    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    [keyValueStore synchronize];

    [QMUITips showSucceed:@"数据已存储."];

    /*

    [iCloudHandle setUpKeyValueICloudStoreWithKey:kFontSize value:self.tfFontSize.text];

    [iCloudHandle setUpKeyValueICloudStoreWithKey:kBgColor value:self.tfBgColor.text];
     */
}

-(void) loadKetValueICloudStore {

    self.swImage.on = [COM getNeedImage];
    self.tfFontSize.text = [COM getFontSize];
    self.tfBgColor.text = [COM getBgColor];
    return;

    /*
    NSString *f1 =  [iCloudHandle getKeyValueICloudStoreWithKey:kImageSwitch];
    NSString *f2 =  [iCloudHandle getKeyValueICloudStoreWithKey:kFontSize];
    NSString *f3 =  [iCloudHandle getKeyValueICloudStoreWithKey:kBgColor];

    if(f1){
        self.swImage.on = [f1 isEqualToString:@"1"]?YES:NO;
    }

    if(f2){
        self.tfFontSize.text = f2;
    }

    if(f3){
        self.tfBgColor.text = f3;
    }
     */

    return;

}

- (IBAction)fontSizeEditingDidEnd:(UITextField *)sender {
     [iCloudHandle setUpKeyValueICloudStoreWithKey:kFontSize value:sender.text];
}

- (IBAction)bgColorEditingDidEnd:(UITextField *)sender {
    [iCloudHandle setUpKeyValueICloudStoreWithKey:kBgColor value:sender.text];
}

- (IBAction)actionEndEdit:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
@end
