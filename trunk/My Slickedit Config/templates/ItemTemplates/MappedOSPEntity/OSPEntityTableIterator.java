/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 * (c) Copyright 2000-2015 TIBCO Software Inc. All rights reserved.      *
 * TIBCO Confidential & Proprietary                                      *
 *                                                                       *
 ========================================================================*/

package com.openspirit.plugin.data.petra.v3.mapped.well;

import java.util.ArrayList;
import java.util.List;

import com.openspirit.plugin.data.common.rvs.ReferenceValueMapFactory;
import com.openspirit.plugin.data.common.rvs.StringRVMap;
import com.openspirit.plugin.data.petra.v3.mapped.Petra3Table;
import com.openspirit.plugin.data.petra.v3.mapped.Petra3TableIterator;
import com.openspirit.plugin.data.petra.v3.mapped.petra.$NativeObject$;
import com.openspirit.spi.OpenSpiritProvider;
import com.openspirit.spi.data.QueryExceptionType;
import com.openspirit.spi.data.table.QueryException;

/**
 * Table iterator implementation for the $OSP_ENTITY_NAME$ table.
 */
public class $fileinputname$TableIterator extends Petra3TableIterator {

    private static com.openspirit.spi.logging.Logger s_log = com.openspirit.spi.SingletonFactory
            .getLogger($fileinputname$TableIterator.class);

    private List<Integer> m_idList = new ArrayList<Integer>();
    private int m_rowIdx = -1;
    private $NativeObject$ m_var$NativeObject$ = null;

