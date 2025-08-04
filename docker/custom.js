function startSSOClicker() {
  const referrer = document.referrer;
  const isSSOReferrer = referrer && referrer.toLowerCase().includes('sso');
  if (!isSSOReferrer) {
    console.log('custom.js: not an SSO referrer, skipping SSO button click.');
    return;
  }

  const interval = 500;
  const intervalId = setInterval(() => {
    const btn = Array.from(document.querySelectorAll('button'))
      .find(b => b.textContent.includes('SSO'));
    
    if (btn) {
      btn.click();
      clearInterval(intervalId);
    }
  }, interval);
}

if (window.location.pathname === '/login') {
  setTimeout(startSSOClicker, 1000);
}
