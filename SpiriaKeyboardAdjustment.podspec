#
# Be sure to run `pod lib lint SpiriaKeyboardAdjustment.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "SpiriaKeyboardAdjustment"
  s.version          = "1.0.4"
  s.summary          = "Adjust the view controller main view frame when the keyboard appears and disappears."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description      = 'At some point every mobile developer has to deal with the struggle of the keybard and the screen layout.
Usually you have only a few screens so you probably just copy/paste the code to do it (register to keyboard notifications, and change the frame of the main view or just a constraint to the bottom of the main view). This extension does all those things for you :), automatically register to the notifications and when the keyboard appears it changes the frame of the main view or optionally modify the value of a constraint (bottom constraint to the main view). You only need to install the pod and import the library on your view controller, that is all.
If you do not want to resize the view on a given view controller but you already have this library included just override the property shouldAutoAdjustScreen and return NO.
If you want to use a constraint to the main view instead of resize the controller view, you can assign the constraint from the UIBuilder to the adjustBottomConstraint property, or just implements its getter method with the constraint you want.'

  s.homepage         = "https://github.com/rordeix/SpiriaKeyboardAdjustment"
  s.license          = 'MIT'
  s.author           = { "rordeix" => "rordeix@spiria.com.uy" }
  s.source           = { :git => "https://github.com/rordeix/SpiriaKeyboardAdjustment.git", :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
end
