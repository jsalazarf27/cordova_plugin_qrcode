// Empty constructor
function QrCodePlugin() {}

// The function that passes work along to native shells
// Message, subject and qr are strings
QrCodePlugin.prototype.shareqr = function(message, subject, qr, successCallback, errorCallback) {
    var options = {};
    options.message = message;
    options.subject = subject;
    options.qr = qr;
    cordova.exec(successCallback, errorCallback, 'QrCodePlugin', 'shareqr', [options]);
}

// Installation constructor that binds QrCodePlugin to window
QrCodePlugin.install = function() {
    if (!window.plugins) {
        window.plugins = {};
    }
    window.plugins.qrCodePlugin = new QrCodePlugin();
    return window.plugins.qrCodePlugin;
};
cordova.addConstructor(QrCodePlugin.install);