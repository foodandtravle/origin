//
//  ViewController.h
//  AVPlayer
//
//  Created by 张德强 on 15/10/20.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#define maiScr [UIScreen mainScreen].bounds.size

@interface ViewController : UIViewController

@property(nonatomic,strong)AVPlayer *player;//播放控制器
@property(nonatomic,strong)AVPlayerItem *playerItems;//播放资源

@property(nonatomic,strong)UIView *playeView;//播放窗口
@property(nonatomic,strong)UIProgressView *progressView;//进度条
@property(nonatomic,strong)UIButton *playOrPause;//开始暂停按钮



@end

