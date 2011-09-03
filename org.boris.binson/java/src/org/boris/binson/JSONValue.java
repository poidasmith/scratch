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

public abstract class JSONValue
{
    public static final JSONValue NULL = new JSONValue(BinsonCodec.TYPE_NULL) {
        public String toString() {
            return "null";
        }
    };
    public static final JSONValue FALSE = new JSONBoolean(false);
    public static final JSONValue TRUE = new JSONBoolean(true);

    public final int type;

    JSONValue(int type) {
        this.type = type;
    }

    protected boolean equals(Object o1, Object o2) {
        if (o1 == null && o2 == null)
            return true;
        if (o1 != null)
            return o1.equals(o2);
        return false;
    }
}
