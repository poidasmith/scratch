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

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.util.Arrays;
import java.util.HashMap;

public class Test
{
    public static void main(String[] args) throws Exception {
        // dump(dump(new JSONInteger(0xff000000)));
        // dump(new JSONInteger(0xc0));
        JSONObject jo = new JSONObject(new HashMap<String, JSONValue>());
        jo.values.put("hello", new JSONString("world"));
        jo.values.put("b2", JSONValue.TRUE);
        jo.values.put("b1", JSONValue.FALSE);
        jo.values.put("d", new JSONDouble(1444.5566));
        jo.values.put("i1", new JSONInteger(0x000000ff));
        jo.values.put("i2", new JSONInteger(0x0000ff00));
        jo.values.put("i3", new JSONInteger(0x00ff0000));
        jo.values.put("i4", new JSONInteger(0xff000000));
        jo.values.put("arr1", new JSONArray(new JSONValue[] { JSONValue.TRUE, null, new JSONLong(1245345345345l) }));
        JSONObject jo2 = (JSONObject) dump(dump(jo));
        System.out.println(jo2);
        // dump(new JSONString("hello there this is a short string of sorts"));
    }

    public static JSONValue dump(JSONValue v) throws Exception {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        BinsonCodec.encode(v, bos);
        byte[] b = bos.toByteArray();
        HexDump.dump(b);
        JSONValue v2 = BinsonCodec.decode(new ByteArrayInputStream(b));
        ByteArrayOutputStream bos2 = new ByteArrayOutputStream();
        BinsonCodec.encode(v2, bos2);
        byte[] b2 = bos2.toByteArray();
        if (!Arrays.equals(b, b2)) {
            throw new Exception("Error with encoding/decoding");
        }
        return v2;
    }
}
