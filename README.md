# cordova_plugin_qrcode
cordova plugin qr code
## Installation

    cordova plugin add cordova_plugin_qrcode

## API

### generate qrcode

    window.plugins.qrCodePlugin.shareqr(message,subject,qr, onSuccess, onFailure)
- **onSuccess**: function (s) {...} _Callback for successful scan._
- **onFailure**: function (s) {...} _Callback for cancelled scan or error._

Status:

- Android: DONE
- iOS: DONE
