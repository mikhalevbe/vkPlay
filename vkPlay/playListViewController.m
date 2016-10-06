//
//  playListViewController.m
//  vkPlay
//
//  Created by Admin on 24.03.16.
//  Copyright © 2016 Boris-Mikhalev. All rights reserved.
//

#import <MagicalRecord/MagicalRecord.h>
#import <AFNetworking/AFNetworking.h>
#import "playListViewController.h"
#import "songTableViewCell.h"
#import "SongTable.h"
#import "SongStructure.h"
#import "listOfSongsSingleton.h"


@implementation playListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults* config = [NSUserDefaults standardUserDefaults];
    BOOL noFirstRun = [config boolForKey:@"noFirstRun"];
    
    if (self.navigationController) {
        UIImage *image = [UIImage imageNamed:@"vkplay30x30.png"];
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
    }
    UIBarButtonItem *refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(filterButton)];
    self.navigationItem.rightBarButtonItem = refreshButton;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cell" bundle:nil] forCellReuseIdentifier:@"cellSong"];
  
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];

    if (noFirstRun == NO) {
        [self firstGetSongsArrayFromVK];
        [config setBool:YES forKey:@"noFirstRun"];
    } else {
        [self updateSongsArrayFromDB];
    }
}

- (void)filterButton {
    //NSLog(@"filter button");
    [self.table reloadData];
}

- (void)firstGetSongsArrayFromVK {
    __weak typeof(self) weakSelf = self;
    
    VKRequest* req = [VKRequest requestWithMethod:@"audio.get" parameters:nil modelClass:[VKAudios class]];
    [req executeWithResultBlock:^(VKResponse* response)
     {
         typeof(self) strongSelf = weakSelf;
         if (!strongSelf) return;
         
         // parse JSON from VK
         NSData* data = [response.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSArray * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         if ([NSJSONSerialization isValidJSONObject:json])
         {
             NSDictionary* response = [json valueForKey:@"response"];
             NSArray* items = [response valueForKey:@"items"];
             for (int i = 0; i < items.count; i++)
             {
                 NSDictionary* aSong = items[i];
                 //NSLog(@"log: %@", [aSong valueForKey:@"artist"]);
                 [[listOfSongsSingleton sharedInstance].listOfSongs addObject:[[SongStructure alloc] initWithArtist:[aSong valueForKey:@"artist"] Title:[aSong valueForKey:@"title"] Url:[aSong valueForKey:@"url"] Id:[aSong valueForKey:@"id"] downloadPath:@"no path"]];
             }
         }
     
         [strongSelf firstSaveSongsToDB];
         
     }   errorBlock:nil];
    
}

- (void)firstSaveSongsToDB {
    __weak typeof(self) weakSelf = self;
    
    if ([listOfSongsSingleton sharedInstance].listOfSongs.count != 0) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
         {
             for (SongStructure* aSong in [listOfSongsSingleton sharedInstance].listOfSongs)
             {
                 SongTable *entitySong = [SongTable MR_createEntityInContext:localContext];
                 entitySong.idSong = aSong.idSong;
                 entitySong.title = aSong.title;
                 entitySong.artist = aSong.artist;
                 entitySong.url = aSong.url;
                 entitySong.downloadedFilePath = aSong.downloadedFilePath;
                 //NSLog(@"new saved song: %@", aSong.title);
             }
             [localContext MR_saveToPersistentStoreWithCompletion:nil];
             
         } completion:^(BOOL success, NSError *error) {
             typeof(self) strongSelf = weakSelf;
             if (!strongSelf) return;
             
             dispatch_async(dispatch_get_main_queue(), ^ {
                 [strongSelf.table reloadData];
             });
         }];
    }
}

