import mongoose from "mongoose";

const messageSchema = new mongoose.Schema(
  {
    role: {
      type: String,
      enum: ["user", "assistant"],
      required: true,
    },
    message: {
      type: String,
      required: true,
    },
    timestamp: {
      type: Date,
      default: Date.now,
    },
  },
  {
    _id: false,
  }
);

const conversationSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },
    title: {
      type: String,
      required: true,
      default: "New Chat",
    },
    isPinned: {
      type: Boolean,
      default: false,
    },
    messages: [messageSchema],
  },
  {
    timestamps: true,
  }
);

const AIConversation = mongoose.model("AIConversation", conversationSchema);
export default AIConversation;
