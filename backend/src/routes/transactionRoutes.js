const express = require("express");
const router = express.Router();
const { sendMoney } = require("../controllers/transactionController");
const verifyToken = require("../middleware/auth");

router.post("/send", verifyToken, sendMoney);

module.exports = router;
