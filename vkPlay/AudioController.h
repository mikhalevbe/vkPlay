//
//  AudioController.h
//  ATBasicSounds
//
//  Created by Audrey M Tam on 22/03/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@import AVFoundation;

@interface AudioController : NSObject <AVAudioPlayerDelegate>

@property (strong, nonatomic) AVAudioSession *audioSession;
@property (strong, nonatomic) AVAudioPlayer *backgroundMusicPlayer;
@property (strong, nonatomic) NSString *pathToFile;
@property (weak, nonatomic) UIButton* downloadPlayButton;
@property (assign) BOOL backgroundMusicPlaying;
@property (assign) BOOL backgroundMusicInterrupted;

+ (instancetype)sharedInstance;
- (instancetype)init;
- (void)tryPlayMusic: (NSString*)pathToFile button:(UIButton*)button;

@end
