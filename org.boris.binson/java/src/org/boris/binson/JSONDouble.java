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

public class JSONDouble extends JSONValue
{
    public final double value;

    public JSONDouble(double value) {
        super(BinsonCodec.TYPE_DOUBLE);
        this.value = value;
    }
}