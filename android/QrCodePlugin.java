package com.stanleyidesis.toastyplugintest;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import android.content.Intent;
import android.content.Context;

import android.content.res.Resources;
import android.graphics.Bitmap;

import android.graphics.Canvas;

import android.graphics.Matrix;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Build;
import android.support.v4.content.ContextCompat;
import android.support.v4.content.FileProvider;
import android.support.v4.graphics.drawable.DrawableCompat;
import android.util.Log;

import java.io.File;
import java.io.FileOutputStream;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;

public class QrCodePlugin extends CordovaPlugin {
    private final static int WIDTH=500;
    private static int WHITE = 0xFFFFFFFF;
    private static int BLACK = 0xFF000000;
    @Override
    public boolean execute(String action, JSONArray args,
                           final CallbackContext callbackContext) {
        // Verify that the user sent a 'show' action
        if (!action.equals("shareqr")) {
            callbackContext.error("\"" + action + "\" is not a recognized action.");
            return false;
        }
        String message;
        String subject;
        String qr;
        try {
            JSONObject options = args.getJSONObject(0);
            message = options.getString("message");
            subject = options.getString("subject");
            qr = options.getString("qr");
        } catch (JSONException e) {
            callbackContext.error("Error encountered: " + e.getMessage());
            return false;
        }
        try {
            if(!generateQR(message,subject,qr)){
                callbackContext.error("Error generate qr" );
            }
        } catch (Exception e) {
            callbackContext.error("Error generate qr: " + e.getMessage());
            return false;
        }
        PluginResult pluginResult = new PluginResult(PluginResult.Status.OK);
        callbackContext.sendPluginResult(pluginResult);
        return true;
    }

    private Boolean generateQR(String message, String subject, String Qr) throws Exception{
        Context context = this.cordova.getActivity().getApplicationContext();
        Bitmap bitmapQR = encodeAsBitmap(Qr);
        Bitmap bitmapIcon = getBitmapFromVectorDrawable(context);
        Bitmap bitmapFinal = overlay(bitmapQR,Bitmap.createScaledBitmap(bitmapIcon, 80  , 80, false));
        if(storeImage(context, bitmapFinal)){
            shareQR(context, message, subject);
            return true;
        }else{
            return false;
        }
    }

    private  Bitmap getBitmapFromVectorDrawable(Context context) {
        Resources activityRes = this.cordova.getActivity().getResources();
        int backResId = activityRes.getIdentifier("ic_bancolombia", "drawable", this.cordova.getActivity().getPackageName());
        Drawable drawable = ContextCompat.getDrawable(context, backResId);
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            drawable = (DrawableCompat.wrap(drawable)).mutate();
        }
        Bitmap bitmap = Bitmap.createBitmap(drawable.getIntrinsicWidth(), drawable.getIntrinsicHeight(), Bitmap.Config.ARGB_8888);
        Canvas canvas = new Canvas(bitmap);
        drawable.setBounds(0, 0, canvas.getWidth(), canvas.getHeight());
        drawable.draw(canvas);
        return bitmap;
    }

    private void shareQR(Context context, String message,  String subject) {
        Intent sharingIntent = new Intent(Intent.ACTION_SEND);
        File file = getOutputMediaFile(context);
        Uri phototUri= FileProvider.getUriForFile(context, cordova.getContext().getPackageName()+".provider",file);
        sharingIntent.setType("image/*");
        sharingIntent.putExtra(Intent.EXTRA_STREAM, phototUri);
        sharingIntent.putExtra(Intent.EXTRA_TEXT, message);
        sharingIntent.putExtra(Intent.EXTRA_SUBJECT, subject);
        this.cordova.getActivity().startActivity(Intent.createChooser(sharingIntent, "Bancolombia App Personas"));
    }

    private static Bitmap overlay(Bitmap bmp1, Bitmap bmp2) {
        Bitmap bmOverlay = Bitmap.createBitmap(bmp1.getWidth(), bmp1.getHeight(), bmp1.getConfig());
        Canvas canvas = new Canvas(bmOverlay);
        int centreX = (canvas.getWidth()  - bmp2.getWidth()) /2;
        int centreY = (canvas.getHeight()  - bmp2.getHeight()) /2;
        canvas.drawBitmap(bmp1, new Matrix(), null);
        canvas.drawBitmap(bmp2, centreX, centreY, null);
        return bmOverlay;
    }

    private Bitmap encodeAsBitmap(String QrInfo) throws WriterException {
        QRCodeWriter writer = new QRCodeWriter();
        BitMatrix bitMatrix = writer.encode(QrInfo, BarcodeFormat.QR_CODE, WIDTH, WIDTH);
        int width = bitMatrix.getWidth();
        int height = bitMatrix.getHeight();
        Bitmap bmp = Bitmap.createBitmap(width, height, Bitmap.Config.RGB_565);
        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                bmp.setPixel(x, y, bitMatrix.get(x, y) ? BLACK : WHITE);
            }
        }
        return bmp;
    }

    private Boolean storeImage(Context context, Bitmap image)throws Exception {
        File pictureFile = this.getOutputMediaFile(context);
        if (pictureFile == null) {
            Log.e("error","Error creating media file");
            return false;
        }
        FileOutputStream fos = new FileOutputStream(pictureFile);
        image.compress(Bitmap.CompressFormat.PNG, 100, fos);
        fos.flush();
        fos.close();
        return  true;
    }

    private File getOutputMediaFile(Context context) {
        File mediaStorageDir = new File(String.valueOf(context.getExternalFilesDir(null)));
        if (!mediaStorageDir.exists()) {
            if (!mediaStorageDir.mkdirs()) {
                return null;
            }
        }
        return new File(mediaStorageDir.getPath() + File.separator + "qr.png");
    }
}