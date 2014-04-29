//
//  DKMainViewController.m
//  Demo
//
//  Created by Daniel on 4/17/14.
//  Copyright (c) 2014 dkhamsing. All rights reserved.
//

#import "DKMainViewController.h"
#import "DKUserMessageView.h"


@implementation DKMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.view.backgroundColor = [UIColor redColor];
        
        // Default
        DKUserMessageView *simpleMessageView = [[DKUserMessageView alloc] initWithFrame:CGRectMake(0, 40, self.view.bounds.size.width, 50)];
        [self.view addSubview:simpleMessageView];
        [simpleMessageView dk_displayMessage:@"Simple Message"];
        
        
        // Custom
        DKUserMessageView *customMessageView = [[DKUserMessageView alloc] initWithFrame:CGRectMake(0, simpleMessageView.frame.size.height +50, self.view.bounds.size.width, simpleMessageView.frame.size.height)];
        [self.view addSubview:customMessageView];
        customMessageView.backgroundColor = [UIColor yellowColor];
        
        // Use `dk_userMessageLabelTop` to move the user message label up or down (it is centered horizontally)
        customMessageView.dk_userMessageLabelTop = 2;
        
        // Access `dk_userMessageLabel` and change properties
        customMessageView.dk_userMessageLabel.backgroundColor = [UIColor orangeColor];
        customMessageView.dk_userMessageLabel.font = [UIFont boldSystemFontOfSize:22];
        customMessageView.dk_userMessageLabel.textColor = [UIColor blackColor];
        
        [customMessageView dk_displayMessage:@"Simple Message"];
        
        
        // Loading spinner (success)
        CGSize size = CGSizeMake(150, 100);
        UIImageView *kittenImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-150)/2, 200, size.width, size.height)];
        kittenImageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:kittenImageView];
        
        DKUserMessageView *loadingMessageView2 = [[DKUserMessageView alloc] init];
        loadingMessageView2.frame = kittenImageView.frame;
        [self.view addSubview:loadingMessageView2];
        
        [loadingMessageView2 dk_loading:YES spinner:YES];
        
        NSString *kittenUrl = [NSString stringWithFormat:@"http://placekitten.com/%.0f/%.0f", size.width*2, size.height*2];
        NSLog(@"kittenurl = %@",kittenUrl);
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url = [NSURL URLWithString:kittenUrl];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image.size.width>0) {
                        [loadingMessageView2 dk_loading:NO];
                        kittenImageView.image = image;
                    }
                    else {
                        [loadingMessageView2 dk_displayMessage:@"Error loading :-("];
                    }
                });
            });
        });
        
        
        // Loading text (fail)
        UIImageView *failImageView = [[UIImageView alloc] initWithFrame:CGRectMake((320-150)/2, 330, size.width, size.height)];
        failImageView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:failImageView];
        
        DKUserMessageView *failMessageView = [[DKUserMessageView alloc] init];
        failMessageView.dk_userMessageLabelTop = 40;
        failMessageView.frame = failImageView.frame;
        [self.view addSubview:failMessageView];
        
        [failMessageView dk_loading:YES spinner:NO];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSURL *url = [NSURL URLWithString:@"bogus"];
                UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url options:NSDataReadingMappedIfSafe error:nil]];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (image.size.width>0) {
                        [failMessageView dk_loading:NO];
                        failImageView.image = image;
                    }
                    else {
                        [failMessageView dk_displayMessage:@"Error loading :-("];
                    }
                });
            });
        });
    }
    return self;
}


@end
