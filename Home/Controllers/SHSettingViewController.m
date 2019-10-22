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

#pragma mark - key-value storage

- (IBAction)SwitchValueChanged:(UISwitch *)sender {
    [iCloudHandle setUpKeyValueICloudStoreWithKey:kImageSwitch value:sender.on==YES?@"1":@"0"];
}

//! 数据同步

/*
0: 成功
1: 失败
2: 无同步数据
3: 上传iclound失败
*/
- (IBAction)action4DataSys:(UIButton *)sender {

    NSUbiquitousKeyValueStore *keyValueStore = [NSUbiquitousKeyValueStore defaultStore];
    [keyValueStore synchronize];


    [COM.mLoveHelper synchronousWithCompletionHandler:^(NSInteger code) {

        if(code == 0){
            [QMUITips showSucceed:@"数据同步成功."];
            [[NSNotificationCenter defaultCenter] postNotificationName:kNotiSyschronLoverInfo object:nil];
        }
        else if(code == 1){
            [QMUITips showSucceed:@"数据同步失败."];
        }
        else if(code == 2){
            [QMUITips showSucceed:@"无可用同步数据."];
        }
        else if(code == 3){
            [QMUITips showSucceed:@"上传iClound失败."];
        }
        //NSLog(@"返回值：%ld",code);
    }];


    /*

    [iCloudHandle setUpKeyValueICloudStoreWithKey:kFontSize value:self.tfFontSize.text];

    [iCloudHandle setUpKeyValueICloudStoreWithKey:kBgColor value:self.tfBgColor.text];
     */
}

-(void) loadKetValueICloudStore {

    self.swImage.on = [COM getNeedImage];
    self.tfFontSize.text = [COM getFontSize];
    self.tfBgColor.text = [COM getBgColor];

    [self showTextEfec];
    return;
}

-(void) showTextEfec {
    self.lbShowText.text = [NSString stringWithFormat:@"效果示例文字:   字体[%@pt] - 颜色[%@]",self.tfFontSize.text,self.tfBgColor.text];
    [self.lbShowText setBackgroundColor:[UIColor qmui_colorWithHexString:self.tfBgColor.text]];
    [self.lbShowText setFont:[UIFont systemFontOfSize:[self.tfFontSize.text floatValue] ]];
    return;
}

- (IBAction)fontSizeEditingDidEnd:(UITextField *)sender {
    [iCloudHandle setUpKeyValueICloudStoreWithKey:kFontSize value:sender.text];

    [self showTextEfec];
}

- (IBAction)bgColorEditingDidEnd:(UITextField *)sender {
    [iCloudHandle setUpKeyValueICloudStoreWithKey:kBgColor value:sender.text];

    [self showTextEfec];
}

- (IBAction)actionEndEdit:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}
@end
