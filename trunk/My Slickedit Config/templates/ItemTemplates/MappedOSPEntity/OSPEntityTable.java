/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 * (c) Copyright 2000-2015 TIBCO Software Inc. All rights reserved.      *
 * TIBCO Confidential & Proprietary                                      *
 *                                                                       *
 ========================================================================*/

package com.openspirit.plugin.data.petra.v3.mapped.well;

import com.openspirit.plugin.data.petra.v3.mapped.*;

/**
 * Table class for the $OSP_ENTITY_NAME$ table.
 */
public class $fileinputname$Table extends Petra3Table {

    private static com.openspirit.spi.logging.Logger s_log =
        com.openspirit.spi.SingletonFactory.getLogger($fileinputname$Table.class);

    protected final static String OSP_ENTITY_NAME = "$OSP_ENTITY_NAME$";

    /**
     * Constructor.
     *
     * @param tableProvider the table provider object.
     * @param tableConnection the table connection object.
     * @param tgtEntityDef entity definition
     */
    public $fileinputname$Table(Petra3TableProvider tableProvider,
                                  Petra3TableConnection tableConnection,
                                  com.openspirit.metamodel.EntityDefinition tgtEntityDef) {

        super(tableProvider, tableConnection, tgtEntityDef);

        s_log.debug("Entered constructor()");
    }

    /**
     * @see com.openspirit.spi.data.table.Table#selectRows(
     *              com.openspirit.metamodel.AttributeDefinition[],
     *              com.openspirit.spi.data.type.SetableDataValue[],
     *              com.openspirit.spi.data.table.AttributeOrderSpecification[],
     *              com.openspirit.spi.data.table.Constraint)
     * {@inheritDoc}
     */
    public com.openspirit.spi.data.table.TableIterator selectRows(
            com.openspirit.metamodel.AttributeDefinition[] selectColumns,
            com.openspirit.spi.data.type.SetableDataValue[] selectColumnValues,
            com.openspirit.spi.data.table.AttributeOrderSpecification[] selectOrderSpecifications,
            com.openspirit.spi.data.table.Constraint selectConstraint)
                throws com.openspirit.spi.data.table.QueryException {

        s_log.debug("Entered selectRows()");
        return new $fileinputname$TableIterator(
                this, selectColumns, selectColumnValues, selectConstraint, selectOrderSpecifications);
    }

    /**
     * @see com.openspirit.spi.data.table.Table#updateRows(
     *      com.openspirit.metamodel.AttributeDefinition[],
     *      com.openspirit.spi.data.type.SetableDataValue[],
     *      com.openspirit.spi.data.table.Constraint,
     *      com.openspirit.metamodel.AttributeDefinition[],
     *      com.openspirit.spi.data.type.DataValue[])
     * {@inheritDoc}
     */
    public com.openspirit.spi.data.table.TableIterator updateRows(
            com.openspirit.metamodel.AttributeDefinition[] selectColumns,
            com.openspirit.spi.data.type.SetableDataValue[] selectColumnValues,
            com.openspirit.spi.data.table.Constraint selectConstraint,
            com.openspirit.metamodel.AttributeDefinition[] updateColumns,
            com.openspirit.spi.data.type.DataValue[] updateColumnValues)
        throws com.openspirit.spi.data.table.QueryException {

        s_log.debug("Entered updateRows()");
        return new $fileinputname$TableIterator(this,
                selectColumns, selectColumnValues, selectConstraint, updateColumns, updateColumnValues);
    }

    /**
     * @see com.openspirit.spi.data.table.Table#createInserter(
     *      com.openspirit.metamodel.AttributeDefinition[],
     *      com.openspirit.spi.data.type.DataValue[])
     * {@inheritDoc}
     */
    public com.openspirit.spi.data.table.TableInserter createInserter(
            com.openspirit.metamodel.AttributeDefinition[] tgtColumns,
            com.openspirit.spi.data.type.DataValue[] tgtValues)
        throws com.openspirit.spi.data.table.QueryException {

        s_log.debug("Entered createInserter()");
        return new $fileinputname$TableInserter(this, tgtColumns, tgtValues);
    }
}
