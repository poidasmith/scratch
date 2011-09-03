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

public final class JSONBoolean extends JSONValue
{
    public JSONBoolean(boolean value) {
        super(value ? BinsonCodec.TYPE_TRUE : BinsonCodec.TYPE_FALSE);
    }

    public boolean booleanValue() {
        return this.type == BinsonCodec.TYPE_TRUE;
    }

    public String toString() {
        return String.valueOf(booleanValue());
    }

    public int hashCode() {
        return type;
    }
}