    private boolean m_isCountQuery;

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * Constructor.
     *
     * @param table associated table
     * @param selectColumns attributes to retrieve
     * @param selectColumnValues data values to set
     * @param selectConstraint where clause constraints
     * @param selectOrderSpecifications order by constraints
     * @throws QueryException if unexpected error
     */
    public $fileinputname$TableIterator(Petra3Table table,
            com.openspirit.metamodel.AttributeDefinition[] selectColumns,
            com.openspirit.spi.data.type.SetableDataValue[] selectColumnValues,
            com.openspirit.spi.data.table.Constraint selectConstraint,
            com.openspirit.spi.data.table.AttributeOrderSpecification[] selectOrderSpecifications)
            throws QueryException {

        super(table, selectColumns, selectColumnValues, selectConstraint, selectOrderSpecifications);

        s_log.debug("Entered constructor(select)");

        // Check if the only column requested is the primary key.
        m_isCountQuery = (selectColumns.length == 1 && selectColumns[0]
                .getName().equalsIgnoreCase("primarykey$"));

        if (!m_isCountQuery) {
            // TODO: handle column conditions
        }
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * Constructor.
     *
     * @param table associated table
     * @param selectColumns attributes to retrieve
     * @param selectColumnValues data values to set
     * @param selectConstraint where clause constraints
     * @param updateColumns attributes to update
     * @param updateColumnValues data values for updating
     * @throws QueryException if unexpected error
     */
    public $fileinputname$TableIterator(Petra3Table table,
            com.openspirit.metamodel.AttributeDefinition[] selectColumns,
            com.openspirit.spi.data.type.SetableDataValue[] selectColumnValues,
            com.openspirit.spi.data.table.Constraint selectConstraint,
            com.openspirit.metamodel.AttributeDefinition[] updateColumns,
            com.openspirit.spi.data.type.DataValue[] updateColumnValues)
            throws QueryException {

        super(table, selectColumns, selectColumnValues, selectConstraint,
                updateColumns, updateColumnValues);

        s_log.debug("Entered constructor(update)");
    }


    /**
     * @see com.openspirit.plugin.data.petra.v3.mapped.Petra3TableIterator#close()
     * {@inheritDoc}
     */
    @Override
    public void close() {
        s_log.debug("Entered close(), clearing rowIds.");

        m_idList.clear();
        super.close();
    }

    /**
     * @see com.openspirit.spi.data.table.TableIterator#executeQuery()
     *      {@inheritDoc}
     */
    @SuppressWarnings("boxing")
    @Override
    public synchronized void executeQuery() throws QueryException {

        s_log.debug("Entered executeQuery()");
        // Re-initialize the internal state
        m_idList.clear();
        m_rowIdx = -1;

        boolean readAll = true;
        // Check if WHERE clause was specified.
        if (getConstraint() != null) {
            visitConstraint();

            // Only process PrimaryKey$, Identifier and Name constraints.
            // TODO: This can be removed in v4.2, the framework does the filtering.
            com.openspirit.data.DataKey[] keys = distinctConstraintKeys("PrimaryKey$"); // has highest precedence

            if (keys.length > 0) {
                readAll = false;
                for (int i = 0; i < keys.length; i++) { // validate the keys
                    if ($fileinputname$Key.valid(keys[i], petra3Connection())) {
                        int id = $fileinputname$Key.getWsn(keys[i]);
                        $NativeObject$ s = m_var$NativeObject$.get(id); // TODO: make sure it still exists in database
                        if (s != null) {
                            m_idList.add(s.m_wsn);
                        }
                    }
                }
            } else {
                // Check if the constraint is Identifier.
                java.util.ArrayList<String> uwis = new java.util.ArrayList<String>();

                uwis.addAll(java.util.Arrays.asList(simpleConstraintVisitor().getStringList("Identifier")));

                if (uwis != null && uwis.size() > 0) {
                    m_idList = m_var$NativeObject$.readByUwis(uwis);
                }
                else {
                    // Check if the constraint is Name.
                    java.util.ArrayList<String> names = new java.util.ArrayList<String>();

                    names.addAll(java.util.Arrays.asList(simpleConstraintVisitor().getStringList("Name")));

                    if (names.size() > 0) {
                        m_idList = m_var$NativeObject$.readByNames(names);
                    }
                }
            }
        }
        if ((m_idList == null || m_idList.isEmpty()) && readAll) { // no valid
                                                                    // constraints;
                                                                    // return
                                                                    // all wells
            m_idList = m_var$NativeObject$.read();
        }

        // TODO: add performance improvements for joins here. i.e.
        // Major Performance improvement: pre-read the locations ahead of time
        // to save them in the cache so that the Loc.get method can retrieve the locations from the cache
        // without reading each one at a time from the database.
        // if (m_loc != null) {
        //     m_loc.readByWsns(m_idList);
        // }

        s_log.debug("Leaving executeQuery(), row count: " + m_idList.size());
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * Returns the number of rows that the iterator will iterate over until it
     * runs out of rows. This value should remain constant for the life of the
     * iterator. It indicates the total number of rows to be iterated over
     * during the life of the iterator, not the number of rows remaining to be
     * iterated over during iteration. This method is also used for returning
     * the result of a count(*) query.
     *
     * Implementations that don't know the number of rows should a negative
     * number.
     *
     * @return The number of rows to be iterated over during the life of the
     *         iterator.
     */
    public int getRowCount() {

        s_log.debug("Entered getRowCount()");
        return m_idList.size();
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * This method is used to advance to the next row. It should return false if
     * all of the rows have already been iterated over or if the query returned
     * no rows.
     *
     * WARNING: this is where expensive database calls should be taking place
     * and NOT in the readRow() method.
     *
     * @return true if the iterator was able to advance to the next row; false
     *         if all of the rows have already been iterated over or if the
     *         query returned no rows.
     * @throws QueryException
     *             If the iterator is unable to advance to the next row. Note
     *             that false should be returned rather than throwing this
     *             exception if the table is empty or if all of the rows have
     *             already been iterated over.
     */
    public synchronized boolean next() throws QueryException {
        s_log.debug("Entered next()");

        if (m_idList.size() > 0 && m_rowIdx < m_idList.size() - 1) {
            m_rowIdx++;

            // TODO: add other object instantiaons here. i.e.
            //if (m_loc != null) {
            //    final int wsn = m_idList.get(m_rowIdx);
            //    m_loc = m_loc.get(wsn);
            //}

            return true;
        }
        return false;
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * Populate the column values, specified when creating the iterator, with
     * data for the row this iterator is currently positioned on. The readRow
     * method may be called multiple times for the same row (i.e. without
     * calling next).
     *
     * WARNING: expensive database calls should be in the next() method and not
     * here because this method can be called multiple times for the same row
     * when joining tables.
     *
     * @throws QueryException
     *             if no data could be read, for example if next has not been
     *             called.
     */
    public void readRow() throws QueryException {
        // WARNING: expensive database calls should be in the next() method and
        // not here because this method can
        // be called multiple times for the same row when joining tables.

        s_log.debug("Entered readRow()");
        final int wsn = m_idList.get(m_rowIdx).intValue();
        s_log.debug("$NativeObject$ wsn: " + wsn);

        // Get methods should be fast most of the time, because they have been
        // put in the cache in executeQuery
        final $NativeObject$ var$NativeObject$ = m_var$NativeObject$.get(wsn);
        if (var$NativeObject$ == null) {
            throw new QueryException(QueryExceptionType.GENERAL_DATA_EXCEPTION,
                    "Could not retrieve var$NativeObject$ (wsn = " + wsn + ")");
        }

        final com.openspirit.metamodel.AttributeDefinition[] attributeDefns = getSelectColumns();
        final com.openspirit.spi.data.type.SetableDataValue[] selectColumns = getSelectColumnValues();

        int numColumns = attributeDefns.length;
        for (int i = 0; i < numColumns; i++) {

            final com.openspirit.metamodel.AttributeDefinition attr = attributeDefns[i];
            final com.openspirit.spi.data.type.SetableDataValue value = selectColumns[i];
            String attributeName = attr.getName();
            s_log.debug("AttributeDefinition: " + attributeName);
            // -------------------------------------------------------------------------------------------------------
            if (setDataValue(attr, value)) { // the majority of the $ suffix variables
                continue;                    // handled by base class
            }
            // -------------------------------------------------------------------------------------------------------
            if (attributeName.equalsIgnoreCase("PrimaryKey$")) {
                setDataKey(value, new $fileinputname$Key(Petra3Table(), var$NativeObject$.m_wsn).createDataKey());
            }
            //-------------------------------------------------------------------------------------------------------
            else if (attributeName.equalsIgnoreCase("")) {
                value.setNull(); // TODO: add mappings here
            }
            // -------------------------------------------------------------------------------------------------------
            else {
                value.setNull(); // must be an unmapped attribute
            }
        }
        s_log.debug("Leaving readRow()");
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * This method is used to update the current row.
     *
     * @throws QueryException
     *             if the TableIterator is unable to update the current row.
     */
    public synchronized void updateRow() throws QueryException {
        s_log.debug("Entered updateRow()");


        final int wsn = m_idList.get(m_rowIdx).intValue();
        final $NativeObject$ var$NativeObject$ = new $NativeObject$(petra3Connection()).get(wsn);

        final com.openspirit.metamodel.AttributeDefinition[] attributeDefs = getUpdateColumns();
        final com.openspirit.spi.data.type.DataValue[] updateCols = getUpdateColumnValues();
        final int numCols = attributeDefs.length;

        boolean needsUpdate = false;

        for (int i = 0; i < numCols; i++) {
            final com.openspirit.metamodel.AttributeDefinition attr = attributeDefs[i];
            final com.openspirit.spi.data.type.DataValue value = updateCols[i];

            if (attr.getName().equalsIgnoreCase("Name")) {
                // TODO: add mapping
            }
            else if (attr.getName().equalsIgnoreCase("Comment")) {
                // TODO: add mapping
            }
        }

        s_log.debug("Leaving updateRow()");
    }

    // ---------------------------------------------------------------------------------------------------------------------------
    /**
     * This method is used to delete the current row.
     *
     * @throws QueryException
     *             if the TableIterator is unable to delete the current row.
     */
    public synchronized void deleteRow() throws QueryException {

        s_log.debug("Entered deleteRow()");

        // TODO: add code here

        s_log.debug("Leaving deleteRow()");
    }
}
