//
//  AudioController.m
//  ATBasicSounds
//
//  Created by Audrey M Tam on 22/03/2014.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//

#import "AudioController.h"


@implementation AudioController

+ (instancetype)sharedInstance {
    static AudioController *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[AudioController alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self configureAudioSession];
    }
    return self;
}

- (void)tryPlayMusic: (NSString*)pathToFile button:(UIButton*)button {
	// If background music or other music is already playing, nothing more to do here
//	if (self.backgroundMusicPlaying || [self.audioSession isOtherAudioPlaying]) {
//        return;
//    }
    
    
    if (self.backgroundMusicPlaying && self.downloadPlayButton == button)
    {
        [self.backgroundMusicPlayer stop];
        self.backgroundMusicPlaying = NO;
        [self.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    } else
    {
        if (self.backgroundMusicPlaying && self.downloadPlayButton != button)
        {
            [self.backgroundMusicPlayer stop];
            self.backgroundMusicPlaying = NO;
            [self.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        }
        
        self.pathToFile = pathToFile;
        self.downloadPlayButton = button;
        
        NSURL *backgroundMusicURL = [NSURL URLWithString:pathToFile];
        self.backgroundMusicPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:backgroundMusicURL error:nil];
        self.backgroundMusicPlayer.delegate = self;
        self.backgroundMusicPlayer.numberOfLoops = 1;
        [self.backgroundMusicPlayer prepareToPlay];
        [self.backgroundMusicPlayer play];
        self.backgroundMusicPlaying = YES;
        [self.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
    }
}

- (void) configureAudioSession {
    // Implicit initialization of audio session
    self.audioSession = [AVAudioSession sharedInstance];
	
    NSError *setCategoryError = nil;
    if ([self.audioSession isOtherAudioPlaying])
    { // mix sound effects with music already playing
        [self.audioSession setCategory:AVAudioSessionCategorySoloAmbient error:&setCategoryError];
        self.backgroundMusicPlaying = NO;
    } else {
        [self.audioSession setCategory:AVAudioSessionCategoryAmbient error:&setCategoryError];
    }
    if (setCategoryError) {
        NSLog(@"Error setting category! %ld", (long)[setCategoryError code]);
    }
}

#pragma mark - AVAudioPlayerDelegate methods

- (void) audioPlayerBeginInterruption: (AVAudioPlayer *) player {
    //It is often not necessary to implement this method since by the time
    //this method is called, the sound has already stopped. You don't need to
    //stop it yourself.
    //In this case the backgroundMusicPlaying flag could be used in any
    //other portion of the code that needs to know if your music is playing.
    
	self.backgroundMusicInterrupted = YES;
	self.backgroundMusicPlaying = NO;
}

- (void) audioPlayerEndInterruption: (AVAudioPlayer *) player withOptions:(NSUInteger) flags{
    //Since this method is only called if music was previously interrupted
    //you know that the music has stopped playing and can now be resumed.
    if (self.pathToFile) {
        [self tryPlayMusic:self.pathToFile button:self.downloadPlayButton];
    }
      self.backgroundMusicInterrupted = NO;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    self.backgroundMusicPlaying = NO;
    [self.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
}

@end
