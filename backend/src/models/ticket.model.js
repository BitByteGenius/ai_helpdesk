import mongoose from "mongoose";

const attachmentSchema = new mongoose.Schema(
  {
    url: {
      type: String,
      required: true,
    },

    fileName: {
      type: String,
      required: true,
      trim: true,
    },

    fileType: {
      type: String,
      default: "",
    },

    fileSize: {
      type: Number,
      default: 0,
    },
  },
  {
    _id: false,
  }
);

const ticketSchema = new mongoose.Schema(
  {
    title: {
      type: String,
      required: [true, "Title is required"],
      trim: true,
      minlength: 5,
      maxlength: 150,
    },

    description: {
      type: String,
      required: [true, "Description is required"],
      trim: true,
      minlength: 10,
      maxlength: 5000,
    },

    category: {
      type: String,
      enum: [
        "Hardware",
        "Software",
        "Network",
        "Email",
        "Security",
        "Account",
        "Printer",
        "Internet",
        "Other",
      ],
      default: "Other",
    },

    priority: {
      type: String,
      enum: ["Low", "Medium", "High", "Critical"],
      default: "Medium",
    },

    status: {
      type: String,
      enum: [
        "Open",
        "Assigned",
        "In Progress",
        "Resolved",
        "Closed",
        "Rejected",
      ],
      default: "Open",
    },

    attachments: {
      type: [attachmentSchema],
      default: [],
    },

    createdBy: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    assignedTo: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      default: null,
      index: true,
    },

    aiSummary: {
      type: String,
      default: "",
      trim: true,
    },

    aiSuggestedReply: {
      type: String,
      default: "",
      trim: true,
    },

    aiConversationTranscript: {
      type: String,
      default: "",
    },

    aiConfidence: {
      type: String,
      default: "Medium",
    },

    aiSuggestedRootCause: {
      type: String,
      default: "",
    },

    aiTroubleshootingAttempted: {
      type: String,
      default: "",
    },

    duplicateTicket: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "Ticket",
      default: null,
    },

    isDeleted: {
      type: Boolean,
      default: false,
      index: true,
    },

    deletedAt: {
      type: Date,
      default: null,
    },
  },
  {
    timestamps: true,
  }
);

// Compound index for filtering
ticketSchema.index({
  status: 1,
  priority: 1,
  category: 1,
});

// Text search index
ticketSchema.index({
  title: "text",
  description: "text",
});

const Ticket = mongoose.model("Ticket", ticketSchema);

export default Ticket;