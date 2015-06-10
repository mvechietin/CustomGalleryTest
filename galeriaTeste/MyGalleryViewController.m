//
//  MyGalleryViewController.m
//  galeriaTeste
//
//  Created by Matheus G. Vechietin on 09/06/15.
//  Copyright (c) 2015 Matheus G. Vechietin. All rights reserved.
//

#import "MyGalleryViewController.h"

@interface MyGalleryViewController () <RMGalleryViewDataSource, RMGalleryViewDelegate>

@end

@implementation MyGalleryViewController

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.galleryView.galleryDataSource = self;
    self.galleryView.galleryDelegate = self;
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(barButtonAction:)];
    self.toolbarItems = @[barButton];
    
    UIPinchGestureRecognizer *gesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchDetected:)];
    gesture.delegate = self;
    [self.galleryView addGestureRecognizer:gesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - RMGalleryViewDataSource
- (void)galleryView:(RMGalleryView*)galleryView imageForIndex:(NSUInteger)index completion:(void (^)(UIImage *))completionBlock
{
    // Typically images will be loaded asynchonously. To simulate this we resize the image in background.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *name = [NSString stringWithFormat:@"foto%ld.jpg", (long)index + 1];
        UIImage *image = [UIImage imageNamed:name];
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            completionBlock(image);
        });
    });
}

- (NSUInteger)numberOfImagesInGalleryView:(RMGalleryView*)galleryView
{
    return self.count;
}


#pragma mark - RMGalleryViewDelegate
- (void)galleryView:(RMGalleryView*)galleryView didChangeIndex:(NSUInteger)index
{
    [self setTitleForIndex:index];
}


#pragma mark Toolbar
- (void)barButtonAction:(UIBarButtonItem*)barButtonItem
{
    RMGalleryView *galleryView = self.galleryView;
    const NSUInteger index = galleryView.galleryIndex;
    RMGalleryCell *galleryCell = [galleryView galleryCellAtIndex:index];
    UIImage *image = galleryCell.image;
    if (!image) return;
    
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[image] applicationActivities:nil];
    [self presentViewController:activityViewController animated:YES completion:nil];
}


#pragma mark Utils
- (void)setTitleForIndex:(NSUInteger)index
{
    const NSUInteger count = [self numberOfImagesInGalleryView:self.galleryView];
    self.title = [NSString stringWithFormat:@"%ld of %ld", (long)index + 1, (long)count];
}

#pragma mark Gesture to leave gallery
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

- (void)pinchDetected:(UIPinchGestureRecognizer *)pinchRecognizer
{
    if (pinchRecognizer.scale < 0.09) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
