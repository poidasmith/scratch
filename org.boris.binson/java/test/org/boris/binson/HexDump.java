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

import java.io.ByteArrayOutputStream;
import java.io.PrintStream;
import java.io.UnsupportedEncodingException;

public class HexDump
{
    private static final int WIDTH = 20;

    public static void dump(PrintStream out, byte[] data, int offset, int length) {
        int numRows = length / WIDTH;
        for (int i = 0; i < numRows; i++) {
            dumpRow(out, data, offset + i * WIDTH, WIDTH);
        }
        int leftover = length % WIDTH;
        if (leftover > 0) {
            dumpRow(out, data, offset + data.length - leftover, leftover);
        }
    }

    public static void dump(byte[] data) {
        dump(System.out, data, 0, data.length);
    }

    public static void dump(PrintStream out, byte[] data) {
        dump(out, data, 0, data.length);
    }

    public static String toHexDumpString(byte[] data) throws UnsupportedEncodingException {
        ByteArrayOutputStream bos = new ByteArrayOutputStream();
        PrintStream ps = new PrintStream(bos, false, "UTF-8");
        dump(ps, data);
        ps.flush();
        return new String(bos.toByteArray(), "UTF-8");
    }

    private static void dumpRow(PrintStream out, byte[] data, int start, int length) {
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            String s = Integer.toHexString(data[start + i] & 0x00ff);
            if (s.length() == 1) {
                sb.append("0");
            }
            sb.append(s);
            sb.append(" ");
        }
        if (length < WIDTH) {
            for (int i = 0; i < WIDTH - length; i++) {
                sb.append("   ");
            }
        }
        for (int i = 0; i < length; i++) {
            byte b = data[start + i];
            if (Character.isLetterOrDigit(b)) {
                sb.append(String.valueOf((char) b));
            } else {
                sb.append(".");
            }
        }
        out.println(sb.toString());
    }
}
