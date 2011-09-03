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

public class JSONArray extends JSONValue
{
    public final JSONValue[] values;

    public JSONArray(JSONValue[] values) {
        super(BinsonCodec.TYPE_ARRAY);
        this.values = values;
    }

    public String toString() {
        return Arrays.toString(values);
    }
}
