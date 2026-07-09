import Upload from "../models/upload.model.js";
import cloudinary from "../config/cloudinary.js";

/**
 * Save upload metadata
 */
export const createUploadService = async (payload) => {
  const upload = await Upload.create(payload);

  return await Upload.findById(upload._id)
    .populate("uploadedBy", "name email profileImage");
};

/**
 * Find upload by ID
 */
export const findUploadService = async (id) => {
  return await Upload.findOne({
    _id: id,
    isDeleted: false,
  }).populate(
    "uploadedBy",
    "name email profileImage"
  );
};

/**
 * Get uploads by user
 */
export const getUserUploadsService = async (userId) => {
  return await Upload.find({
    uploadedBy: userId,
    isDeleted: false,
  })
    .sort({ createdAt: -1 })
    .populate(
      "uploadedBy",
      "name email profileImage"
    );
};

/**
 * Delete from Cloudinary
 */
export const deleteCloudinaryFileService = async (
  publicId
) => {
  return await cloudinary.uploader.destroy(
    publicId,
    {
      resource_type: "auto",
    }
  );
};

/**
 * Soft delete upload
 */
export const deleteUploadService = async (
  upload
) => {
  upload.isDeleted = true;
  upload.deletedAt = new Date();

  await upload.save();

  return upload;
};