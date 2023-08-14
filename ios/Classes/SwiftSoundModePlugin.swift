import Flutter
import UIKit
import Mute

public class SwiftSoundModePlugin: NSObject, FlutterPlugin {
  private var str = "unknown"

  public static func register(with registrar: FlutterPluginRegistrar) {
    let channelName = "ch.kada.sound_mode"
    let channel = FlutterMethodChannel(name: channelName, binaryMessenger: registrar.messenger())
    let instance = SwiftSoundModePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)

    Mute.shared.checkInterval = 0.5

    let eventChannel = FlutterEventChannel(name: "\(channelName).stream_handler", binaryMessenger: registrar.messenger())
    eventChannel.setStreamHandler(SoundModeStreamHandler())
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
      switch call.method {
        case "getRingerMode":

             Mute.shared.notify = { 
               [weak self] m in
               self?.str = m ? "vibrate" : "normal"
              }

          result(self.str);
        default:
          break;
      }
  }
}

class SoundModeStreamHandler: NSObject, FlutterStreamHandler {
    func onListen(withArguments arguments: Any?, eventSink events: @escaping FlutterEventSink) -> FlutterError? {
        Mute.shared.notify = { events($0 ? "vibrate" : "normal") }
        return nil
    }

    func onCancel(withArguments arguments: Any?) -> FlutterError? {
        return nil
    }
}
