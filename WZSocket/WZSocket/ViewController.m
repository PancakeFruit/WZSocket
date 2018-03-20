//
//  ViewController.m
//  Camera
//
//  Created by 魏峥 on 17/6/12.
//  Copyright © 2017年 魏峥. All rights reserved.
//

#import "ViewController.h"
#import "WZSocketManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *sendFiled;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIButton *connectBtn;
@property (weak, nonatomic) IBOutlet UIButton *disConnecBtn;
@property (nonatomic, strong) NSTimer *timer;

@property (weak, nonatomic) IBOutlet UILabel *wifiName;
@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_connectBtn addTarget:self action:@selector(connectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_disConnecBtn addTarget:self action:@selector(disConnectAction) forControlEvents:UIControlEventTouchUpInside];
    
    [_sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    //WIFI
    [self currentWifi];
    //[self getSignalStrength];
  
    
}
//连接热点
- (IBAction)ConnectHot:(id)sender {
    UIAlertController *alertCrt = [UIAlertController alertControllerWithTitle:@"是否需要连接热点" message:nil preferredStyle: UIAlertControllerStyleAlert];
    //添加取消到UIAlertController中
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alertCrt addAction:cancelAction];
    
    //添加确定到UIAlertController中
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self wifi];
        [self private];
    }];
    [alertCrt addAction:OKAction];
    
    [self presentViewController:alertCrt animated:YES completion:nil];
}
//连接
- (void)connectAction
{
    [[WZSocketManager share] connect];
    
}
//断开连接
- (void)disConnectAction
{
    [[WZSocketManager share] disConnect];
}

//发送消息
- (void)sendAction
{
   _timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(action:) userInfo:nil repeats:NO];

}
-(void)action:(NSTimer *)sender{
    
   // if (_sendFiled.text.length == 0) {
    //    return ;
    //}
    [[WZSocketManager share]sendMsg:_sendFiled.text];
    [_timer invalidate];
    _timer = nil;

}

// currentWifi
-(void) currentWifi{
    id info = nil;
    NSArray *ifs = (__bridge_transfer id)CNCopySupportedInterfaces();
    for (NSString *ifnam in ifs) {
        info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
        NSString *str = info[@"SSID"];
        NSString *str2 = info[@"ASSI"];
        NSString *str3 = [[ NSString alloc] initWithData:info[@"SSIDDATA"] encoding:NSUTF8StringEncoding];
        _wifiName.text = str;
       
        
    }
    
}
//- (void)getSignalStrength{
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *subviews = [[[app valueForKey:@"statusBar"] valueForKey:@"foregroundView"] subviews];
//    NSString *dataNetworkItemView = nil;
//    
//    for (id subview in subviews) {
//        if([subview isKindOfClass:[NSClassFromString(@"UIStatusBarDataNetworkItemView") class]]) {
//            dataNetworkItemView = subview;
//            break;
//        }
//    }
//    
//    int signalStrength = [[dataNetworkItemView valueForKey:@"_wifiStrengthBars"] intValue];
//    
//    NSLog(@"signal %d", signalStrength);
//    NSString *str = [[NSString alloc] initWithFormat:@"%d",signalStrength ];
//    _wifiName.text = str;
//    
//  
//    
//}

//连接wifiHot
#pragma mark - iOS 9 8 7 可正常跳转
-(void)wifi
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url]; // iOS 9 的跳转
    }
}

#pragma mark - iOS 10 9 8 7 可正常跳转（会跳到自身应用界面的系统设置）
//（这方法虽然iOS 10也可以用但是并不能去到蓝牙、WIFI、电池，只能去到自身应用的系统设置。）
-(void)set
{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url];
    }
}

#pragma mark - iOS 10 新API
-(void)newApi
{
    NSURL *url = [NSURL URLWithString:@"prefs:root=WIFI"];
    
    if ([[UIApplication sharedApplication] canOpenURL:url]) {
        
        [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
    }
    
}

#pragma mark - 绕过审核
-(void)private
{
    NSString * defaultWork = [self getDefaultWork];
    NSString * bluetoothMethod = [self getBluetoothMethod];
    NSURL*url=[NSURL URLWithString:@"Prefs:root=WIFI"];
    Class LSApplicationWorkspace = NSClassFromString(@"LSApplicationWorkspace");
    [[LSApplicationWorkspace  performSelector:NSSelectorFromString(defaultWork)]   performSelector:NSSelectorFromString(bluetoothMethod) withObject:url     withObject:nil];
}

-(NSString *) getDefaultWork{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x64,0x65,0x66,0x61,0x75,0x6c,0x74,0x57,0x6f,0x72,0x6b,0x73,0x70,0x61,0x63,0x65} length:16];
    NSString *method = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    return method;
}

-(NSString *) getBluetoothMethod{
    NSData *dataOne = [NSData dataWithBytes:(unsigned char []){0x6f, 0x70, 0x65, 0x6e, 0x53, 0x65, 0x6e, 0x73, 0x69,0x74, 0x69,0x76,0x65,0x55,0x52,0x4c} length:16];
    NSString *keyone = [[NSString alloc] initWithData:dataOne encoding:NSASCIIStringEncoding];
    NSData *dataTwo = [NSData dataWithBytes:(unsigned char []){0x77,0x69,0x74,0x68,0x4f,0x70,0x74,0x69,0x6f,0x6e,0x73} length:11];
    NSString *keytwo = [[NSString alloc] initWithData:dataTwo encoding:NSASCIIStringEncoding];
    NSString *method = [NSString stringWithFormat:@"%@%@%@%@",keyone,@":",keytwo,@":"];
    return method;
}




@end
