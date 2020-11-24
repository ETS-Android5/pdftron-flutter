#import <Flutter/Flutter.h>
#import <PDFNet/PDFNet.h>
#import <Tools/Tools.h>

NS_ASSUME_NONNULL_BEGIN

@interface PTFlutterViewController : PTDocumentViewController

@property (nonatomic, strong) FlutterResult openResult;
@property (nonatomic, strong) PdftronFlutterPlugin* plugin;

@property (nonatomic) BOOL local;
@property (nonatomic) BOOL needsDocumentLoaded;
@property (nonatomic) BOOL needsRemoteDocumentLoaded;
@property (nonatomic) BOOL documentLoaded;

// viewer options

@property (nonatomic, assign, getter=isAnnotationPermissionCheckEnabled) BOOL annotationPermissionCheckEnabled;

- (void)initViewerSettings;
- (void)applyViewerSettings;

@property (nonatomic, copy, nullable) NSArray<NSString *> *overrideBehavior;

@end

@interface FLThumbnailsViewController : PTThumbnailsViewController

@end

NS_ASSUME_NONNULL_END
