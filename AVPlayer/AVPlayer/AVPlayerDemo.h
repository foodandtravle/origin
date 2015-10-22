//
//  AVPlayerDemo.h
//  AVPlayer
//
//  Created by 张德强 on 15/10/21.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

#define  maiScr [UIScreen mainScreen].bounds.size

@interface AVPlayerDemo : UIView

@property(nonatomic,strong)AVPlayer *player;//播放器
@property(nonatomic,strong)AVPlayerItem *playerItem;//播放资源

@property(nonatomic,strong)UIView *playerView;//播放视图
@property(nonatomic,strong)UIProgressView *progressView;//进度条
@property(nonatomic,strong)UIButton *playOrPause;//开始按钮

-(id)initWithFrame:(CGRect)frame withPlayerItem:(AVPlayerItem *)playerItem ;



@end
