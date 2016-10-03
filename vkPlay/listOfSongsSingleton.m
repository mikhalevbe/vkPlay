//
//  Songs.m
//  vkPlay
//

#import "listOfSongsSingleton.h"

@implementation listOfSongsSingleton


+ (instancetype)sharedInstance {
    static listOfSongsSingleton *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[listOfSongsSingleton alloc] init];
    });
    return sharedInstance;
}

- (id)init {
    if (self = [super init]) {
        self.listOfSongs = [[NSMutableArray alloc] init];
    }
    return self;
}


@end
