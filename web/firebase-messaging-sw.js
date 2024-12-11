// Import Firebase scripts
importScripts('https://www.gstatic.com/firebasejs/15.0.4/firebase-app.js');
importScripts('https://www.gstatic.com/firebasejs/15.0.4/firebase-messaging.js');

// Configurer Firebase
firebase.initializeApp({
  apiKey: "AIzaSyDxzl0pVsv42ImwY3qngOCgOUF9kP-xwpg",
  authDomain: "future-job1.firebaseapp.com",
  projectId: "future-job1",
  storageBucket: "future-job1.firebasestorage.app",
  messagingSenderId: "1040896015340",
  appId: "1:1040896015340:web:16cfbab584c7b3bd721ec9",
});

// Obtenez une instance de Firebase Messaging
const messaging = firebase.messaging();

// Gérer les messages en arrière-plan
messaging.onBackgroundMessage((payload) => {
  console.log('Message reçu en arrière-plan:', payload);

  // Vérifier si le payload contient des notifications
  if (payload.notification) {
    const { title, body, icon, badge } = payload.notification;

    // Extraire les informations du payload
    const options = {
      body: body,
      icon: icon || '/default-icon.png',  // icône par défaut si nécessaire
      badge: badge || '/default-badge.png' //  badge par défaut
    };

    // Afficher la notification
    self.registration.showNotification(title, options);
  } else {
    console.error('Aucune notification dans le payload');
  }
});
