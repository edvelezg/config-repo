/*========================================================================
 * - COPYRIGHT NOTICE -                                                  *
 *                                                                       *
 ========================================================================*/
#include <osp/plugin/data/petra/petraLib/PetraLibEx.h>
#include <osp/plugin/data/petra/petraLib/PetraWell.h>
#include <osp/plugin/data/petra/petraLib/PetraPick.h>
#include <osp/plugin/data/petra/petraLib/PetraZone.h>
#include "../petralib/PetraCrsUtil.h"

osp::spi::logging::Logger
osp::plugin::data::petra::OSP_WellZoneEntity::s_log(
   osp::spi::SingletonFactory::getLogger("osp::plugin::data::petra::OSP_WellZoneEntity"));

//=========================================================================================
osp::plugin::data::petra::OSP_WellZoneEntity::OSP_WellZoneEntity(
	const osp::metamodel::EntityDefinition& entityDef,
	const osp::data::ProjectDefinition& projectDef,
    const osp::spi::data::table::TableConnection& connection) 
      :
      PetraEntity(entityDef, projectDef, connection)
//=========================================================================================
{
} 

//=====================================================================================
osp::plugin::data::petra::OSP_WellZoneEntity::OSP_WellZoneEntity(
   const osp::plugin::data::petra::OSP_WellZoneEntity& rhs)
      :
      PetraEntity(rhs)
//=====================================================================================
{
}

//=========================================================================================
osp::plugin::data::petra::OSP_WellZoneEntity::~OSP_WellZoneEntity() 
//=========================================================================================
{ 
}

//=========================================================================================
void osp::plugin::data::petra::OSP_WellZoneEntity::executeQuery()
//=========================================================================================
{
}
//=========================================================================================
long osp::plugin::data::petra::OSP_WellZoneEntity::getRowCount() const
//=========================================================================================
{
    return -1;
}

//=========================================================================================
osp::spi::data::DataKey
osp::plugin::data::petra::OSP_WellZoneEntity::insertRow(
   const osp::spi::data::table::Table& table,
   const osp::vector<osp::metamodel::AttributeDefinition>& insertColumns,
   const osp::vector<osp::spi::data::type::DataValue>& insertColumnValues)
//=========================================================================================
{
}
//=========================================================================================
void osp::plugin::data::petra::OSP_WellZoneEntity::updateRow(
        const osp::vector<osp::metamodel::AttributeDefinition>& updateColumns,
        const osp::vector<osp::spi::data::type::DataValue>& updateColumnValues)
//=========================================================================================
{
}
//=========================================================================================
void osp::plugin::data::petra::OSP_WellZoneEntity::readRow(
        const osp::vector<osp::metamodel::AttributeDefinition>& selectColumns,
        osp::vector<osp::spi::data::type::SetableDataValue>& selectColumnValues) const
//=========================================================================================
{
	if (s_log.isDetailEnabled()) {
		s_log.debug("Entered OSP_WellZoneEntity::readRow()");
	}

	PETRA_ZoneDef zEntity;

    int res = PETRA_ZonesGetZoneDef(m_currentZid, &zEntity);

	if (res != PETRA_SUCCESS) {
		throw osp::spi::data::table::QueryException(
			osp::spi::data::QueryExceptionType::GENERAL_DATA_EXCEPTION,
			std::string("PETRA_ZonesGetZoneDef() returned ")+ PETRA_ErrorMsg(res));
	}

	for (unsigned int colIdx = 0; colIdx < selectColumns.size(); colIdx ++) {
		std::string attrName = selectColumns[colIdx].getName();

		if (attrName == "WSN") {
			selectColumnValues[colIdx].setInt(m_currentWsn);
        }
		else if (attrName == "osp_LowerDepthMode") {
			if (zEntity.ZoneDepth.LowerDepthMode == 'V') {
				selectColumnValues[colIdx].setString("TVD");
			}
			else if (zEntity.ZoneDepth.LowerDepthMode == 'D') {
				selectColumnValues[colIdx].setString("MD");
			}
			else if (zEntity.ZoneDepth.LowerDepthMode == 'T') {
				selectColumnValues[colIdx].setString("FormationTop");
			}
		}
		else if (attrName == "osp_UpperDepthMode") {
			if (zEntity.ZoneDepth.UpperDepthMode == 'V') {
				selectColumnValues[colIdx].setString("TVD");
			}
			else if (zEntity.ZoneDepth.UpperDepthMode == 'D') {
				selectColumnValues[colIdx].setString("MD");
			}
			else if (zEntity.ZoneDepth.UpperDepthMode == 'T') {
				selectColumnValues[colIdx].setString("FormationTop");
			}
		}
		else if (attrName == "BasePickMD") {
			if (m_currentBaseFid != -1) {
				PETRA_FmTop pick;
				int res = PETRA_FmTopsGet(m_currentWsn, m_currentBaseFid, &pick);
				if (res == PETRA_SUCCESS) {
					osp::spi::data::type::SetableDoubleQuantityDataValue setableDoubleQuantityDataValue =
					osp::spi::data::type::SetableDoubleQuantityDataValue::downcast(selectColumnValues[colIdx]);
					setableDoubleQuantityDataValue.setDoubleQuantity(pick.MD, m_unit);
				}
				else {
					throw osp::spi::data::table::QueryException(
						osp::spi::data::QueryExceptionType::GENERAL_DATA_EXCEPTION,
						std::string("PETRA_FmTopsGet() returned ")+ PETRA_ErrorMsg(res));
				}
			}
		}
		else if (attrName == "TopPickMD") {
			if (m_currentTopFid != -1) {
				PETRA_FmTop pick;
				int res = PETRA_FmTopsGet(m_currentWsn, m_currentTopFid, &pick);
				if (res == PETRA_SUCCESS) {
					osp::spi::data::type::SetableDoubleQuantityDataValue setableDoubleQuantityDataValue =
					osp::spi::data::type::SetableDoubleQuantityDataValue::downcast(selectColumnValues[colIdx]);
					setableDoubleQuantityDataValue.setDoubleQuantity(pick.MD, m_unit);
				}
				else {
					throw osp::spi::data::table::QueryException(
						osp::spi::data::QueryExceptionType::GENERAL_DATA_EXCEPTION,
						std::string("PETRA_FmTopsGet() returned ")+ PETRA_ErrorMsg(res));
				}
			}
		}
		else {
			setDataValueFromAttribute(&zEntity, attrName, selectColumnValues[colIdx]);
		}
	}
}

