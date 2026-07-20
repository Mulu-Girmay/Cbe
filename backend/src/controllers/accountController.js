const User = require("../models/User");
const Account = require("../models/Account");
const Transaction = require("../models/Transaction");

// Get user account details
const getAccountDetails = async (req, res) => {
  try {
    const { uid } = req.user;
    const user = await User.getUserWithAccount(uid);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    res.status(200).json({
      success: true,
      data: {
        name: user.full_name,
        phone: user.phone_number,
        email: user.email,
        account: {
          number: user.account_number,
          type: user.account_type,
          balance: parseFloat(user.balance) || 0,
        },
      },
    });
  } catch (error) {
    console.error("Get account error:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

// Get transaction history
const getTransactionHistory = async (req, res) => {
  try {
    const { uid } = req.user;
    const user = await User.findByFirebaseUid(uid);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const account = await Account.findByUserId(user.id);
    const transactions = await Transaction.getAccountTransactions(account.id);

    res.status(200).json({
      success: true,
      data: transactions,
    });
  } catch (error) {
    console.error("Get transactions error:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = { getAccountDetails, getTransactionHistory };
