const pool = require("../config/database");
const User = require("../models/User");
const Account = require("../models/Account");
const Transaction = require("../models/Transaction");

// Send money
const sendMoney = async (req, res) => {
  const client = await pool.connect();

  try {
    const { uid } = req.user;
    const { receiverAccountNumber, amount, description } = req.body;

    // Validate input
    if (!receiverAccountNumber || !amount || amount <= 0) {
      return res.status(400).json({ error: "Invalid input" });
    }

    // Get sender
    const sender = await User.findByFirebaseUid(uid);
    if (!sender) {
      return res.status(404).json({ error: "Sender not found" });
    }

    // Get sender's account
    const senderAccount = await Account.findByUserId(sender.id);
    if (!senderAccount) {
      return res.status(404).json({ error: "Sender account not found" });
    }

    // Check balance
    if (senderAccount.balance < amount) {
      return res.status(400).json({ error: "Insufficient balance" });
    }

    // Get receiver's account
    const receiverAccount = await Account.findByAccountNumber(
      receiverAccountNumber,
    );
    if (!receiverAccount) {
      return res.status(404).json({ error: "Receiver account not found" });
    }

    // Prevent self-transfer
    if (senderAccount.id === receiverAccount.id) {
      return res.status(400).json({ error: "Cannot transfer to yourself" });
    }

    // Start transaction (ACID)
    await client.query("BEGIN");

    // Deduct from sender
    const senderNewBalance = senderAccount.balance - amount;
    await Account.updateBalance(senderAccount.id, senderNewBalance);

    // Add to receiver
    const receiverNewBalance = receiverAccount.balance + amount;
    await Account.updateBalance(receiverAccount.id, receiverNewBalance);

    // Create transaction record
    const transaction = await Transaction.create({
      senderAccountId: senderAccount.id,
      receiverAccountId: receiverAccount.id,
      amount: amount,
      transactionType: "transfer",
      description: description || "Money transfer",
      status: "completed",
    });

    await client.query("COMMIT");

    res.status(200).json({
      success: true,
      data: {
        transaction,
        senderBalance: senderNewBalance,
        receiverBalance: receiverNewBalance,
      },
    });
  } catch (error) {
    await client.query("ROLLBACK");
    console.error("Send money error:", error);
    res.status(500).json({ error: "Transaction failed" });
  } finally {
    client.release();
  }
};

module.exports = { sendMoney };
