//
//  CompareViewController.m
//  FaceppSDK+Demo
//
//  Created by 谢霆锋 on 16/5/27.
//  Copyright © 2016年 Megvii. All rights reserved.
//

#import "CompareViewController.h"
#import "GKImagePicker.h"
#import "UIImage+Resize.h"
#import "../APIKey+APISecret.h"

@interface CompareViewController ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *picA;
@property (retain, nonatomic) IBOutlet UIImageView *picB;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (strong, nonatomic) NSString *imageA;
@property (strong, nonatomic) NSString *imageB;
@property (strong, nonatomic) NSString *tag;
@property (retain, nonatomic) IBOutlet UITextView *resultA;
@end

@implementation CompareViewController
- (IBAction)imageA:(id)sender {
    self.tag = @"A";
    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
}
- (IBAction)imageB:(id)sender {
    self.tag = @"B";
    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
}
- (IBAction)compare:(id)sender {
    
//    UIImage *test = [UIImage imageNamed:@"55.jpg"];
//    NSData *imageData = UIImageJPEGRepresentation(test, 0.1);
//    NSString *testset = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSLog(@"%@",self.imageA);
    NSLog(@"%@",self.imageB);
   FaceppResult *result = [[FaceppAPI recognition]compareWithFaceId1:self.imageA andId2:self.imageB async:NO];
    NSLog(@"%@",result.content);

}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tag = [NSString string];
    self.imageA = [NSString string];
    self.imageB = [NSString string];
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.resizeableCropArea = YES;
    self.imagePicker.delegate = self;
    NSString *API_KEY = _API_KEY;
    NSString *API_SECRET = _API_SECRET;
    
    [FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET andRegion:APIServerRegionCN];
    
    // turn on the debug mode
    [FaceppAPI setDebugMode:TRUE];
}
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if ([self.tag isEqualToString:@"A"]) {
        self.picA.image = image;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        self.imageA = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    }else{
        self.picB.image = image;
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        self.imageB = [imageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithCarriageReturn];
    }
    
    [self hideImagePicker];
}

- (void)hideImagePicker{
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [self.imagePicker.imagePickerController dismissViewControllerAnimated:YES completion:nil];
        
    }
}

# pragma mark -
# pragma mark UIImagePickerDelegate Methods

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    self.picA.image = image;
    
    if (UIUserInterfaceIdiomPad == UI_USER_INTERFACE_IDIOM()) {
        
        [self.popoverController dismissPopoverAnimated:YES];
        
    } else {
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void)dealloc {
    [_picA release];
    [_picB release];
    [_resultA release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setPicA:nil];
    [self setPicB:nil];
    [self setResultA:nil];
    [super viewDidUnload];
}
@end
