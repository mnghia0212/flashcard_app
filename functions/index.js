const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendDailyNotifications = functions.pubsub
    .schedule("every 24 hours")
    .timeZone("Asia/Ho_Chi_Minh")
    .onRun(async (context) => {
      const usersRef = admin.firestore().collection("users");
      const snapshot = await usersRef.get();
      const today = new Date();
      today.setHours(0, 0, 0, 0);
      const notifications = [];
      for (const doc of snapshot.docs) {
        const userData = doc.data();
        const lastStudyDate = userData.lastStudyDate ?
        new Date(userData.lastStudyDate) : null;
        // Kiểm tra nếu người dùng chưa học hôm nay
        if (lastStudyDate && lastStudyDate.
            toDateString() !== today.toDateString()) {
          const fcmToken = userData.deviceToken;

          // Chỉ gửi thông báo nếu token hợp lệ
          if (fcmToken) {
            const payload = {
              notification: {
                title: "Hãy tiếp tục ôn tập!",
                body: "Bạn chưa học tập hôm nay. Hãy vào ôn tập bạn nhé!",
              },
              token: fcmToken,
            };

            // Thêm thông báo vào danh sách promise để xử lý đồng thời
            notifications.push(admin.messaging().send(payload)
                .then(() => {
                  console.log(`Notification sent to ${doc.id}`);
                })
                .catch((error) => {
                  console.error(`Error send notification to ${doc.id}:`, error);
                }));
          }
        }
      }

      // Đợi tất cả các thông báo được gửi
      await Promise.all(notifications);
      console.log("All notifications processed.");
    });
