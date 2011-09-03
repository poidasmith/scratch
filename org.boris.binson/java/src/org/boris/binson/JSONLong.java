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

public class JSONLong extends JSONValue
{
    public final long value;

    public JSONLong(long value) {
        super(BinsonCodec.TYPE_INT64);
        this.value = value;
    }

    public String toString() {
        return Long.toHexString(value);
    }

    public int hashCode() {
        return (int) (value ^ (value >> 32));
    }

    public boolean equals(Object obj) {
        return obj instanceof JSONLong && value == ((JSONLong) obj).value;
    }
}
