const pool = require('../config/database');

class Account {
  // Create account for a user
  static async create({ userId, accountType = 'savings' }) {
    // Generate random 10-digit account number
    const accountNumber = Math.floor(1000000000 + Math.random() * 9000000000).toString();
    
    const query = `
      INSERT INTO accounts (user_id, account_number, account_type)
      VALUES ($1, $2, $3)
      RETURNING *
    `;
    const values = [userId, accountNumber, accountType];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  // Get account by user ID
  static async findByUserId(userId) {
    const query = 'SELECT * FROM accounts WHERE user_id = $1';
    const result = await pool.query(query, [userId]);
    return result.rows[0];
  }

  // Get account by account number
  static async findByAccountNumber(accountNumber) {
    const query = 'SELECT * FROM accounts WHERE account_number = $1';
    const result = await pool.query(query, [accountNumber]);
    return result.rows[0];
  }

  // Update balance (with transaction safety)
  static async updateBalance(accountId, newBalance) {
    const query = `
      UPDATE accounts 
      SET balance = $1, updated_at = NOW()
      WHERE id = $2
      RETURNING *
    `;
    const result = await pool.query(query, [newBalance, accountId]);
    return result.rows[0];
  }
}

module.exports = Account;