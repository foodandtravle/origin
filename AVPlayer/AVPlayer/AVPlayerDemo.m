//
//  AVPlayerDemo.m
//  AVPlayer
//
//  Created by 张德强 on 15/10/21.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import "AVPlayerDemo.h"

@implementation AVPlayerDemo

-(id)initWithFrame:(CGRect)frame withPlayerItem:(AVPlayerItem *)playerItem{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        _playerItem=playerItem;
        
        //播放视图
        self.playerView=[[UIView alloc]initWithFrame:frame];
        _playerView.backgroundColor=[UIColor yellowColor];
        [self addSubview:self.playerView];
        
        CGFloat originX=frame.origin.x;
        CGFloat originY=frame.origin.y;
        CGFloat height=frame.size.height;
        CGFloat width=frame.size.width;
        
        //开始暂停按钮
        _playOrPause=[UIButton buttonWithType:UIButtonTypeCustom];
        _playOrPause.frame=CGRectMake(originX, originY+height-30, 30, 30);
        [_playOrPause addTarget:self action:@selector(playOrPauseBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _playOrPause.layer.cornerRadius=15;
        [_playOrPause setBackgroundColor:[UIColor redColor]];
        [self addSubview:_playOrPause];
        
        CGFloat btnOriginX=self.playOrPause.frame.origin.x;
        CGFloat btnOriginY=self.playOrPause.frame.origin.y;
        CGFloat heightBtn=self.playOrPause.frame.size.height;
        CGFloat widthBtn  =self.playOrPause.frame.size.width;
        
        //进度条
        self.progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(btnOriginX+widthBtn+5, btnOriginY+heightBtn/2, width-widthBtn-10-5,10)];
        [self addSubview:self.progressView];
        
        [self setupPlayer];
        
        [self.player play];
    }
    return self;
}

-(void)playOrPauseBtnClick:(UIButton *)sender{
    
    if (self.player.rate==0) {
        
        [self.player play];
        
    }else if (self.player.rate==1){
        
        [self.player pause];
    }
}

-(void)setupPlayer{
    
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame=self.playerView.frame;
    
    [self.playerView.layer addSublayer:playerLayer];
}

-(AVPlayer *)player{
    
    if (!_player) {
        
        _player=[AVPlayer playerWithPlayerItem:_playerItem];
        
        [self addobserToPlayerItem:_playerItem];
        
        [self addProgress];
        
        [self addNotification];
    }

    return _player;
}

//修改进度条
-(void)addProgress{
    
    AVPlayerItem *playerItem=self.player.currentItem;
    
    UIProgressView *progressView=self.progressView;
    
    //每秒调用一次  类似于NSTimer  只适用于AVPlayer
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current=CMTimeGetSeconds(time);
        
        float total=CMTimeGetSeconds([playerItem duration]);
        
        NSLog(@"当前进度   :  %.2f",current);
        
        if (current) {
            
            [progressView setProgress:(current/total) animated:YES];
        }
    }];
}

//添加监控属性   看缓冲还是播放
-(void)addobserToPlayerItem:(AVPlayerItem *)playerItem{
    
    //status为播放状况
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //loadedTimeRanges缓冲状况
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    
}
/**
 *  通过KVO监控播放器状态
 *
 *  @param keyPath 监控属性
 *  @param object  监视器
 *  @param change  状态改变
 *  @param context 上下文
 */
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    
    AVPlayerItem *playerItem=object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status=[[change objectForKey:@"new"]intValue];
        
        if (status==AVPlayerStatusReadyToPlay) {
            
            NSLog(@"正在播放.......视频总长度....%.2f",CMTimeGetSeconds(playerItem.duration));
        }
        
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array=playerItem.loadedTimeRanges;
        
        CMTimeRange timeRange=[array.firstObject CMTimeRangeValue];
        
        float start=CMTimeGetSeconds(timeRange.start);
        
        float duration=CMTimeGetSeconds(timeRange.duration);
        
        NSTimeInterval totalBuff=start+duration;
        
        NSLog(@"共缓冲.....%.2f",totalBuff);
    }
}

-(void)addNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playBackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playBackFinish:(NSNotification *)noti{
    
    //AVPlayerItem *playerItem=[noti object];
    
    NSLog(@"播放完成");
    
    [self removeFromSuperview];
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [_playerItem removeObserver:self forKeyPath:@"status"];
    
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}



@end
