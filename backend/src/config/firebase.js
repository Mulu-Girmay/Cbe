// src/config/firebase.js
const admin = require("firebase-admin");
const path = require("path");
const fs = require("fs");

console.log("🔥 Initializing Firebase...");

try {
  // Try multiple methods to initialize

  // Method 1: Check for serviceAccountKey.json
  const keyPath = path.join(__dirname, "../../serviceAccountKey.json");

  if (fs.existsSync(keyPath)) {
    console.log("📄 Using serviceAccountKey.json");
    const serviceAccount = require(keyPath);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log("✅ Firebase initialized with service account key");
  } else {
    // Method 2: Use environment variables
    console.log("📄 Using environment variables");
    const serviceAccount = {
      projectId: process.env.FIREBASE_PROJECT_ID,
      privateKey: process.env.FIREBASE_PRIVATE_KEY?.replace(/\\n/g, "\n"),
      clientEmail: process.env.FIREBASE_CLIENT_EMAIL,
    };

    if (
      !serviceAccount.projectId ||
      !serviceAccount.privateKey ||
      !serviceAccount.clientEmail
    ) {
      throw new Error("Missing Firebase credentials in .env file");
    }

    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
    });
    console.log("✅ Firebase initialized with environment variables");
  }
} catch (error) {
  console.error("❌ Firebase initialization error:", error.message);
  console.log("\n💡 SOLUTIONS:");
  console.log("1️⃣ Download serviceAccountKey.json from Firebase Console");
  console.log("2️⃣ Place it in the backend folder");
  console.log("3️⃣ OR add these to .env:");
  console.log("   FIREBASE_PROJECT_ID=your-project-id");
  console.log('   FIREBASE_PRIVATE_KEY="your-private-key"');
  console.log("   FIREBASE_CLIENT_EMAIL=your-client-email");
  process.exit(1);
}

module.exports = admin;
