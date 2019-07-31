//
//  ViewController.m
//  APNSTest
//
//  Created by apple on 2018/7/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ViewController.h"
//#import <AFNetworking.h>

#import <ifaddrs.h>
#import <arpa/inet.h>
#import <net/if.h>

#define IOS_CELLULAR    @"pdp_ip0"
#define IOS_WIFI        @"en0"
#define IOS_VPN         @"utun0"
#define IP_ADDR_IPv4    @"ipv4"
#define IP_ADDR_IPv6    @"ipv6"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBut;


@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)loginSender:(id)sender {
    [self logon];
    
}




-(void)logon{
//
//    NSDictionary *dict = @{@"clientversion":@"2.5.0",
//        @"devicegprsflow":@0,
//        @"serverip":@"172.16.200.112",
//        @"hsetname":@"TCT",
//        @"ostype":@"ios",
//        @"useouternetwork":@"false",
//        @"resolution":@"750*1334",
//        @"osversion":@"10.3",
//    @"password":@"964C5BD3B9D8EABB1DF97C2B335539C3933E601906EECE494974DAE45203ACB8933E601906EECE494974DAE45203ACB86FDF961CA6C9F5C2EA71C964D3275156",
//        @"network":@"WIFI",
//        @"deviceid":@"7D8AE7B2A2F1DEFBAB468A0AF321B80E",
//        @"version":@"1.0.0",
//        @"clientid":@"com.NR.APNSTest",
//        @"ecid":@"default",
//        @"loginname":@"P00011601",
//        @"esn":@"863157020870949",
//        @"isroot":@"0",
//        @"appgprsflow":@"0.0",
//        @"depCode":@"",
//        @"dpi":@"xhdpi",
//        @"hsetmodel":@"iPhone6",
//    @"devicetoken":@"7295b9217f5d993a26dda42a7daae08723e4c64bddc4f892763fdc6eb1b1229d",
//        @"ispad":@"0",
//        @"usevalidatecode":@"false",
//        @"wifimac":@"d8:e5:6d:e9:a6:25",
//        @"imsi":@""};
//
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    manager.requestSerializer.timeoutInterval = 10;
//    [manager.requestSerializer setValue:@"LOGIN" forHTTPHeaderField:@"cmd"];
//
//    //18888
//    [manager POST:@"http://172.16.200.112:18888/clientaccess" parameters:dict progress:^(NSProgress * _Nonnull uploadProgress) {
//
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSError *error = nil;
//        id obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments|NSJSONReadingMutableContainers error:&error];
//        if (error) {
////           cmd为LOGIN  为登录
//            NSLog(@"%@",obj);
//        }else{
//
//
//        }
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//
//    }];
    
}


+ (NSDictionary *)getIPAddresses {
    NSMutableDictionary *addresses = [NSMutableDictionary dictionaryWithCapacity:8];
    
    // retrieve the current interfaces - returns 0 on success
    struct ifaddrs *interfaces;
    if(!getifaddrs(&interfaces)) {
        // Loop through linked list of interfaces
        struct ifaddrs *interface;
        for(interface=interfaces; interface; interface=interface->ifa_next) {
            if(!(interface->ifa_flags & IFF_UP) /* || (interface->ifa_flags & IFF_LOOPBACK) */ ) {
                continue; // deeply nested code harder to read
            }
            const struct sockaddr_in *addr = (const struct sockaddr_in*)interface->ifa_addr;
            char addrBuf[ MAX(INET_ADDRSTRLEN, INET6_ADDRSTRLEN) ];
            if(addr && (addr->sin_family==AF_INET || addr->sin_family==AF_INET6)) {
                NSString *name = [NSString stringWithUTF8String:interface->ifa_name];
                NSString *type;
                if(addr->sin_family == AF_INET) {
                    if(inet_ntop(AF_INET, &addr->sin_addr, addrBuf, INET_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv4;
                    }
                } else {
                    const struct sockaddr_in6 *addr6 = (const struct sockaddr_in6*)interface->ifa_addr;
                    if(inet_ntop(AF_INET6, &addr6->sin6_addr, addrBuf, INET6_ADDRSTRLEN)) {
                        type = IP_ADDR_IPv6;
                    }
                }
                if(type) {
                    NSString *key = [NSString stringWithFormat:@"%@/%@", name, type];
                    addresses[key] = [NSString stringWithUTF8String:addrBuf];
                }
            }
        }
        // Free memory
        freeifaddrs(interfaces);
    }
    return [addresses count] ? addresses : nil;
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
