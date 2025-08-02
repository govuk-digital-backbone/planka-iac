const customJSONResponse = await fetch('./custom.json');
const customJSON = await customJSONResponse.json();

document.addEventListener("DOMContentLoaded", () => {
  const updateLink = () => {
    const link = document.querySelector('a[href="/"][class*="_logo"][class*="_title"]');
    if (link) {
      link.innerHTML = customJSON.title_text;
      return true;
    }
    return false;
  };

  // Try immediately
  if (updateLink()) return;

  // Watch for dynamic changes
  const observer = new MutationObserver(() => {
    if (updateLink()) observer.disconnect();
  });

  observer.observe(document.body, { childList: true, subtree: true });
});
