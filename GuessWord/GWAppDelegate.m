//
//  GWAppDelegate.m
//  GuessWord
//
//  Created by Dannion on 13-12-9.
//  Copyright (c) 2013年 BUPTMITC. All rights reserved.
//

#import "GWAppDelegate.h"

@implementation GWAppDelegate

-(void)copyLocalDatabaseIntoApp{
    NSURL *storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NoteWithCoreData.sqlite"];
    /*******************如果本地没有数据库（第一次使用），那么拷贝Boundle中的数据库***************************/
    if (![[NSFileManager defaultManager] fileExistsAtPath:[storeURL path]]) {
        NSLog(@"第一次运行，将Boundle中的数据库拷贝到applicationDocumentsDirectory");
        NSURL *preloadURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"InitData" ofType:@"sqlite"]];
        NSError* err = nil;
        
        if (![[NSFileManager defaultManager] copyItemAtURL:preloadURL toURL:storeURL error:&err]) {
            NSLog(@"Oops, could copy preloaded data");
        }
    }else{
        NSLog(@"第X次运行");
    }
    /************************************************************************************************/
}
-(void)saveContext
{
    NSError *error;
    NSManagedObjectContext *managedObjectContext=self.managedObjectContext;
    if(managedObjectContext!=nil)
    {
        if([managedObjectContext hasChanges]&&![managedObjectContext save:&error])
        {
            NSLog(@"保存数据时出错了:%@",error);
        }
    }
}

-(NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if(_persistentStoreCoordinator!=nil)
    {
        return _persistentStoreCoordinator;
    }
    NSURL *storeURL=[[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NoteWithCoreData.sqlite"];
    
    NSError *error;
    _persistentStoreCoordinator=[[NSPersistentStoreCoordinator alloc]initWithManagedObjectModel:[self managedObjectModel]];
    if(![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        NSLog(@"创建存储协调器错误了：%@",error);
    }
    return _persistentStoreCoordinator;
}


-(NSManagedObjectContext *)managedObjectContext
{
    if(_managedObjectContext!=nil)
    {
        return _managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator=[self persistentStoreCoordinator];
    if(coordinator!=nil)
    {
        _managedObjectContext=[[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

-(NSManagedObjectModel *)managedObjectModel
{
    if(_managedObjectModel!=nil)
    {
        return _managedObjectModel;
    }
    NSURL *storeURL=[[NSBundle mainBundle]URLForResource:@"CoreDataModel" withExtension:@"momd"];
    return [[NSManagedObjectModel alloc] initWithContentsOfURL:storeURL];
}

-(NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager]URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [[UINavigationBar appearance] setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    
    // set the title text property, color, font, size and so on
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor blackColor], NSForegroundColorAttributeName,
      [UIFont systemFontOfSize:20.0], NSFontAttributeName, nil]];

    [self copyLocalDatabaseIntoApp]; //将本地数据库初始化
    
    //    NSArray * fontArrays = [[NSArray alloc] initWithArray:[UIFont familyNames]];
//    for (NSString * temp in fontArrays) {
//        NSLog(@"Font name  = %@", temp);
//    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Temp Method
#warning 后期删去该方法。换成直接用图片
- (UIImage*)createImageWithColor:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

@end
