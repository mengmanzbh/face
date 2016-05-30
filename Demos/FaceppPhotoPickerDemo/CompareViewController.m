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
#import <BmobSDK/Bmob.h>


@interface CompareViewController ()<GKImagePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *picA;
@property (retain, nonatomic) IBOutlet UIImageView *picB;
@property (nonatomic, strong) UIPopoverController *popoverController;
@property (nonatomic, strong) GKImagePicker *imagePicker;
@property (strong, nonatomic) NSString *face_idA;
@property (strong, nonatomic) NSString *face_idB;
@property (strong, nonatomic) NSString *imageB;
@property (strong, nonatomic) NSString *tag;
@property (retain, nonatomic) IBOutlet UITextView *resultA;
@end

@implementation CompareViewController

- (IBAction)imageA:(id)sender {
    self.tag = @"A";
//    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
    
    
    self.face_idA = [NSString string];
    [[FaceppAPI person] deleteWithPersonName:@"AAA" orPersonId:nil];
    FaceppResult *detectLocalFileResult = [[FaceppAPI detection] detectWithURL:@"http://d.hiphotos.baidu.com/baike/c0%3Dbaike80%2C5%2C5%2C80%2C26/sign=ea7506084ec2d562e605d8bf8678fb8a/72f082025aafa40f18b666b5aa64034f78f01961.jpg"
                                                                   orImageData: nil];
    if ([detectLocalFileResult success]) {
        NSUInteger face_count = [[detectLocalFileResult content][@"face"] count];
        if (face_count > 0) {
            self.face_idA = [detectLocalFileResult content][@"face"][0][@"face_id"];
            
            FaceppResult *personResult = [[FaceppAPI person] createWithPersonName:@"AAA"
                                                                        andFaceId: [NSArray arrayWithObject:self.face_idA]
                                                                           andTag: nil
                                                                       andGroupId: nil
                                                                      orGroupName: nil];
            if ([personResult success]) {
                NSString *person_id = [personResult content][@"person_id"];
            }
        }
    } else {
        // something wrong
        FaceppError *error = [detectLocalFileResult error];
        NSLog(@"Error message: %@", [error message]);
    }

}
- (IBAction)imageB:(id)sender {
    self.tag = @"B";
//    [self presentModalViewController:self.imagePicker.imagePickerController animated:YES];
    
    self.face_idB = [NSString string];
    [[FaceppAPI person] deleteWithPersonName:@"BBB" orPersonId:nil];
    FaceppResult *detectLocalFileResult = [[FaceppAPI detection] detectWithURL:@"http://n.sinaimg.cn/fashion/20151130/Nhgi-fxmazmy2288211.jpg"
                                                                   orImageData: nil];
    if ([detectLocalFileResult success]) {
        NSUInteger face_count = [[detectLocalFileResult content][@"face"] count];
        if (face_count > 0) {
            self.face_idB = [detectLocalFileResult content][@"face"][0][@"face_id"];
            
            FaceppResult *personResult = [[FaceppAPI person] createWithPersonName:@"BBB"
                                                                        andFaceId: [NSArray arrayWithObject:self.face_idA]
                                                                           andTag: nil
                                                                       andGroupId: nil
                                                                      orGroupName: nil];
            if ([personResult success]) {
                NSString *person_id = [personResult content][@"person_id"];
            }
        }
    } else {
        // something wrong
        FaceppError *error = [detectLocalFileResult error];
        NSLog(@"Error message: %@", [error message]);
    }

}
- (IBAction)compare:(id)sender {
       FaceppResult *result = [[FaceppAPI recognition]compareWithFaceId1:self.face_idA andId2:self.face_idB async:NO];
    
    NSLog(@"%@",[result content][@"similarity"]);
    self.resultA.text = [NSString stringWithFormat:@"相似度%@",[result content][@"similarity"]];
}




- (NSString*) getTraningURLme:(int) index {
    return [NSString stringWithFormat:@"http://121.42.182.100/%d.jpg", index+1];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tag = [NSString string];
    self.imagePicker = [[GKImagePicker alloc] init];
    self.imagePicker.imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    self.imagePicker.resizeableCropArea = YES;
    self.imagePicker.delegate = self;
    NSString *API_KEY = _API_KEY;
    NSString *API_SECRET = _API_SECRET;
    
    [FaceppAPI initWithApiKey:API_KEY andApiSecret:API_SECRET andRegion:APIServerRegionCN];
    
    // turn on the debug mode
    [FaceppAPI setDebugMode:TRUE];
    
    
//    NSBundle    *bundle = [NSBundle mainBundle];
//    NSString *fileString = [bundle pathForResource:@"55" ofType:@"jpg"];
//    
//    BmobObject *obj = [[BmobObject alloc] initWithClassName:@"face"];
//    BmobFile *file1 = [[BmobFile alloc] initWithFilePath:fileString];
//    [file1 saveInBackground:^(BOOL isSuccessful, NSError *error) {
//        //如果文件保存成功，则把文件添加到filetype列
//        if (isSuccessful) {
//            [obj setObject:file1  forKey:@"face"];
//            [obj saveInBackground];
//            //打印file文件的url地址
//            NSLog(@"file1 url %@",file1.url);
//        }else{
//            //进行处理
//        }
//    }];

    
}
# pragma mark GKImagePicker Delegate Methods

- (void)imagePicker:(GKImagePicker *)imagePicker pickedImage:(UIImage *)image{
    if ([self.tag isEqualToString:@"A"]) {
        self.picA.image = image;
        
    }else{
        self.picB.image = image;
        
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
