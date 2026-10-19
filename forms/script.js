// SPDX-License-Identifier: MIT
// Forms: a form without a form service says so instead of failing.
for (const form of document.querySelectorAll('form[data-unconfigured]')) {
  form.addEventListener('submit', (event) => {
    event.preventDefault();
    form.querySelector('.form-note').textContent =
      'This form is not connected to a form service yet, so nothing was sent.';
  });
}
