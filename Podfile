# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'

target 'ExpressBusTimetable' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # ignore all warnings from all pods
  inhibit_all_warnings!

  # Pods for ExpressBusTimetable
  pod 'CSV.swift', '~> 1.1'
  pod 'ActionSheetPicker-3.0'
  pod 'Firebase/Core'
  pod 'Firebase/AdMob'
  pod 'Firebase/Crash'
  pod 'XCGLogger'
  pod "AAMFeedback"
  pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git'
  pod 'SwiftDate', '~> 4.1.6'
end

# Acknowledgements 
post_install do | installer |
require 'fileutils'

FileUtils.cp_r('Pods/Target Support Files/Pods-ExpressBusTimetable/Pods-ExpressBusTimetable-acknowledgements.plist', 'ExpressBusTimetable/Resources/Settings.bundle/Acknowledgements.plist', :remove_destination => true)

end
