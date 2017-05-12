//
//  MCaptureViewController.m
//  VideoAudioCapture
//
//  Created by 苗国栋 on 2017/5/10.
//  Copyright © 2017年 MiaoGuodong. All rights reserved.
//

#import "MCaptureViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface MCaptureViewController ()<AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureDeviceInput *currentDeviceVideoInput;
@property (nonatomic, strong) AVCaptureDeviceInput *currentDeviceAudioInput;
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previeViewLayer;
@property (nonatomic, strong) AVCaptureConnection *captureConnection;
@property (nonatomic, weak) UIImageView *focusCursorImageView;

@end

@implementation MCaptureViewController

- (UIImageView *)focusCursorImageView
{
    if (_focusCursorImageView == nil) {
        UIImageView *cursorImgView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"focus"]];
        _focusCursorImageView = cursorImgView;
        [self.view addSubview:_focusCursorImageView];
    }
    return _focusCursorImageView;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"视音频采集";
    self.view.backgroundColor = [UIColor whiteColor];
    [self setCaptureVideo_Audio];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"摄像头" style:UIBarButtonItemStylePlain target:self action:@selector(chageCameraPosition)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonSystemItemCancel target:self action:@selector(backLastVC)];
    self.navigationItem.leftBarButtonItem = leftItem;
}

- (void)backLastVC
{
    [self.navigationController popViewControllerAnimated:YES];
    [self.captureSession stopRunning];
}

- (void)setCaptureVideo_Audio
{
    AVCaptureSession *captureSession_ = [[AVCaptureSession alloc]init];
    _captureSession = captureSession_;
    

    AVCaptureDevice *videoDevice = [self getVideoDevice:AVCaptureDevicePositionFront];
    AVCaptureDevice *audioDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio];
    NSError *error;
    AVCaptureDeviceInput *videoDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:videoDevice error:&error];
    _currentDeviceVideoInput = videoDeviceInput;
    AVCaptureDeviceInput *audioDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:audioDevice error:&error];
    _currentDeviceAudioInput = audioDeviceInput;
    if ([captureSession_ canAddInput:videoDeviceInput]) {
        [captureSession_ addInput:videoDeviceInput];
    }
    if ([captureSession_ canAddInput:audioDeviceInput]) {
        [captureSession_ addInput:audioDeviceInput];
    }
    
    AVCaptureVideoDataOutput *videoOutput = [[AVCaptureVideoDataOutput alloc]init];
    dispatch_queue_t videoQueue = dispatch_queue_create("Video Capture Queue", DISPATCH_QUEUE_SERIAL);
    [videoOutput setSampleBufferDelegate:self queue:videoQueue];
    if ([captureSession_ canAddOutput:videoOutput]) {
        [captureSession_ addOutput:videoOutput];
    }
    
    AVCaptureAudioDataOutput *audioOutput =[[AVCaptureAudioDataOutput alloc]init];
    dispatch_queue_t audioQueue = dispatch_queue_create("Audio Capture Queue", DISPATCH_QUEUE_SERIAL);
    [audioOutput setSampleBufferDelegate:self queue:audioQueue];
    if ([captureSession_ canAddOutput:audioOutput]) {
        [captureSession_ addOutput:audioOutput];
    }
    
    _captureConnection = [videoOutput connectionWithMediaType:AVMediaTypeVideo];
    
    AVCaptureVideoPreviewLayer *previewLayer_ = [AVCaptureVideoPreviewLayer layerWithSession:captureSession_];
    previewLayer_.frame = [[UIScreen mainScreen] bounds];
    [self.view.layer insertSublayer:previewLayer_ atIndex:0];
    _previeViewLayer = previewLayer_;
    
    [captureSession_ startRunning];
    
    
}

- (AVCaptureDevice *)getVideoDevice:(AVCaptureDevicePosition *)position
{
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices )
        if ( device.position == position )
            return device;
    return nil;
}
/**
 * 切换摄像头
 **/
- (void)chageCameraPosition
{
    NSArray *inputs = self.captureSession.inputs;
    for (AVCaptureDeviceInput *input in inputs) {
        AVCaptureDevice *device = input.device;
        if ([device hasMediaType:AVMediaTypeVideo]) {
            AVCaptureDevicePosition position = device.position;
            AVCaptureDevice *newCamera = nil;
            AVCaptureDeviceInput *newinput = nil;
            if (position == AVCaptureDevicePositionFront) {
                newCamera = [self getVideoDevice:AVCaptureDevicePositionBack];
            }else
            {
                newCamera = [self getVideoDevice:AVCaptureDevicePositionFront];
                
            }
            newinput = [AVCaptureDeviceInput deviceInputWithDevice:newCamera error:nil];
            
            [self.captureSession beginConfiguration];
            
            [self.captureSession removeInput:input];
            [self.captureSession addInput:newinput];
            
            // Changes take effect once the outermost commitConfiguration is invoked.
            [self.captureSession commitConfiguration];
        }
    }
}


#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    if (_captureConnection == connection) {
         NSLog(@"采集到视频数据");
    }else
    {
         NSLog(@"采集到音频数据");
    }
}



- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self.view];
    CGPoint cameraPoint = [_previeViewLayer captureDevicePointOfInterestForPoint:point];
    // 设置聚焦点光标位置
    [self setFocusCursorWithPoint:point];
    // 设置自动聚焦
    [self focusWithModel:AVCaptureFocusModeAutoFocus exposureModel:AVCaptureExposureModeAutoExpose atPodint:cameraPoint];
}

/**
 设置聚焦光标位置

 @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point
{
    self.focusCursorImageView.center = point;
    self.focusCursorImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusCursorImageView.alpha = 1.0;
    [UIView animateWithDuration:1.0 animations:^{
        self.focusCursorImageView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.focusCursorImageView.alpha = 0;
    }];
}

/**
 设置 聚焦 曝光

 @param focusmodel <#focusmodel description#>
 @param exposuremodel <#exposuremodel description#>
 @param point <#point description#>
 */
- (void)focusWithModel:(AVCaptureFocusMode)focusmodel exposureModel:(AVCaptureExposureMode)exposuremodel atPodint:(CGPoint)point
{
    AVCaptureDevice *captureDevice = _currentDeviceVideoInput.device;
    [captureDevice lockForConfiguration:nil];
    
    if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
    }
    if ([captureDevice isFocusPointOfInterestSupported]) {
        [captureDevice setFocusPointOfInterest:point];
    }
    if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
        [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
    }
    if ([captureDevice isExposurePointOfInterestSupported]) {
        [captureDevice setExposurePointOfInterest:point];
    }
    [captureDevice unlockForConfiguration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
