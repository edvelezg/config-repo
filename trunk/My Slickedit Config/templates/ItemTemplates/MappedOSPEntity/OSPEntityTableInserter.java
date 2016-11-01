/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 * (c) Copyright 2000-2015 TIBCO Software Inc. All rights reserved.      *
 * TIBCO Confidential & Proprietary                                      *
 *                                                                       *
 ========================================================================*/

package com.openspirit.plugin.data.petra.v3.mapped.well;

import com.openspirit.data.DataKey;
import com.openspirit.spi.data.QueryExceptionType;
import com.openspirit.spi.data.table.QueryException;
import com.openspirit.plugin.data.petra.v3.mapped.*;
import com.openspirit.plugin.data.petra.v3.mapped.petra.$NativeObject$;

/**
 * Table inserter implementation for the $OSP_ENTITY_NAME$ table.
 */
public class $fileinputname$TableInserter extends Petra3TableInserter {

    private static com.openspirit.spi.logging.Logger s_log =
        com.openspirit.spi.SingletonFactory.getLogger($fileinputname$TableInserter.class);

    //---------------------------------------------------------------------------------------------------------------------------
    protected $fileinputname$TableInserter(Petra3Table table,
            com.openspirit.metamodel.AttributeDefinition[] insertColumns,
            com.openspirit.spi.data.type.DataValue[] insertColumnValues) {

        super(table, insertColumns, insertColumnValues);

        s_log.debug("Entered constructor()");
    }
    //---------------------------------------------------------------------------------------------------------------------------
    /**
     * This method should be called when the inserter is no longer needed. It is used to enable
     * implementations to release resources prior to garbage collection.
     */
    public void close() {

        s_log.debug("Entered close()");
        super.close();
    }
    //---------------------------------------------------------------------------------------------------------------------------
    /**
     * @see com.openspirit.spi.data.table.TableInserter#insertRow()
     * {@inheritDoc}
     */
    public DataKey insertRow() throws QueryException {
        s_log.debug("Entered insertRow()");

        $NativeObject$ var$NativeObject$ = new $NativeObject$(petra3Connection());

        com.openspirit.metamodel.AttributeDefinition[] attributeDefns = getInsertColumns();
        com.openspirit.spi.data.type.DataValue[] dataValues = getInsertColumnValues();
        int numColumns = attributeDefns.length;

        for (int i = 0; i < numColumns; i++) {
            com.openspirit.metamodel.AttributeDefinition attr = attributeDefns[i];
            com.openspirit.spi.data.type.DataValue value = dataValues[i];

            if (attr.getName().equalsIgnoreCase("Bores")) {
                // TODO: need to determine mapping
            }
            else if (attr.getName().equalsIgnoreCase("WellType")) {
                // TODO: need to determine mapping
            }
        }
        // Check if the required attributes were provided in the $OSP_ENTITY_NAME$ insert.
        s_log.debug("Validating required fields for $OSP_ENTITY_NAME$ insert.");

        DataKey key = null;
        s_log.debug("Calling insert.");
        int wsn = new $NativeObject$(petra3Connection()).insert(var$NativeObject$);
        if (wsn > 0) {
            key = new $fileinputname$Key(petra3Table(), wsn).createDataKey();
        }
        s_log.debug("Leaving insertRow()");
        return key;
    }
}
