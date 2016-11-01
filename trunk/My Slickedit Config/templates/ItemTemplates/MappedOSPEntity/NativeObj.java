/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 * (c) Copyright 2000-2015 TIBCO Software Inc. All rights reserved.      *
 * TIBCO Confidential & Proprietary                                      *
 *                                                                       *
 ========================================================================*/

package com.openspirit.plugin.data.petra.v3.mapped.petra;

import java.sql.Timestamp;
import java.util.ArrayList;

import com.openspirit.plugin.data.common.MapCacheWithTimeout;
import com.openspirit.plugin.data.common.QueryUtils;
import com.openspirit.plugin.data.petra.v3.mapped.*;
import com.openspirit.spi.data.table.QueryException;
import com.openspirit.unit.DoubleQuantity;

/**
 * Structure containing relevant $NativeObj$ attributes used for OSP mappings.
 */
public final class $NativeObj$ extends PetraCacheObject {

    private static com.openspirit.spi.logging.Logger s_log = com.openspirit.spi.SingletonFactory
            .getLogger($NativeObj$.class);

    private static MapCacheWithTimeout<Integer, $NativeObj$> s_cache = new MapCacheWithTimeout<Integer, $NativeObj$>();

    /**
     * The native entity name.
     */
    public final static String TABLE = "$NativeObj$";

    /**
     * The name of the primary key attribute.
     */
    public static final String ID = "WSN";

    // TODO: Members are named 'm_' + the petra attribute name.
    public DoubleQuantity m_surfLat;
    public  String m_county;
    public String m_offshore_OffshoreBlock;
    public Timestamp m_chgDate;
    public Integer m_wsn;

    /**
     * Constructor.
     *
     * @param connection
     *            the connection.
     */
    public $NativeObj$(Petra3TableConnection connection) {
        super(connection);

        s_log.debug("Entered constructor()");
    }

    /**
     * @see com.openspirit.plugin.data.petra.v3.mapped.PetraCacheObject#clearCache()
     *      {@inheritDoc}
     */
    @Override
    protected void clearCache() {
        s_log.debug("Clearing cache for '" + TABLE + "'.");

        s_cache.clearCache();
    }

    /**
     * Clears the specified element from the cache.
     *
     * @param wsn the $NativeObj$ id to clear.
     */
    @SuppressWarnings("boxing")
    private static void clear(int wsn) {
        try {
            s_cache.writeLock();

            s_cache.getMap().remove(wsn);
        } finally {
            s_cache.releaseLock();
        }

    }

    /**
     * Returns the $NativeObj$ object with the specified id.
     *
     * @param id the $NativeObj$ id.
     * @return the $NativeObj$ object with the specified id.
     */
    public $NativeObj$ get(int wsn) {
        s_log.debug("Getting element from " + TABLE + " with wsn " + wsn);

        $NativeObj$ result = null;

        try {
            s_cache.readLock();

            result = s_cache.getMap().get(wsn);
        } finally {
            s_cache.releaseLock();
        }

        // The requested wsn is not in the cache, read and return it.
        if (result == null) {
            try {
                s_cache.writeLock();

                read(" WHERE wsn = " + wsn);

                return s_cache.getMap().get(wsn);
            } finally {
                s_cache.releaseLock();
            }
        }

        return result;
    }

    /**
     * Reads all $NativeObj$ rows.
     *
     * @return all $NativeObj$ object ids.
     */
    public java.util.List<Integer> read() {
        try {
            s_cache.writeLock();

            return read(null);
        } finally {
            s_cache.releaseLock();
        }
    }

    /**
     * Reads the $NativeObj$ ids with the wsn specified in the m_idList list.
     *
     * @param m_idList
     * @return java.util.List<Integer> ids matching the specified filter..
     */
    public java.util.List<Integer> readByWsns(ArrayList<Integer> m_idList) {
        String whereClause = null;

        if (m_idList != null && m_idList.size() > 0) {
            whereClause = " WHERE " + QueryUtils.inClauseInts(ID, m_idList);
        }

        try {
            s_cache.writeLock();
            return read(whereClause);
        } finally {
            s_cache.releaseLock();
        }
    }

