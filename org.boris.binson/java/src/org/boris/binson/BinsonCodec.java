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
        if (val == null) {
            os.write(TYPE_NULL);
            return;
        }

        boolean d = false;
        int len = 0;
        Map<String, JSONValue> valo = null;
        JSONValue[] vala = null;
        byte[] vals = null;
        switch (val.type) {
        case TYPE_NULL:
            os.write(TYPE_NULL);
            return;
        case TYPE_TRUE:
            os.write(TYPE_TRUE);
            return;
        case TYPE_FALSE:
            os.write(TYPE_FALSE);
            return;
        case TYPE_DOUBLE:
            d = true;
        case TYPE_INT64:
            long l = d ? Double.doubleToLongBits(((JSONDouble) val).value) : ((JSONLong) val).value;
            os.write(d ? TYPE_DOUBLE : TYPE_INT64);
            os.write((int) (l & 0xff));
            os.write((int) (l >> 8 & 0xff));
            os.write((int) (l >> 16 & 0xff));
            os.write((int) (l >> 24 & 0xff));
            os.write((int) (l >> 32 & 0xff));
            os.write((int) (l >> 40 & 0xff));
            os.write((int) (l >> 48 & 0xff));
            os.write((int) (l >> 56 & 0xff));
            return;
        case TYPE_OBJECT:
            valo = ((JSONObject) val).values;
            len = valo == null ? 0 : valo.size();
            break;
        case TYPE_ARRAY:
            vala = ((JSONArray) val).values;
            len = vala == null ? 0 : vala.length;
            break;
        case TYPE_INT32:
            len = ((JSONInteger) val).value;
            break;
        case TYPE_STRING:
            String s = ((JSONString) val).value;
            if (s != null) {
                vals = s.getBytes(UTF8);
                len = vals.length;
            }
            break;
        }

        // Calculate the length of our length field (or int32)
        int lenlen = (len & 0xff000000) != 0 ? 4 : (len & 0x00ff0000) != 0 ? 3 : (len & 0x0000ff00) != 0 ? 2 : 1;

        // Write out the type combined with the length length
        os.write((lenlen - 1) << 6 | val.type);

        // Write out the length (or int32);
        switch (lenlen) {
        case 1:
            os.write(len);
            break;
        case 2:
            os.write(len);
            os.write(len >> 8);
            break;
        case 3:
            os.write(len);
            os.write(len >> 8);
            os.write(len >> 16);
            break;
        case 4:
            os.write(len);
            os.write(len >> 8);
            os.write(len >> 16);
            os.write(len >> 24);
            break;
        }

        if (len > 0) {
            switch (val.type) {
            case TYPE_OBJECT:
                for (String s : valo.keySet()) {
                    encode(new JSONString(s), os);
                    encode(valo.get(s), os);
                }
                break;
            case TYPE_ARRAY:
                for (JSONValue v : vala)
                    encode(v, os);
                break;
            case TYPE_STRING:
                os.write(vals);
                break;
            case TYPE_INT32:
                break;
            }
        }
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
        if ((t & 0x30) != 0)
            throw new IOException("Invalid tag: bit 5/6 non-zero");
        // Check that bits 7 and 8 are zero for fixed length types
        if ((t & 0xf8) == 0 && (t & 0xc0) != 0)
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
            readAll(is, buf, 8);
            long l = ((((long) buf[7]) << 56) |
                    ((((long) buf[6]) & 0xff) << 48) |
                    ((((long) buf[5]) & 0xff) << 40) |
                    ((((long) buf[4]) & 0xff) << 32) |
                    ((((long) buf[3]) & 0xff) << 24) |
                    ((((long) buf[2]) & 0xff) << 16) |
                    ((((long) buf[1]) & 0xff) << 8) |
                    (((long) buf[0]) & 0xff));
            return jvals ? (d ? new JSONDouble(Double.longBitsToDouble(l)) : new JSONLong(l)) : (d ? Double
                    .longBitsToDouble(l) : l);
        case TYPE_OBJECT:
        case TYPE_ARRAY:
        case TYPE_STRING:
        case TYPE_INT32:
            int lenlen = (t & 0xc0);
            int len = 0;
            switch (lenlen) {
            case 0xc0:
                len = is.read() | is.read() << 8 | is.read() << 16 | is.read() << 24;
                break;
            case 0x80:
                len = is.read() | is.read() << 8 | is.read() << 16;
                break;
            case 0x40:
                len = is.read() | is.read() << 8;
                break;
            case 0x00:
                len = is.read();
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
                return jvals ? new JSONArray((JSONValue[]) arr) : arr;
            case TYPE_STRING:
                byte[] b = buf.length >= len ? buf : new byte[len];
                buf = b;
                readAll(is, b, len);
                String s = new String(b, 0, len, UTF8);
                return jvals ? new JSONString(s) : s;
            case TYPE_INT32:
                return jvals ? new JSONInteger(len) : len;
            }
        default:
            throw new IOException("Invalid type encountered: " + (t & 0x0f));
        }
    }

    private static void readAll(InputStream is, byte[] b, int len) throws IOException {
        int total = 0;
        while (total < len) {
            int received = is.read(b, total, len - total);
            if (received < 0)
                throw new IOException("EOF encountered");
            total += received;
        }
    }
}
