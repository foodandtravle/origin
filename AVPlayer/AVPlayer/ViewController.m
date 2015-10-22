//
//  ViewController.m
//  AVPlayer
//
//  Created by 张德强 on 15/10/20.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayerDemo.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    

    
    NSString *str=[[NSBundle mainBundle]pathForResource:@"Java" ofType:@"mp4"];
    
    NSURL *url=[NSURL fileURLWithPath:str];
    
    AVPlayerItem *playerItem=[AVPlayerItem playerItemWithURL:url];
    
    AVPlayerDemo *ad=[[AVPlayerDemo alloc]initWithFrame:CGRectMake(10, 10, maiScr.width-40, 300)withPlayerItem:playerItem];
    [self.view addSubview:ad];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
