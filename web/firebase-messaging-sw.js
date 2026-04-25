importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/10.12.2/firebase-messaging-compat.js');

firebase.initializeApp({
  apiKey: 'AIzaSyCw6QVH4ss4_a6Hh7eD3in36YJ5D_okO4o',
  authDomain: 'kickchain-app.firebaseapp.com',
  projectId: 'kickchain-app',
  storageBucket: 'kickchain-app.firebasestorage.app',
  messagingSenderId: '783897051932',
  appId: '1:783897051932:web:29aaa8e11efa2e62ec30d9',
  measurementId: 'G-TK4HZ446X7',
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage((payload) => {
  const notification = payload.notification || {};
  const title = notification.title || 'Kickchain';
  const options = {
    body: notification.body || '',
    icon: notification.icon || '/icons/Icon-192.png',
    data: payload.data || {},
  };

  self.registration.showNotification(title, options);
});
