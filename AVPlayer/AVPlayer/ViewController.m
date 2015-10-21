//
//  ViewController.m
//  AVPlayer
//
//  Created by 张德强 on 15/10/20.
//  Copyright © 2015年 张德强. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self setBaseView];
    
    //设置视图层
    [self setUpPlayer];
    
    [self.player play];
}

-(void)setBaseView{
    
    _playeView=[[UIView alloc]initWithFrame:CGRectMake(10, 0, maiScr.width-40, 300)];
    
    //_playeView=[[UIView alloc]initWithFrame:self.view.frame];
    
//    _playeView.backgroundColor=[UIColor redColor];
    
    [self.view addSubview:_playeView];
    
    _playOrPause=[UIButton buttonWithType:UIButtonTypeCustom];
    
    _playOrPause.frame=CGRectMake(10, 300, 30, 30);
    
    _playOrPause.layer.cornerRadius=15;
    
    _playOrPause.backgroundColor=[UIColor blueColor];
    
    [_playOrPause addTarget:self action:@selector(playOrPauseBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_playOrPause];
    
    _progressView=[[UIProgressView alloc]initWithFrame:CGRectMake(50, 320, maiScr.width-60, 10)];
    
    [self.view addSubview:_progressView];
    
}

-(void)setUpPlayer{
    
    //用self.player初始化一个新的图层playerLayer      player的初始化在重写后的set方法里
    AVPlayerLayer *playerLayer=[AVPlayerLayer playerLayerWithPlayer:self.player];
    
    playerLayer.frame=self.playeView.frame;
    
    [self.playeView.layer addSublayer:playerLayer];
}

-(AVPlayer *)player{
    
    if (!_player) {
        
        //可能会反复更换地址
        AVPlayerItem *playerItem=[self getPlayItem];
        
        _player=[AVPlayer playerWithPlayerItem:playerItem];
        
        [self addObserToPlayerItem:playerItem];
        
        [self addProgressObserve];

        [self addNotification];
        
        
 
    }
    
    return _player;
}

-(AVPlayerItem *)getPlayItem{
    
    NSString *strPath=[[NSBundle mainBundle] pathForResource:@"Java" ofType:@"mp4"];
    
    NSURL *url=[NSURL fileURLWithPath:strPath];
    
    //资源性获取地址
    AVPlayerItem *playItem=[AVPlayerItem playerItemWithURL:url];
    
    return playItem;
}

-(void)playOrPauseBtn:(UIButton *)sender{
    
    if (self.player.rate==0) {
        
        [self.player play];
        
    }else if (self.player.rate==1){
        
        [self.player pause];
    }
}

//给PlayerItem添加监控，监控status属性和loadedTimeRanges属性
-(void)addObserToPlayerItem:(AVPlayerItem *)playerItem{
    
    //这个属性可以获得播放状态
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    //这个属性可以获得网络加载情况
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil ];
}

//更新进度
-(void)addProgressObserve{
    
    AVPlayerItem *playerItem=self.player.currentItem;
    
    UIProgressView *progressView=self.progressView;
    
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current=CMTimeGetSeconds(time);//当前播放长度
        
        float total=CMTimeGetSeconds([playerItem duration]);
        
        NSLog(@"当前已经播放 %.2fs",current);
        
        if (current) {
            
            //当前进度比上总长度就是进度条的值
            [progressView setProgress:(current/total) animated:YES];
        }
    }];
}

//播放结束通知
-(void)addNotification{
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playBackFinish:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

-(void)playBackFinish:(NSNotification *)noti{
    
    //AVPlayerItem *playerItem=[noti object];
    
    NSLog(@"播放完成");
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
        
        float timeStart=CMTimeGetSeconds(timeRange.start);
        
        float durationSeconds=CMTimeGetSeconds(timeRange.duration);
        
        NSTimeInterval totalBuff=timeStart + durationSeconds;
        
        NSLog(@"共缓冲 : %.2f",totalBuff);
    }
    
}


//注销
-(void)dealloc{
    
    [self removeNotification];
    
    [self removeFromPlayerItem:self.player.currentItem];
}

-(void)removeNotification{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

-(void)removeFromPlayerItem:(AVPlayerItem *)playerItem{
    
    [playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    
    [playerItem removeObserver:self forKeyPath:@"status"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