    /**
     * Reads the $NativeObj$ ids with the uwi specified in the constraintUwis list.
     *
     * @param constraintUwis
     * @return java.util.List<Integer> ids matching the specified filter..
     */
    public java.util.List<Integer> readByUwis(
            java.util.ArrayList<String> constraintUwis) {
        String whereClause = null;

        if (constraintUwis != null && constraintUwis.size() > 0) {
            whereClause = QueryUtils.inClauseStrings("uwi", constraintUwis);
        }

        try {
            s_cache.writeLock();
            return read(whereClause);
        } finally {
            s_cache.releaseLock();
        }
    }

    /**
     * Reads the $NativeObj$ ids with the name specified in the constraintNames list.
     *
     * @param constraintNames
     * @return java.util.List<Integer> ids matching the specified filter..
     */
    public java.util.List<Integer> readByNames(
        java.util.List<String> constraintNames) {
        String whereClause = null;

        if (constraintNames != null && constraintNames.size() > 0) {
            whereClause = QueryUtils.inClauseStrings("name", constraintNames);
        }

        try {
            s_cache.writeLock();
            return read(whereClause);
        } finally {
            s_cache.releaseLock();
        }
    }

    private java.util.List<Integer> read(String whereClause) {
        java.util.List<Integer> resultList = new java.util.ArrayList<Integer>();

        s_log.debug("Entered read()");

        com.openspirit.spi.data.QueryExecutor executor = null;
        com.openspirit.spi.data.QueryResult result = null;

        try {
            // Retrieve the relevant attributes that are used for OSP
            // mappingsString
            StringBuilder sql = new StringBuilder();
            sql.append("SELECT ");
            sql.append("WSN");               // 1
            //... TODO: Add attributes here ...
            sql.append(", County");          // 2
            sql.append("FROM ");
            sql.append(TABLE);

            if (whereClause != null && whereClause.length() > 0) {
                sql.append(whereClause);
            }

            executor = nativeQueryExecutor(sql.toString());
            result = executor.executeQuery(null);

            while (result.next()) {
                $NativeObj$ petra = new $NativeObj$(petra3TableConnection());

                com.openspirit.spi.data.type.SetableDataValue[] dataValues = result
                        .getDataValuesSet().getSetableDataValues();

                int idx = 0;
                petra.m_wsn = dataValues[idx++].getInt();
                petra.m_county = dataValues[idx++].getString();

                s_cache.getMap().put(petra.m_wsn, petra);
                resultList.add(petra.m_wsn);
            }
        } catch (com.openspirit.InvalidTypeException e) {
            s_log.severe(
                    "Programming error: Caught InvalidTypeException: "
                            + e.getDescription() + ", details: "
                            + e.getDetails(), e);
        } catch (com.openspirit.data.OspSQLException e) {
            s_log.severe("Programming error: Caught OspSQLException: "
                            + e.getMessage(), e);
        } catch (Exception e) {
            s_log.severe("Programming error: Caught OspSQLException: "
                    + e.getMessage(), e);
        }
        finally {
            QueryUtils.close(result, executor);
        }

        s_log.debug("Leaving read(), row number=" + resultList.size());

        return resultList;
    }

