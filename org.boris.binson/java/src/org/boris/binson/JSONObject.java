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

import java.util.Map;

public final class JSONObject extends JSONValue
{
    public final Map<String, JSONValue> values;

    public JSONObject(Map<String, JSONValue> values) {
        super(BinsonCodec.TYPE_OBJECT);
        this.values = values;
    }

    public void put(String key, JSONValue value) {
        values.put(key, value);
    }

    public void put(String key, String value) {
        values.put(key, new JSONString(value));
    }

    public void put(String key, int value) {
        values.put(key, new JSONInteger(value));
    }

    public void put(String key, long value) {
        values.put(key, new JSONLong(value));
    }

    public void put(String key, double value) {
        values.put(key, new JSONDouble(value));
    }

    public void put(String key, boolean value) {
        values.put(key, new JSONBoolean(value));
    }

    public void put(String key, JSONValue[] value) {
        values.put(key, new JSONArray(value));
    }

    public void put(String key, byte[] value) {
        values.put(key, new JSONByteArray(value));
    }

    public String toString() {
        return String.valueOf(values);
    }

    public int hashCode() {
        return values == null ? type : values.hashCode();
    }

    public boolean equals(Object obj) {
        return obj instanceof JSONObject && equals(values, ((JSONObject) obj).values);
    }
}
