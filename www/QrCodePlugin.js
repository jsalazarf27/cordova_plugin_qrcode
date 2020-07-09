//**
/**
 * © TODO1 SERVICES, INC. (‘TODO1’) All rights reserved, 2000, 2018.
 *
 *  This work is protected by the United States of America copyright laws.
 *
 *  All information contained herein is and remains the property of
 *  TODO1 [and its suppliers, if any] .
 *  Dissemination of this information or reproduction of this material
 *  is not permitted unless prior written consent is obtained
 *  from TODO1 SERVICES, INC.
 *
 *  This work is protected by the United States of America copyright laws.
 *
 *  All information contained herein is and remains the property of
 *  TODO1 [and its suppliers, if any] .
 *  Dissemination of this information or reproduction of this material
 *  is not permitted unless prior written consent is obtained
 *  from TODO1 SERVICES, INC.
 */
function QrCodePlugin() {}

// The function that passes work along to native shells
// Message, subject and qr are strings
QrCodePlugin.prototype.shareqr = function(message, subject, qr, successCallback, errorCallback) {
    var options = {}
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