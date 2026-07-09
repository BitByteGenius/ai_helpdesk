import Audit from "../models/audit.model.js";

/**
 * Create Audit Log
 */
export const createAudit = async ({
  user,
  action,
  entity,
  entityId = null,
  description,
  oldData = null,
  newData = null,
  ipAddress = "",
  userAgent = "",
}) => {
  try {
    const audit = await Audit.create({
      user,
      action,
      entity,
      entityId,
      description,
      oldData,
      newData,
      ipAddress,
      userAgent,
    });

    return audit;
  } catch (error) {
    console.error("Audit Service Error:", error);
    return null;
  }
};

/**
 * Get All Audit Logs
 */
export const getAudits = async ({
  page = 1,
  limit = 20,
  action,
  entity,
  user,
}) => {
  const query = {};

  if (action) query.action = action;
  if (entity) query.entity = entity;
  if (user) query.user = user;

  const skip = (page - 1) * limit;

  const [logs, total] = await Promise.all([
    Audit.find(query)
      .populate("user", "name email role")
      .sort({ createdAt: -1 })
      .skip(skip)
      .limit(limit),

    Audit.countDocuments(query),
  ]);

  return {
    logs,
    total,
    page,
    pages: Math.ceil(total / limit),
  };
};

/**
 * Get Audit By ID
 */
export const getAuditById = async (id) => {
  return Audit.findById(id)
    .populate("user", "name email role");
};

/**
 * Get Audit Logs By User
 */
export const getUserAudits = async (userId) => {
  return Audit.find({
    user: userId,
  })
    .sort({ createdAt: -1 })
    .populate("user", "name email");
};

/**
 * Get Audit Logs For Entity
 */
export const getEntityAudits = async (
  entity,
  entityId,
) => {
  return Audit.find({
    entity,
    entityId,
  })
    .sort({ createdAt: -1 })
    .populate("user", "name email");
};