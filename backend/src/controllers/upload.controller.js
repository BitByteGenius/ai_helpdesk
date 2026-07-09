import {
  createUploadService,
  findUploadService,
  deleteCloudinaryFileService,
  deleteUploadService,
} from "../services/upload.service.js";

/**
 * Upload File
 * POST /api/uploads
 */
export const uploadFile = async (req, res) => {
  try {
    if (!req.file) {
      return res.status(400).json({
        success: false,
        message: "No file uploaded",
      });
    }

    let fileType = "Image";

    if (req.file.mimetype === "application/pdf") {
      fileType = "PDF";
    } else if (
      req.file.mimetype === "application/msword" ||
      req.file.mimetype ===
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document"
    ) {
      fileType = "Word";
    }

    const upload = await createUploadService({
      originalName: req.file.originalname,
      fileName: req.file.filename || req.file.originalname,
      url: req.file.path,
      publicId: req.file.filename, // Verify this after first upload
      mimeType: req.file.mimetype,
      fileType,
      fileSize: req.file.size,
      uploadedBy: req.user.userId,
    });

    return res.status(201).json({
      success: true,
      message: "File uploaded successfully",
      data: upload,
    });
  } catch (error) {
    console.error("UPLOAD ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};

/**
 * Delete Upload
 * DELETE /api/uploads/:id
 */
export const deleteUpload = async (req, res) => {
  try {
    const { id } = req.params;

    const upload = await findUploadService(id);

    if (!upload) {
      return res.status(404).json({
        success: false,
        message: "Upload not found",
      });
    }

    if (
      req.user.role !== "admin" &&
      upload.uploadedBy._id.toString() !== req.user.userId
    ) {
      return res.status(403).json({
        success: false,
        message: "Access denied",
      });
    }

    await deleteCloudinaryFileService(upload.publicId);

    await deleteUploadService(upload);

    return res.status(200).json({
      success: true,
      message: "File deleted successfully",
    });
  } catch (error) {
    console.error("DELETE ERROR:", error);

    return res.status(500).json({
      success: false,
      message: error.message,
    });
  }
};