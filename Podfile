source 'https://cdn.cocoapods.org/'

platform :ios, '15.0'
use_frameworks!
inhibit_all_warnings!

def library
  pod 'KissXML'
  pod 'KissXML/libxml_module'
  pod 'ICSMainFramework', :path => './Library/ICSMainFramework/'
  pod 'MMWormhole', '~> 2.0.0'
  pod 'KeychainAccess'
end

def tunnel
  pod 'MMWormhole', '~> 2.0.0'
end

def socket
  pod 'CocoaAsyncSocket', '~> 7.6'
end

def model
  pod 'RealmSwift', '~> 10.49'
end

target 'Potatso' do
  pod 'Aspects', :path => './Library/Aspects/'
  pod 'Cartography'
  pod 'Appirater'
  pod 'Eureka', '~> 5.3'
  pod 'MBProgressHUD'
  pod 'CallbackURLKit'
  pod 'ICDMaterialActivityIndicatorView', '~> 0.1.0'
  pod 'ICSPullToRefresh', '~> 0.4'
  pod 'Alamofire', '~> 5.8'
  pod 'ObjectMapper', '~> 4.2'
  pod 'CocoaLumberjack/Swift', '~> 3.8'
  pod 'PSOperations', '~> 2.3'
  pod 'AsyncSwift'
  tunnel
  library
  socket
  model
end

target 'PacketTunnel' do
  tunnel
  socket
end

target 'PacketProcessor' do
  socket
end

target 'TodayWidget' do
  pod 'Cartography'
  library
  socket
  model
end

target 'PotatsoLibrary' do
  library
  model
end

target 'PotatsoModel' do
  model
end

target 'PotatsoLibraryTests' do
  library
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
      config.build_settings['ENABLE_BITCODE'] = 'NO'
      config.build_settings['SWIFT_VERSION'] = '5.0'
    end
  end
end
