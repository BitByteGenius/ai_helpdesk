import dotenv from "dotenv";
import mongoose from "mongoose";
import app from "./app.js";
import http from "http";

import { initializeSocket } from "../socket/socket.js";

const server = http.createServer(app);
initializeSocket(server);


dotenv.config();

// Connect MongoDB
mongoose.connect(process.env.MONGO_URI)
  .then(() => console.log("MongoDB Connected"))
  .catch(console.error);

const PORT = process.env.PORT || 3000;

server.listen(PORT, () => {
  console.log(`Server running on ${PORT}`);
});