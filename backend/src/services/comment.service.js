import Comment from "../models/comment.model.js";

/**
 * Create Comment
 */
export const createCommentService = async (payload) => {
  const comment = await Comment.create(payload);

  return await Comment.findById(comment._id)
    .populate("author", "name email profileImage")
    .populate("ticket", "title status");
};

/**
 * Get Comments By Ticket
 */
export const getCommentsService = async (ticketId) => {
  return await Comment.find({
    ticket: ticketId,
    isDeleted: false,
  })
    .populate("author", "name email profileImage")
    .sort({ createdAt: 1 });
};

/**
 * Find Comment
 */
export const findCommentService = async (commentId) => {
  return await Comment.findOne({
    _id: commentId,
    isDeleted: false,
  })
    .populate("author", "name email profileImage")
    .populate("ticket", "title status");
};

/**
 * Update Comment
 */
export const updateCommentService = async (comment, message) => {
  comment.message = message;
  comment.isEdited = true;
  comment.editedAt = new Date();

  await comment.save();

  return await Comment.findById(comment._id)
    .populate("author", "name email profileImage")
    .populate("ticket", "title status");
};

/**
 * Soft Delete Comment
 */
export const deleteCommentService = async (comment) => {
  comment.isDeleted = true;
  comment.deletedAt = new Date();

  await comment.save();

  return true;
};