const pool = require("../config/database");
const User = require("../models/User");
const Account = require("../models/Account");

// Handle user login/registration via Firebase
const handleAuth = async (req, res) => {
  try {
    const { uid, phone_number, email, name } = req.user;

    // Check if user exists in our database
    let user = await User.findByFirebaseUid(uid);

    if (!user) {
      // Create new user
      user = await User.create({
        firebaseUid: uid,
        fullName: name || "User",
        phoneNumber: phone_number || "",
        email: email || "",
      });

      // Create account for the user
      await Account.create({ userId: user.id });
    }

    // Get user with account details
    const userWithAccount = await User.getUserWithAccount(uid);

    res.status(200).json({
      success: true,
      user: userWithAccount,
      message: "Authentication successful",
    });
  } catch (error) {
    console.error("Auth controller error:", error);
    res.status(500).json({ error: "Internal server error" });
  }
};

module.exports = { handleAuth };