//=========================================================================================
bool osp::plugin::data::petra::OSP_WellZoneEntity::next()
//=========================================================================================
{
    if (m_pkCosntraintFlag) {
		while (m_zoneIndex < m_zoneLen) {
			m_currentWsn = m_wsnList[m_zoneIndex];
			m_currentZid = m_zoneList[m_zoneIndex];
			m_zoneIndex++;
			return true;
		}
		return false;
	}

	//loop over the zid list
	while (m_zoneIndex < m_zoneLen) {
		int lowerTopId = -1;
		int upperTopId = -1;
		m_currentTopFid = -1;
		m_currentBaseFid = -1;
		PETRA_ZoneDef entity;
		int res = PETRA_ZonesGetZoneDef(m_zoneList[m_zoneIndex], &entity);
		if (res == PETRA_SUCCESS && strcmp(entity.Name, "WELL") && strcmp(entity.Name, "FMTOPS")) {
			lowerTopId = entity.ZoneDepth.LowerTopId;
			upperTopId = entity.ZoneDepth.UpperTopId;

			//loop over the wsn list		
			while (m_wsnIndex < m_wsnLen) {
				//if UpperFmTop or BaseFmTop is specified, check whether they can be retrieved for the well, 
				//if yes, it means the Zone for the well is set
				if (lowerTopId > 0 || upperTopId > 0) {
					//get the formation top list associated with the well
					int numWellTop = PETRA_FmTopsGetListByWell(m_wsnList[m_wsnIndex], NULL);
					int* pFid = new int[numWellTop];
					PETRA_FmTopsGetListByWell(m_wsnList[m_wsnIndex], pFid);

					bool lowerTopExistFlag = false;
					bool upperTopExistFlag = false;
					bool existFlag = true;
					if (numWellTop > 0) {
						for (int k = 0; k < numWellTop; k ++) {
							if (lowerTopId == pFid[k]) {
								m_currentBaseFid = lowerTopId;
								lowerTopExistFlag = true;
							}
							if (upperTopId == pFid[k]) {
								m_currentTopFid = upperTopId;
								upperTopExistFlag = true;
							}
						}

						if ((lowerTopId > 0 && !lowerTopExistFlag)
							|| (upperTopId > 0 && !upperTopExistFlag)) {
							m_currentBaseFid = -1;
							m_currentTopFid = -1;
							existFlag = false;
						}
						if (existFlag) {
							m_currentWsn = m_wsnList[m_wsnIndex];
							m_currentZid = m_zoneList[m_zoneIndex];
							m_wsnIndex++;
							delete[] pFid;
							return true;						
						}
					}
					delete[] pFid;
				}
				//if both ZoneDepth_LowerDepth and ZoneDepth_UpperDepth are specified, it means the depth interval is across the entire well set.
				//thus for every single well in the project, a WellZone row is returned in this case
				else {
					m_currentWsn = m_wsnList[m_wsnIndex];
					m_currentZid = m_zoneList[m_zoneIndex];
					m_wsnIndex++;
					return true;
				}
				m_wsnIndex++;
			}
		}
		m_wsnIndex = 0;
		m_zoneIndex++;
	}
	return false;
}
