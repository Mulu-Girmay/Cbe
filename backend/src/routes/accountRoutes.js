const express = require("express");
const router = express.Router();
const {
  getAccountDetails,
  getTransactionHistory,
} = require("../controllers/accountController");
const verifyToken = require("../middleware/auth");

router.get("/profile", verifyToken, getAccountDetails);
router.get("/transactions", verifyToken, getTransactionHistory);

module.exports = router;
