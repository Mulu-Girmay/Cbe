// test-firebase.js
console.log("🧪 Testing Firebase...");

try {
  const admin = require("firebase-admin");
  const path = require("path");
  const fs = require("fs");

  console.log("✅ firebase-admin loaded");
  console.log("📦 Version:", require("firebase-admin/package.json").version);
  console.log("📁 admin.credential exists?", !!admin.credential);
  console.log("📁 admin.credential.cert exists?", !!admin.credential?.cert);

  // Check for service account file
  const keyPath = path.join(__dirname, "serviceAccountKey.json");
  console.log("📄 Looking for key at:", keyPath);

  if (!fs.existsSync(keyPath)) {
    console.log("❌ serviceAccountKey.json not found!");
    console.log("\n📋 Please download from Firebase Console and save as:");
    console.log("   ", keyPath);
    process.exit(1);
  }

  console.log(" serviceAccountKey.json found");

  const serviceAccount = require(keyPath);
  console.log("Service account loaded");
  console.log("Project ID:", serviceAccount.project_id);

  // Initialize
  admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
  });

  console.log("Firebase initialized successfully!");
  console.log("Everything is working!");

  process.exit(0);
} catch (error) {
  console.error("Error:", error.message);
  console.error("Full error:", error);
  process.exit(1);
}