- (void)updateSongsArrayFromVK {
    __weak typeof(self) weakSelf = self;
    
    VKRequest* req = [VKRequest requestWithMethod:@"audio.get" parameters:nil modelClass:[VKAudios class]];
    [req executeWithResultBlock:^(VKResponse* response)
    {
         typeof(self) strongSelf = weakSelf;
         if (!strongSelf) return;
         
         // parse JSON from VK
         NSData* data = [response.responseString dataUsingEncoding:NSUTF8StringEncoding];
         NSArray * json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
         if ([NSJSONSerialization isValidJSONObject:json])
         {
             NSDictionary* response = [json valueForKey:@"response"];
             NSArray* items = [response valueForKey:@"items"];
             
             if (items.count != [listOfSongsSingleton sharedInstance].listOfSongs.count)
             {
                 for (int i = 0; i < items.count; i++)
                 {
                     NSDictionary* aSong = items[i];
                     
                     NSPredicate *predicate = [NSPredicate predicateWithFormat:@"idSong == %@", [aSong valueForKey:@"id"]];
                     NSArray *filteredArray = [[listOfSongsSingleton sharedInstance].listOfSongs filteredArrayUsingPredicate:predicate];
                     
                     if (filteredArray.count == 0)
                    {
                        //NSLog(@"add new to array: %@", [aSong valueForKey:@"artist"]);
                        [[listOfSongsSingleton sharedInstance].listOfSongs addObject:[[SongStructure alloc] initWithArtist:[aSong valueForKey:@"artist"] Title:[aSong valueForKey:@"title"] Url:[aSong valueForKey:@"url"] Id:[aSong valueForKey:@"id"] downloadPath:@"no path"]];
                    }
                     
                 }
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     [strongSelf.table reloadData];
                 });
                 
             }
         }
         
         [strongSelf saveNewSongsToDB];
        
     }   errorBlock:nil];
    
}


- (void)updateSongsArrayFromDB {
    NSArray* temp_arr = [SongTable MR_findAllSortedBy:@"idSong" ascending:NO];
    
    if (temp_arr) {
        [[listOfSongsSingleton sharedInstance].listOfSongs removeAllObjects];
        
        for (int i = 0; i < temp_arr.count; i++) {
            SongStructure* aSong = [[SongStructure alloc] initWithArtist:[temp_arr[i] valueForKey:@"artist"] Title:[temp_arr[i] valueForKey:@"title"] Url:[temp_arr[i] valueForKey:@"url"] Id:[temp_arr[i] valueForKey:@"idSong"] downloadPath:[temp_arr[i] valueForKey:@"downloadedFilePath"]];
            [[listOfSongsSingleton sharedInstance].listOfSongs addObject:aSong];
        }
    }
}

- (void)saveNewSongsToDB {
    
    NSArray* temp_arr = [SongTable MR_findAll];
    
    if (temp_arr.count != [listOfSongsSingleton sharedInstance].listOfSongs.count) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext)
         {
             for (SongStructure* aSong in [listOfSongsSingleton sharedInstance].listOfSongs)
             {
                 NSPredicate *filter = [NSPredicate predicateWithFormat:@"idSong == %@", aSong.idSong];
                 SongTable *SongFound = [SongTable MR_findFirstWithPredicate: filter];
                 if (!SongFound)
                 {
                     SongTable *entitySong = [SongTable MR_createEntityInContext:localContext];
                     entitySong.idSong = aSong.idSong;
                     entitySong.title = aSong.title;
                     entitySong.artist = aSong.artist;
                     entitySong.url = aSong.url;
                     entitySong.downloadedFilePath = aSong.downloadedFilePath;
                     //NSLog(@"new added saved song");
                 }
             }
             [localContext MR_saveToPersistentStoreWithCompletion:nil];
             
         } completion:^(BOOL success, NSError *error) {
             
         }];
        
    }
}


- (BOOL)connected {
    return [AFNetworkReachabilityManager sharedManager].reachable;
}


#pragma mark - Select song

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Table view data source


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[listOfSongsSingleton sharedInstance].listOfSongs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self configureCellAt:indexPath];
}

- (songTableViewCell*)configureCellAt: (NSIndexPath *) indexPath {
    songTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cellSong" forIndexPath:indexPath];
    
    if (cell == nil)
    {
        cell = [[songTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellSong"];
    }
    
    SongStructure* aSong = [[listOfSongsSingleton sharedInstance].listOfSongs objectAtIndex:indexPath.row];
    
    cell.songTitle.text = [NSString stringWithFormat:@"%@ - %@", aSong.artist, aSong.title];
    cell.songTitle.tag = indexPath.row;
    
    if ([aSong.downloadedFilePath isEqualToString:@"no path"]) {
        [cell.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"download.png"] forState:UIControlStateNormal];
    } else {
        [cell.downloadPlayButton setBackgroundImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    }
    
    return cell;
}


- (IBAction)refreshTable:(UIRefreshControl *)sender {
    [self.refreshControl beginRefreshing];
    [self updateSongsArrayFromVK];
    [self.table reloadData];
    [self.refreshControl endRefreshing];
}


@end
