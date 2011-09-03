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
    public static final JSONValue NULL = null;
    public static final JSONValue FALSE = new JSONBoolean(false);
    public static final JSONValue TRUE = new JSONBoolean(true);

    public final int type;

    JSONValue(int type) {
        this.type = type;
    }
}
