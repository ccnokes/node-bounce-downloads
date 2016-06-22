#import <Cocoa/Cocoa.h>
#include <node.h>

using namespace v8;

void triggerBounce(NSString* pathToFile) {
  [[NSDistributedNotificationCenter defaultCenter] postNotificationName:@"com.apple.DownloadFileFinished" object:pathToFile];
}

// get the user's downloads directory and construct a fake path to it
// by appending "/a" to the end. This is enough to trigger a bounce
NSString* getFakeDownloadsPath() {
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, true);
  NSMutableString *downloadsPath = [paths objectAtIndex:0];
  NSString *fakePath = [NSString stringWithFormat:@"%@/%@", downloadsPath, @"a"];
  return fakePath;
}

void bounce(const FunctionCallbackInfo<Value>& args) {
  Isolate* isolate = args.GetIsolate();
  triggerBounce(getFakeDownloadsPath());
  args.GetReturnValue().Set(v8::Null(isolate));
}

void Init(Local<Object> exports, Local<Object> module) {
  NODE_SET_METHOD(module, "exports", bounce);
}

NODE_MODULE(addon, Init)
