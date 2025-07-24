const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onRequest } = require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const admin = require("firebase-admin");

// Initialize Firebase Admin
admin.initializeApp();
setGlobalOptions({ maxInstances: 10 });

/**
 * Scheduled function to reset `coming` and `going` values of each pass.
 * Runs every day at 12:00 AM IST.
 */
exports.resetPassValues = onSchedule("every day 00:00", {
  timeZone: "Asia/Kolkata",
}, async (event) => {
  const db = admin.firestore();
  console.log("🔁 Reset function started...");

  const studentsSnapshot = await db.collection("students").get();

  for (const studentDoc of studentsSnapshot.docs) {
    const studentData = studentDoc.data();

    if (studentData.pass && Array.isArray(studentData.pass)) {
      const updatedPasses = studentData.pass.map((p) => ({
        ...p,
        coming: 0,
        going: 0,
      }));

      await studentDoc.ref.update({ pass: updatedPasses });
    }
  }

  console.log("✅ All pass values reset to 0.");
});


/**
 * Manual reset function (for testing).
 * Trigger this by visiting its URL.
 */
exports.manualReset = onRequest(async (req, res) => {
  const db = admin.firestore();
  console.log("🚀 Manual reset started...");

  const studentsSnapshot = await db.collection("students").get();

  for (const studentDoc of studentsSnapshot.docs) {
    const studentData = studentDoc.data();

    if (studentData.pass && Array.isArray(studentData.pass)) {
      const updatedPasses = studentData.pass.map((p) => ({
        ...p,
        coming: 0,
        going: 0,
      }));

      await studentDoc.ref.update({ pass: updatedPasses });
    }
  }

  console.log("✅ Manual reset complete.");
  res.send("✅ Manual reset complete.");
});