    //---------------------------------------------------------------------------------------------------------------------------
    /**
     * Inserts the specified row in the $NativeObj$ table with the specified values.
     *
     * @param var$NativeObj$ the object holding the insert values.
     * @return the new id.
     * @throws com.openspirit.spi.data.table.QueryException if the insert fails.
     */
    public int insert($NativeObj$ var$NativeObj$) throws QueryException {
        s_log.debug("Entered insert()");

        int newWsn = -1;

        com.openspirit.spi.data.QueryExecutor executor = null;
        com.openspirit.spi.data.QueryResult result = null;

        try {
            final String sql = "INSERT INTO " + TABLE + "("
                             + "WSN"               // 1
                             + ", County"          // 2
                             + ") VALUES ("
                             + "?"                 // 1      WSN
                             + ", ?"               // 2      County
                             + ")"

            executor = nativeQueryExecutor(sql);
            com.openspirit.spi.data.QueryParameters params = queryParams(2);

            params.setParameterValue( 1  , sdvu().intVal(var$NativeObj$.m_wsn)       );
            params.setParameterValue( 2  , sdvu().stringVal(var$NativeObj$.m_county) );

            result = executor.executeQuery(params);

            if (result.next()) {
                // There is only 1 row in the result set.
                com.openspirit.spi.data.DataKey nativeKey = spiDataKey(result.getDataValuesSet().getSetableDataValues()[0]);
                newWsn = nativeKey.getKeyValues()[0].getInt();
            }

            s_log.debug("Inserted row into " + TABLE + " id=" + newWsn);
        }
        catch (com.openspirit.data.OspSQLException e) {
            s_log.severe("Caught OspSQLException: " + e.getMessage(), e);
            Petra3Utils.throwQueryException(e);
        }
        catch (com.openspirit.BadArgumentsException e) {
            s_log.severe("Programming error: Caught BadArgumentsException: " + e.getMessage(), e);
            throw new com.openspirit.OspRuntimeException("Programming error: " + e.getDescription(), e);
        }
        catch (com.openspirit.InvalidTypeException e) {
            s_log.severe("Programming error: Caught InvalidTypeException: " + e.getMessage(), e);
            throw new com.openspirit.OspRuntimeException("Programming error: " + e.getDescription(), e);
        }
        finally {
            QueryUtils.close(result, executor);
        }

        s_log.debug("Leaving insert(), new var$NativeObj$ wsn id=" + newWsn);

        return newWsn;
    }

    //---------------------------------------------------------------------------------------------------------------------------
    /**
     * Updates the specified row in the table with the specified values.
     * @param var$NativeObj$ the object holding the update values..
     * @throws com.openspirit.spi.data.table.QueryException if the update fails.
     */
    public void update($NativeObj$ var$NativeObj$) throws QueryException {
        s_log.debug("Entered insert()");

        int newWsn = -1;

        com.openspirit.spi.data.QueryExecutor executor = null;
        com.openspirit.spi.data.QueryResult result = null;

        try {
            final String sql = "UPDATE " + TABLE + " SET "
                             + "WSN = ?"               // 1      WSN
                             + ", County = ?"          // 2      County
                             + " WHERE "
                             + ID
                             + " = "
                             + var$NativeObj$.m_wsn;

            executor = nativeQueryExecutor(sql);
            com.openspirit.spi.data.QueryParameters params = queryParams(2);

            params.setParameterValue( 1  , sdvu().intVal(var$NativeObj$.m_wsn)            );
            params.setParameterValue( 2  , sdvu().stringVal(var$NativeObj$.m_county)      );

            result = executor.executeQuery(params);

            s_log.debug("Updated " + TABLE + " id=" + var$NativeObj$.m_wsn);
        }
        catch (com.openspirit.data.OspSQLException e) {
            s_log.severe("Caught OspSQLException: " + e.getMessage(), e);
            Petra3Utils.throwQueryException(e);
        }
        catch (com.openspirit.BadArgumentsException e) {
            s_log.severe("Programming error: Caught BadArgumentsException: " + e.getMessage(), e);
            throw new com.openspirit.OspRuntimeException("Programming error: " + e.getDescription(), e);
        }
        finally {
            QueryUtils.close(result, executor);
        }

        s_log.debug("Removing updated element from the cache");
        clear(var$NativeObj$.m_wsn);

        s_log.debug("Leaving update().");
    }


    /**
     * Deletes the specified row from the $NativeObj$ table.
     *
     * @param wsn the $NativeObj$ wsn.
     */
    public void delete(Integer wsn) throws com.openspirit.spi.data.table.QueryException {
        s_log.debug("Entered delete(), wsn=" + wsn);

        com.openspirit.spi.data.QueryExecutor executor = null;
        com.openspirit.spi.data.QueryResult result = null;

        try {
            final String sql = "DELETE FROM " + TABLE + " "
                    + "WHERE " + ID + " = " + wsn.toString();

            executor = nativeQueryExecutor(sql);
            result = executor.executeQuery(null);

            s_log.debug("Deleted " + TABLE + " wsn=" + wsn);
        }
        catch (com.openspirit.data.OspSQLException e) {
            s_log.severe("Caught OspSQLException: " + e.getMessage(), e);

            Petra3Utils.throwQueryException(e);
        }
        finally {
            QueryUtils.close(result, executor);
        }

        s_log.debug("Removing deleted element from the cache");

        clear(wsn);

        s_log.debug("Leaving delete().");
    }
}
