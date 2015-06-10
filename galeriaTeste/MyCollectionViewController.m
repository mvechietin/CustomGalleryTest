//
//  MyCollectionViewController.m
//  galeriaTeste
//
//  Created by Matheus G. Vechietin on 09/06/15.
//  Copyright (c) 2015 Matheus G. Vechietin. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "RMGalleryTransition.h"
#import "MyGalleryViewController.h"

#define RM_NAVIGATION_CONTROLLER 1

@interface MyCollectionViewController () <UIViewControllerTransitioningDelegate, RMGalleryTransitionDelegate>

@property (nonatomic, strong) NSMutableArray *imgArray;

@end

@implementation MyCollectionViewController

#pragma mark View Controller Life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgArray = [[NSMutableArray alloc] init];
    self.imgArray = [@[@"foto1.jpg", @"foto2.jpg", @"foto3.jpg", @"foto4.jpg", @"foto5.jpg", @"foto6.jpg", @"foto7.jpg", @"foto8.jpg", @"foto9.jpg", @"foto10.jpg", @"foto11.jpg", @"foto12.jpg", @"foto13.jpg", @"foto14.jpg", @"foto15.jpg", @"foto16.jpg"] mutableCopy];
    
    self.title = @"Custom Gallery";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)presentGalleryWithImageAtIndex:(NSUInteger)index
{
    MyGalleryViewController *galleryViewController = [MyGalleryViewController new];
    galleryViewController.galleryIndex = index;
    
    galleryViewController.count = self.imgArray.count;
    
    //Present Gallery on ViewController
    UIViewController *viewControllerToPresent;
#if RM_NAVIGATION_CONTROLLER
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:galleryViewController];
    navigationController.toolbarHidden = NO;
    
    // When using a navigation controller the tap gesture toggles the navigation bar and toolbar. A way to dismiss the gallery must be provided.
    galleryViewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissGallery:)];
    
    viewControllerToPresent = navigationController;
#else
    viewControllerToPresent = galleryViewController;
#endif
    
    viewControllerToPresent.transitioningDelegate = self;
    viewControllerToPresent.modalPresentationStyle = UIModalPresentationFullScreen;
    
    [self presentViewController:viewControllerToPresent animated:YES completion:nil];
}


#pragma mark Actions
- (void)dismissGallery:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.imgArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell" forIndexPath:indexPath];
    
    UIImageView *recipeImageView = (UIImageView *)[cell viewWithTag:20];
    recipeImageView.image = [UIImage imageNamed:[self.imgArray objectAtIndex:indexPath.row]];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"O Index é: %ld", (long)indexPath.row);
    [self presentGalleryWithImageAtIndex:indexPath.row];
}


#pragma mark UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    RMGalleryTransition *transition = [RMGalleryTransition new];
    transition.delegate = self;
    return transition;
}


#pragma mark RMGalleryTransitionDelegate

- (UIImageView*)galleryTransition:(RMGalleryTransition*)transition transitionImageViewForIndex:(NSUInteger)index
{
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.imgArray objectAtIndex:index]]];
    return imgv;
}

- (CGSize)galleryTransition:(RMGalleryTransition*)transition estimatedSizeForIndex:(NSUInteger)index
{ // If the transition image is different than the one displayed in the gallery we need to provide its size
    
    UIImageView *imgv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[self.imgArray objectAtIndex:index]]];
    
    UIImageView *imageView = imgv;
    const CGSize thumbnailSize = imageView.image.size;
    
    // In this example the final images are about 25 times bigger than the thumbnail
    const CGSize estimatedSize = CGSizeMake(thumbnailSize.width * 25, thumbnailSize.height * 25);
    return estimatedSize;
}

@end
