platform :ios, “9.0”
use_frameworks!

xcodeproj 'Fhood.xcodeproj'
target :Fhood do
    
    pod 'OneSignal'
    pod 'Braintree'
    pod 'Braintree/Apple-Pay'
    pod 'Alamofire'
    pod 'Bolts'                 , :git => 'https://github.com/BoltsFramework/Bolts-ObjC.git'
    pod 'SnapKit', '~> 4.0.0'
    pod 'FBSDKCoreKit'          , :git => ‘https://github.com/facebook/facebook-ios-sdk.git'
    pod 'FBSDKLoginKit'         , :git => ‘https://github.com/facebook/facebook-ios-sdk.git'
    pod 'JGProgressHUD'	  , :git => ‘https://github.com/JonasGessner/JGProgressHUD.git'
    pod 'Parse'			  , :git => ‘https://github.com/parse-community/Parse-SDK-iOS-OSX.git'
    pod 'ParseFacebookUtilsV4'	  
    pod 'SWRevealViewController', :git => ‘https://github.com/John-Lluch/SWRevealViewController.git', :branch => ‘master’, :inhibit_warnings => true
    pod 'SMCalloutView'         , :git => ‘https://github.com/nfarina/calloutview.git', :branch => ‘master’
    pod 'coinbase-official', '~> 3.3'
end	

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      # Fix DEBUG flag which is not included by cocoapods for swift projects
      if config.name == "Debug"
          config.build_settings['OTHER_SWIFT_FLAGS'] = '$(inherited) "-DDEBUG"'
      else
          config.build_settings['SWIFT_WHOLE_MODULE_OPTIMIZATION'] = 'YES'
      end

      # We don't want frameworks to export Objective-C headers (we lose polymorphism)
      config.build_settings['SWIFT_INSTALL_OBJC_HEADER'] = 'NO'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end
pod 'OneSignal'
