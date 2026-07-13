import {
  getAudits,
  getAuditById,
  getUserAudits,
  getEntityAudits,
} from "../services/audit.service.js";

//
// GET /api/audit
//
export const getAllAudits = async (req, res) => {
  try {
    const {
      page = 1,
      limit = 20,
      action,
      entity,
      user,
    } = req.query;

    const result = await getAudits({
      page: Number(page),
      limit: Number(limit),
      action,
      entity,
      user,
    });

    res.status(200).json({
      success: true,
      ...result,
    });
  } catch (error) {
    console.error("Get Audit Logs Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch audit logs",
    });
  }
};

//
// GET /api/audit/:id
//
export const getAudit = async (req, res) => {
  try {
    const audit = await getAuditById(req.params.id);

    if (!audit) {
      return res.status(404).json({
        success: false,
        message: "Audit log not found",
      });
    }

    res.status(200).json({
      success: true,
      data: audit,
    });
  } catch (error) {
    console.error("Get Audit Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch audit log",
    });
  }
};

//
// GET /api/audit/user/:userId
//
export const getUserAuditLogs = async (req, res) => {
  try {
    const audits = await getUserAudits(
      req.params.userId,
    );

    res.status(200).json({
      success: true,
      count: audits.length,
      data: audits,
    });
  } catch (error) {
    console.error("User Audit Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch user audit logs",
    });
  }
};

//
// GET /api/audit/entity/:entity/:entityId
//
export const getEntityAuditLogs = async (
  req,
  res,
) => {
  try {
    const audits = await getEntityAudits(
      req.params.entity.toUpperCase(),
      req.params.entityId,
    );

    res.status(200).json({
      success: true,
      count: audits.length,
      data: audits,
    });
  } catch (error) {
    console.error("Entity Audit Error:", error);

    res.status(500).json({
      success: false,
      message: "Failed to fetch entity audit logs",
    });
  }
};