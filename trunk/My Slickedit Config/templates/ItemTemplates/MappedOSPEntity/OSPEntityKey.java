/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 * (c) Copyright 2000-2015 TIBCO Software Inc. All rights reserved.      *
 * TIBCO Confidential & Proprietary                                      *
 *                                                                       *
 ========================================================================*/

package com.openspirit.plugin.data.petra.v3.mapped.well;

import com.openspirit.plugin.data.petra.v3.mapped.*;
import com.openspirit.plugin.data.petra.v3.mapped.petra.$NativeObject$;

public class $fileinputname$Key extends Petra3Key {

    private static com.openspirit.spi.logging.Logger s_log =
            com.openspirit.spi.SingletonFactory.getLogger($fileinputname$Key.class);

    private static com.openspirit.metamodel.AttributeDefinition s_wsn = null;

    //---------------------------------------------------------------------------------------------------------------------------
    public $fileinputname$Key(Petra3Table petra3Table, int wsn) {
        super(petra3Table, $fileinputname$Table.OSP_ENTITY_NAME);

        try {
            m_attributeDefinitions = new com.openspirit.metamodel.AttributeDefinition[1];
            m_dataValues = new com.openspirit.spi.data.type.DataValue[1];

            if (s_wsn == null) {
                com.openspirit.metamodel.EntityDefinition ed = nativeEntity($NativeObject$.TABLE);
                s_wsn = ed.getAttribute($NativeObject$.ID);
            }

            m_attributeDefinitions[0] = s_wsn;
            m_dataValues[0] = dataValueFactory().createDataValue(wsn);
        }
        catch (com.openspirit.NotFoundException e) {
            System.out.println("NotFoundException: " + e.getDescription() + ", Details: " + e.getDetails());
        }
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Return the well wsn
    public static int getWsn(com.openspirit.data.DataKey dataKey) {
        return getIntFromKey($fileinputname$Table.OSP_ENTITY_NAME, $NativeObject$.ID, dataKey);
    }
    //---------------------------------------------------------------------------------------------------------------------------
    // Return true only if the dataKey is a valid key that is specific to this project and entity
    public static boolean valid(com.openspirit.data.DataKey dataKey, Petra3TableConnection petra3Connection) {

        boolean valid = false;
        if (Petra3Key.valid(dataKey, petra3Connection)) {
            if ($fileinputname$Table.OSP_ENTITY_NAME.equals(dataKey.getEntity().getName())) {
                valid = true;
            }
        }
        return valid;
    }
}
