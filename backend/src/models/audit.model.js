import mongoose from "mongoose";

const auditSchema = new mongoose.Schema(
  {
    // User who performed the action
    user: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    // Action performed
    action: {
      type: String,
      required: true,
      enum: [
        "LOGIN",
        "LOGOUT",
        "REGISTER",

        "CREATE",
        "UPDATE",
        "DELETE",

        "ASSIGN",

        "STATUS_CHANGE",

        "COMMENT",

        "UPLOAD",

        "PROFILE_UPDATE",

        "PASSWORD_CHANGE",

        "AI_ANALYSIS",
      ],
    },

    // Entity affected
    entity: {
      type: String,
      required: true,
      enum: [
        "USER",
        "TICKET",
        "COMMENT",
        "UPLOAD",
        "PROFILE",
        "AI",
        "AUTH",
      ],
    },

    // Related document ID
    entityId: {
      type: mongoose.Schema.Types.ObjectId,
      default: null,
      index: true,
    },

    // Human-readable description
    description: {
      type: String,
      required: true,
      trim: true,
    },

    // Previous values (optional)
    oldData: {
      type: mongoose.Schema.Types.Mixed,
      default: null,
    },

    // New values (optional)
    newData: {
      type: mongoose.Schema.Types.Mixed,
      default: null,
    },

    // Client IP
    ipAddress: {
      type: String,
      default: "",
    },

    // Browser / Device
    userAgent: {
      type: String,
      default: "",
    },
  },
  {
    timestamps: true,
  }
);

// Useful indexes
auditSchema.index({ user: 1, createdAt: -1 });

auditSchema.index({ entity: 1, entityId: 1 });

auditSchema.index({ action: 1 });

export default mongoose.model("Audit", auditSchema);