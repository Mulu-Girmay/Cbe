const pool = require("../config/database");

class Transaction {
  // Create a transaction
  static async create({
    senderAccountId,
    receiverAccountId,
    amount,
    transactionType,
    description,
    status = "completed",
  }) {
    const query = `
      INSERT INTO transactions (
        sender_account_id, 
        receiver_account_id, 
        amount, 
        transaction_type, 
        description,
        status
      )
      VALUES ($1, $2, $3, $4, $5, $6)
      RETURNING *
    `;
    const values = [
      senderAccountId,
      receiverAccountId,
      amount,
      transactionType,
      description,
      status,
    ];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async getAccountTransactions(accountId, limit = 50) {
    const query = `
      SELECT 
        t.*,
        sender_acc.account_number as sender_account_number,
        receiver_acc.account_number as receiver_account_number,
        sender_user.full_name as sender_name,
        receiver_user.full_name as receiver_name
      FROM transactions t
      LEFT JOIN accounts sender_acc ON t.sender_account_id = sender_acc.id
      LEFT JOIN accounts receiver_acc ON t.receiver_account_id = receiver_acc.id
      LEFT JOIN users sender_user ON sender_acc.user_id = sender_user.id
      LEFT JOIN users receiver_user ON receiver_acc.user_id = receiver_user.id
      WHERE t.sender_account_id = $1 OR t.receiver_account_id = $1
      ORDER BY t.created_at DESC
      LIMIT $2
    `;
    const result = await pool.query(query, [accountId, limit]);
    return result.rows;
  }
}

module.exports = Transaction;
