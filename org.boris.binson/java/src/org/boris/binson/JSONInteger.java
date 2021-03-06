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

public class JSONInteger extends JSONValue
{
    public final int value;

    public JSONInteger(int value) {
        super(BinsonCodec.TYPE_INT32);
        this.value = value;
    }

    public String toString() {
        return String.valueOf(value);
    }

    public int hashCode() {
        return value;
    }

    public boolean equals(Object obj) {
        return obj instanceof JSONInteger && value == ((JSONInteger) obj).value;
    }
}
