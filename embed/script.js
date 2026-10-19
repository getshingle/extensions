// SPDX-License-Identifier: MIT
// Embed: the video, map or calendar loads only when the visitor presses the
// button. Without this script, the link opens it on its own website instead.
for (const frame of document.querySelectorAll('.embed-frame[data-src]')) {
  const button = frame.querySelector('button');
  button.hidden = false;
  button.addEventListener('click', () => {
    const iframe = document.createElement('iframe');
    iframe.src = frame.dataset.src;
    iframe.title = frame.dataset.title;
    iframe.allow = 'autoplay; fullscreen; picture-in-picture; encrypted-media';
    iframe.allowFullscreen = true;
    iframe.referrerPolicy = 'strict-origin-when-cross-origin';
    frame.replaceChildren(iframe);
    frame.classList.add('loaded');
  });
}
