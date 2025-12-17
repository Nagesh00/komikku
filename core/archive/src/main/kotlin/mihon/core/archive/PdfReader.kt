package mihon.core.archive

import android.content.Context
import android.graphics.Bitmap
import android.os.ParcelFileDescriptor
import com.shockwave.pdfium.PdfiumCore
import java.io.ByteArrayOutputStream
import java.io.Closeable
import java.io.InputStream

/**
 * Wrapper over PdfiumCore to load and render PDF files.
 */
class PdfReader(
    private val context: Context,
    private val pfd: ParcelFileDescriptor,
) : Closeable {

    private val pdfiumCore = PdfiumCore(context)
    private var pdfDocument = pdfiumCore.newDocument(pfd)

    /**
     * Returns the number of pages in the PDF document.
     */
    fun getPageCount(): Int {
        return pdfiumCore.getPageCount(pdfDocument)
    }

    /**
     * Returns an input stream for the rendered page at the given index.
     * Pages are rendered as PNG images.
     *
     * @param pageIndex Zero-based page index
     * @return InputStream containing the rendered page as a PNG image
     */
    fun getPageInputStream(pageIndex: Int): InputStream {
        pdfiumCore.openPage(pdfDocument, pageIndex)

        val width = pdfiumCore.getPageWidth(pdfDocument, pageIndex)
        val height = pdfiumCore.getPageHeight(pdfDocument, pageIndex)

        // Create a bitmap to render the page
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)

        // Render the page onto the bitmap
        pdfiumCore.renderPageBitmap(pdfDocument, bitmap, pageIndex, 0, 0, width, height)

        // Convert bitmap to input stream
        val outputStream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, outputStream)
        bitmap.recycle()

        return outputStream.toByteArray().inputStream()
    }

    override fun close() {
        try {
            pdfiumCore.closeDocument(pdfDocument)
        } catch (e: Exception) {
            // Ignore
        }
        try {
            pfd.close()
        } catch (e: Exception) {
            // Ignore
        }
    }
}
