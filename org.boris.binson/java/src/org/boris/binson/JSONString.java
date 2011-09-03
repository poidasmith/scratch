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

public class JSONString extends JSONValue
{
    public final String value;

    public JSONString(String value) {
        super(BinsonCodec.TYPE_STRING);
        this.value = value;
    }

    public String toString() {
        return value;
    }

    public int hashCode() {
        return value == null ? 0 : value.hashCode();
    }

    public boolean equals(Object obj) {
        return obj instanceof JSONString && equals(((JSONString) obj).value, value);
    }
}
