/*
  importScripts ('https://www.gstatic.com/firebasejs/9.8.2/firebase-app.js');
  importScripts ('https://www.gstatic.com/firebasejs/9.8.2/firebase-analytics.js');

  firebase.initializeApp({
      apiKey: "AIzaSyCCSP7ABxzPZ96KGYFwfvBpw1EK3KB41jo",
      authDomain: "tsmcarta.firebaseapp.com",
      projectId: "tsmcarta",
      storageBucket: "tsmcarta.appspot.com",
      messagingSenderId: "615051482629",
      appId: "1:615051482629:web:c07a1f9e8f85a75f872e6c",
      measurementId: "G-7EK7DVYBSN"
  });

const messaging = firebase.messaging();*/
if ('serviceWorker' in navigator) {
navigator.serviceWorker.register('./firebase-messaging-sw.js')
  .then(function(registration) {
    console.log('Registration successful, scope is:', registration.scope);
  }).catch(function(err) {
    console.log('Service worker registration failed, error:', err);
  });
}