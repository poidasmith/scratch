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

import java.util.Arrays;

public class JSONByteArray extends JSONValue
{
    public final byte[] buffer;

    JSONByteArray(byte[] buffer) {
        super(BinsonCodec.TYPE_RAW);
        this.buffer = buffer;
    }

    public String toString() {
        return Arrays.toString(buffer);
    }

    public int hashCode() {
        return buffer == null ? type : Arrays.hashCode(buffer);
    }

    public boolean equals(Object obj) {
        if (obj instanceof JSONByteArray == false)
            return false;
        if (buffer == null)
            return ((JSONByteArray) obj).buffer == null;
        return Arrays.equals(buffer, ((JSONByteArray) obj).buffer);
    }
}
