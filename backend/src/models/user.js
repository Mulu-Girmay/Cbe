const pool = require("../config/database");

class User {
  static async create({ firebaseUid, fullName, phoneNumber, email }) {
    const query = `
      INSERT INTO users (firebase_uid, full_name, phone_number, email)
      VALUES ($1, $2, $3, $4)
      RETURNING *
    `;
    const values = [firebaseUid, fullName, phoneNumber, email];
    const result = await pool.query(query, values);
    return result.rows[0];
  }

  static async findByFirebaseUid(firebaseUid) {
    const query = "SELECT * FROM users WHERE firebase_uid = $1";
    const result = await pool.query(query, [firebaseUid]);
    return result.rows[0];
  }

  static async findById(id) {
    const query = "SELECT * FROM users WHERE id = $1";
    const result = await pool.query(query, [id]);
    return result.rows[0];
  }

  static async getUserWithAccount(firebaseUid) {
    const query = `
      SELECT 
        u.*,
        a.id as account_id,
        a.account_number,
        a.balance,
        a.account_type
      FROM users u
      LEFT JOIN accounts a ON u.id = a.user_id
      WHERE u.firebase_uid = $1
    `;
    const result = await pool.query(query, [firebaseUid]);
    return result.rows[0];
  }
}

module.exports = User;
