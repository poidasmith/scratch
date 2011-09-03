/*******************************************************************************
 * This program and the accompanying materials
 * are made available under the terms of the Common Public License v1.0
 * which accompanies this distribution, and is available at 
 * http://www.eclipse.org/legal/cpl-v10.html
 * 
 * Contributors:
 *     Peter Smith
 *******************************************************************************/
package org.boris.binson;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.charset.Charset;
import java.util.HashMap;
import java.util.Map;

public class BinsonCodec
{
    public static final int TYPE_NULL = 0x0;
    public static final int TYPE_TRUE = 0x1;
    public static final int TYPE_FALSE = 0x2;
    public static final int TYPE_INT64 = 0x3;
    public static final int TYPE_DOUBLE = 0x4;
    public static final int TYPE_OBJECT = 0x8;
    public static final int TYPE_ARRAY = 0x9;
    public static final int TYPE_STRING = 0xa;
    public static final int TYPE_INT32 = 0xb;
    public static final int TYPE_RAW = 0xc;

    public static final Charset UTF8 = Charset.forName("UTF-8");

    public static void encode(JSONValue val, OutputStream os) throws IOException {

    }

    public static JSONValue decode(InputStream is) throws IOException {
        return (JSONValue) decode(is, new byte[8], true);
    }

    public static Object decodeNative(InputStream is) throws IOException {
        return decode(is, new byte[8], false);
    }

    private static Object decode(InputStream is, byte[] buf, boolean jvals) throws IOException {
        int t = is.read();
        // Check that bits 5 and 6 are zero
        if ((t & 0x60) != 0)
            throw new IOException("Invalid tag: bit 5/6 non-zero");
        // Check that bits 7 and 8 are zero for fixed length types
        if ((t & 0xf8) != 0)
            throw new IOException("Invalid tag: non-zero high nibble for fixed length structure");

        boolean d = false;
        switch (t & 0xf) {
        case TYPE_NULL:
            return jvals ? JSONValue.NULL : null;
        case TYPE_TRUE:
            return jvals ? JSONValue.TRUE : true;
        case TYPE_FALSE:
            return jvals ? JSONValue.FALSE : false;
        case TYPE_DOUBLE:
            d = true;
        case TYPE_INT64:
            readAll(buf, 0, 8);
            long l = ((long) buf[7] << 56 |
                    ((long) buf[6] & 0xff) << 48 |
                    ((long) buf[5] & 0xff) << 40 |
                    ((long) buf[4] & 0xff) << 32 |
                    ((long) buf[3] & 0xff) << 24 |
                    ((long) buf[2] & 0xff) << 16 |
                    ((long) buf[1] & 0xff) << 8 |
                    ((long) buf[0] & 0xff));
            return d ? Double.longBitsToDouble(l) : l;
        case TYPE_OBJECT:
        case TYPE_ARRAY:
        case TYPE_STRING:
        case TYPE_INT32:
            int lenlen = (t & 0xc0);
            int len = 0;
            switch (lenlen) {
            case 0xd:
                len <<= 8 | is.read();
            case 0xc:
                len <<= 8 | is.read();
            case 0x4:
                len <<= 8 | is.read();
            case 0x0:
                len <<= 8 | is.read();
                break;
            }
            switch (t & 0xf) {
            case TYPE_OBJECT:
                Map values = new HashMap(len);
                for (int i = 0; i < len; i++) {
                    values.put((String) decode(is, buf, false), decode(is, buf, jvals));
                }
                return jvals ? new JSONObject((Map<String, JSONValue>) values) : values;
            case TYPE_ARRAY:
                Object[] arr = jvals ? new JSONValue[len] : new Object[len];
                for (int i = 0; i < len; i++)
                    arr[i] = decode(is, buf, jvals);
                return arr;
            case TYPE_STRING:
                byte[] b = buf.length >= len ? buf : new byte[len];
                buf = b;
                readAll(b, 0, b.length);
                String s = new String(b, UTF8);
                return jvals ? new JSONString(s) : s;
            case TYPE_INT32:
                return jvals ? new JSONInteger(len) : len;
            }
        default:
            throw new IOException("Invalid type encountered: " + (t & 0x0f));
        }
    }

    private static void readAll(byte[] b, int off, int len) throws IOException {

    }
}
