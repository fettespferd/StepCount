package de.stepCalc.android.app

import android.content.Context
import androidx.multidex.MultiDex
import io.flutter.app.FlutterApplication

class StepCalcApp: FlutterApplication() {
  override fun attachBaseContext(base: Context) {
    super.attachBaseContext(base)
    MultiDex.install(this)
  }
}
