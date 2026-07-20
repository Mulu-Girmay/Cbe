const express = require("express");
const router = express.Router();
const { handleAuth } = require("../controllers/authController");
const verifyToken = require("../middleware/auth");

router.post("/login", verifyToken, handleAuth);

module.exports = router;
