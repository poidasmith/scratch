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
import java.util.HashMap;

public class Test
{
    public static void main(String[] args) throws Exception {
        JSONObject jo = new JSONObject(new HashMap<String, JSONValue>(10));
        jo.put("hello", "world");
        jo.put("b2", true);
        jo.put("b1", false);
        jo.put("d", 1444.5566);
        jo.put("i1", 0x000000ff);
        jo.put("i2", 0x0000ff00);
        jo.put("i3", 0x00ff0000);
        jo.put("i4", 0xff000000);
        jo.put("l1", 0x3465674523098712l);
        jo.put("arr1", new JSONValue[] { JSONValue.TRUE,
                null, new JSONLong(1245345345345l) });
        jo.put("arr2", new byte[] { 0, 1, 2, 3, 4, 5, 6, 7 });
        JSONObject jo2 = (JSONObject) dump(dump(dump(jo)));
        System.out.println(jo2);
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
        JSONValue v3 = BinsonCodec.decode(new ByteArrayInputStream(b2));
        if (!v.equals(v2) && !v2.equals(v3))
            throw new Exception("Error with encoding");
        return v2;
    }
}
