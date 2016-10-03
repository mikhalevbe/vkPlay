//
//  SongStructure.m
//  vkPlay
//
//  Created by Admin on 14.04.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import "SongStructure.h"

@implementation SongStructure

- (id)initWithArtist: (NSString*) artist Title: (NSString*) title Url: (NSString*) url Id: (NSNumber*) idSong downloadPath: (NSString*) path {
    self = [super init];
    if (self) {
        self.artist = [[NSString alloc] initWithString:artist];
        self.title = [[NSString alloc] initWithString:title];
        self.url = [[NSString alloc] initWithString:url];
        self.downloadedFilePath = [[NSString alloc] initWithString:path];
        self.idSong = idSong;
    }
    return self;
}

@end
