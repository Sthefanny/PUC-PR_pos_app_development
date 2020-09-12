package com.example.aula07download

import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.os.AsyncTask
import androidx.appcompat.app.AppCompatActivity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.widget.ImageView
import android.widget.ProgressBar
import kotlinx.android.synthetic.main.activity_main.*
import java.net.HttpURLConnection
import java.net.URL

class MainActivity : AppCompatActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_main)
    }

    fun btnDownloadOnClick(view: View) {
        TaskDownloadImage(imgPapaiPig, imgPepaPig, progress).execute(
                "http://bepid.hospedagemdesites.ws/images/papaipig.png",
                "http://bepid.hospedagemdesites.ws/images/pepa.png"
        )
    }

    class TaskDownloadImage(var imgPapaiPig: ImageView, var imgPepaPig: ImageView, var progress: ProgressBar) : AsyncTask<String, Int, List<Bitmap>>() {
        override fun doInBackground(vararg params: String?): List<Bitmap> {
            var bitmaps = mutableListOf<Bitmap>()

            params[0]?.let {
                val img1 = downloadImage(it)
                img1?.let {
                    bitmaps.add(img1)
                }
            }

            publishProgress(50)

            params[1]?.let {
                val img2 = downloadImage(it)
                img2?.let {
                    bitmaps.add(img2)
                }
            }

            publishProgress(100)

            return bitmaps
        }

        fun downloadImage(url: String): Bitmap? {
            var bitmap: Bitmap? = null

            var url = URL(url)
            val connection: HttpURLConnection = url.openConnection() as HttpURLConnection

            try {
                connection.connect()
                val inputStream = connection.inputStream
                bitmap = BitmapFactory.decodeStream(inputStream)
                inputStream.close()
            }
            catch (e: Exception) {
                Log.d("Error!", e.localizedMessage)
            }
            finally {
                connection.disconnect()
            }

            return bitmap
        }

        override fun onProgressUpdate(vararg values: Int?) {
            super.onProgressUpdate(*values)

            values[0]?.let {
                progress.progress = it
            }
        }

        override fun onPostExecute(bitmaps: List<Bitmap>?) {
            super.onPostExecute(bitmaps)

            if (bitmaps!!.size > 0) {
                imgPapaiPig.setImageBitmap(bitmaps[0])

                if (bitmaps!!.size > 1) {
                    imgPepaPig.setImageBitmap(bitmaps[1])
                }
            }
        }

    }
}