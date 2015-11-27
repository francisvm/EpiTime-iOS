def shared_pods
  pod 'XMLDictionary', :git => 'https://github.com/nicklockwood/XMLDictionary.git'
end

def iphone
  platform :ios, "9.0"
  shared_pods
  pod 'FVCustomAlertView', '~> 0.3.3'
end

def watch
  platform :watchos, '2.0'
  shared_pods
end

target 'EpiTime' do
  iphone
end

target 'EpiTimeTests' do
  iphone
end

target 'EpiTimeWidget' do
  platform :ios, "9.0"
  shared_pods
end

target 'EpiTime WatchKit Extension' do
  watch
end

target 'EpiTime WatchKit App' do
  watch
end
