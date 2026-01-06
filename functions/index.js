const { onSchedule } = require('firebase-functions/v2/scheduler');
const { initializeApp } = require('firebase-admin/app');
const { getFirestore, Timestamp } = require('firebase-admin/firestore');
const { getMessaging } = require('firebase-admin/messaging');

initializeApp();

/**
 * Reminder doc shape (Firestore):
 * reminders/{id}:
 *  - uid: string
 *  - token: string (FCM)
 *  - title: string
 *  - body: string
 *  - reminderAt: Timestamp
 *  - sent: boolean
 *  - createdAt: Timestamp
 */
exports.sendDueReminders = onSchedule(
  {
    schedule: 'every 1 minutes',
    timeZone: 'UTC',
    region: 'asia-southeast2',
  },
  async () => {
    const db = getFirestore();
    const now = Timestamp.now();

    const snap = await db
      .collection('reminders')
      .where('sent', '==', false)
      .where('reminderAt', '<=', now)
      .limit(200)
      .get();

    if (snap.empty) return;

    const messaging = getMessaging();

    const batch = db.batch();
    const sends = [];

    snap.docs.forEach((doc) => {
      const data = doc.data();
      const token = data.token;
      if (!token) {
        batch.update(doc.ref, {
          sent: true,
          sentAt: now,
          error: 'missing-token',
        });
        return;
      }

      sends.push(
        messaging
          .send({
            token,
            notification: {
              title: data.title || 'Task Reminder',
              body: data.body || 'You have a task reminder',
            },
            android: {
              priority: 'high',
              notification: {
                channelId: 'tasks_channel',
              },
            },
          })
          .then((messageId) => {
            batch.update(doc.ref, {
              sent: true,
              sentAt: now,
              messageId,
            });
          })
          .catch((err) => {
            // Mark as sent=true to avoid retry loops; you can change to sent=false for retries.
            batch.update(doc.ref, {
              sent: true,
              sentAt: now,
              error: String(err?.message || err),
            });
          })
      );
    });

    await Promise.allSettled(sends);
    await batch.commit();
  }
);
