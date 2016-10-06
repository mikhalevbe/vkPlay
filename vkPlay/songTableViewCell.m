//
//  TableViewCellSong.m
//  vkPlay
//
//  Created by Admin on 31.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import "songTableViewCell.h"
#import "playListViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <MagicalRecord/MagicalRecord.h>
#import "SongTable.h"
#import "listOfSongsSingleton.h"
#import "AudioController.h"

@implementation songTableViewCell

@synthesize downloadPlayButton;

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
}

-(NSString *) randomMP3fileNameWithLength: (int) len {
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len-4; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((unsigned int)[letters length])]];
    }
    
    randomString = [NSMutableString stringWithFormat:@"%@.mp3", randomString];
    return randomString;
}


- (IBAction)buttonPressed:(UIButton *)sender
{
    __weak typeof(self) weakSelf = self;
    __block SongStructure* song = [[listOfSongsSingleton sharedInstance].listOfSongs objectAtIndex:self.songTitle.tag];
    
    if ([song.downloadedFilePath isEqualToString:@"no path"]) {
        // ... Download from urlSong
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURL *URL = [NSURL URLWithString:song.url];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:nil destination:^NSURL *(NSURL *targetPath, NSURLResponse *response)
        {
            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
            NSURL *pathURL = [documentsDirectoryURL URLByAppendingPathComponent:[self randomMP3fileNameWithLength:17]];
            return pathURL;
        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error)
        {
            //NSLog(@"log: %@", error.description);
            if (!error)
            {
                //NSLog(@"File downloaded to: %@", filePath.absoluteString);
   
                NSRange range = NSMakeRange(filePath.absoluteString.length-17, 17);
                NSString* filename = [filePath.absoluteString substringWithRange:range];
                  
                // add filepath to song in array
                song.downloadedFilePath =  [NSString stringWithString:filename];
                //NSLog(@"File downloaded to filename:  %@", song.downloadedFilePath);
                  
                // add filepath to song in DB
                [MagicalRecord saveWithBlock:^(NSManagedObjectContext* localContext)
                {
                    SongTable *foundSong = [SongTable MR_findFirstByAttribute:@"idSong" withValue:song.idSong];
                       
                    if (foundSong) {
                        [foundSong MR_deleteEntityInContext:localContext];
                           
                        SongTable *entitySong = [SongTable MR_createEntityInContext:localContext];
                        entitySong.idSong = song.idSong;
                        entitySong.title = song.title;
                        entitySong.artist = song.artist;
                        entitySong.url = song.url;
                        entitySong.downloadedFilePath = song.downloadedFilePath;
                           
                        //NSLog(@"add path to file into DB: %@", entitySong.downloadedFilePath);
                    }
                       
                    [localContext MR_saveToPersistentStoreWithCompletion:nil];
                    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:nil];
                       
                } completion: ^(BOOL contextDidSave, NSError * _Nullable error){
                    typeof(self) strongSelf = weakSelf;
                    if (!strongSelf) return;
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [strongSelf.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
                    });
                }];
            }
        }];
        
        [downloadTask resume];
        
    } else
    {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSApplicationSupportDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
        NSURL *pathURL = [documentsDirectoryURL URLByAppendingPathComponent:song.downloadedFilePath];
        
        self.audioController = [AudioController sharedInstance];
        [self.audioController tryPlayMusic:pathURL.absoluteString button:self.downloadPlayButton];
    }
}


@end
