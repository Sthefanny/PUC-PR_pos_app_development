package br.com.sthefanny.jogo

import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Canvas
import android.graphics.Rect
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.MotionEvent
import android.view.View
import java.lang.Exception
import java.util.*

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val screen = Screen(this)
        setContentView(screen)
    }

    class Screen(context: Context) : View(context), View.OnTouchListener {

        private var rnd: Random
        private var src: Rect? = null
        private var dst: Rect? = null

        private var r = 0
        private var g = 0
        private var b = 0

        private var x = 100
        private var y = 100

        private var startTime: Long
        private var animTime = 0.0f
        private var frame = 0

        private var bat: Bitmap? = null

        init {
            rnd = Random()
            startTime = System.nanoTime()
            src = Rect(0, 0, 32, 32)
            dst = Rect(x, y, x + 128, y + 128)

            setOnTouchListener(this)

            try {
                val inputStream = context.assets.open("bat.png")
                bat = BitmapFactory.decodeStream(inputStream)
                inputStream.close()
            }
            catch (e: Exception) {
                Log.d("Jogo!", e.localizedMessage)
            }
        }

        override fun onDraw(canvas: Canvas?) {
            super.onDraw(canvas)

            val canvas = canvas ?: return
            val bat = bat ?: return

            val elapsedTime = (System.nanoTime() - startTime) / 1000000.0f
            startTime = System.nanoTime()

            animTime += elapsedTime

            if (animTime > 100) {
                animTime = 0.0f

                src = Rect(frame * 32, 0, frame * 32 + 32, 32)
                frame++
                if (frame == 4) frame = 0
//                r = rnd.nextInt(256)
//                g = rnd.nextInt(256)
//                b = rnd.nextInt(256)
            }

//            canvas.drawRGB(r, g, b)

//            canvas.drawBitmap(bat, 100.0f, 100.0f, null)
            dst = Rect(x - 64, y - 64, x + 64, y + 64)
            canvas.drawBitmap(bat, src, dst!!, null)

            invalidate()
        }

        override fun onTouch(v: View?, event: MotionEvent?): Boolean {
            val e = event ?: return false

            if (e.action == MotionEvent.ACTION_DOWN) {
                x = e.x.toInt()
                y = e.y.toInt()
            }

            return true
        }
    }
}