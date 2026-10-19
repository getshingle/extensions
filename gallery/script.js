// SPDX-License-Identifier: MIT
// Gallery: a photo opens large over the page. Arrow keys or the buttons go to
// the next and previous photo; Escape, the close button or a click beside the
// photo close it. Without this script, a photo opens as a file.
{
  const lists = document.querySelectorAll('.photos');
  if (lists.length) {
    const box = document.createElement('dialog');
    box.className = 'lightbox';
    box.innerHTML = '<figure><img alt=""><figcaption></figcaption></figure>'
      + '<button type="button" class="close" aria-label="Close">×</button>'
      + '<button type="button" class="prev" aria-label="Previous photo">‹</button>'
      + '<button type="button" class="next" aria-label="Next photo">›</button>';
    document.body.append(box);
    const img = box.querySelector('img'), caption = box.querySelector('figcaption');
    let links = [], index = 0;
    const show = (i) => {
      index = (i + links.length) % links.length;
      const link = links[index];
      img.src = link.href;
      img.alt = link.querySelector('img').alt;
      caption.textContent = link.closest('figure').querySelector('figcaption')?.textContent || '';
    };
    for (const list of lists) {
      const all = [...list.querySelectorAll('a')];
      all.forEach((link, i) => link.addEventListener('click', (event) => {
        event.preventDefault();
        links = all;
        show(i);
        box.showModal();
      }));
    }
    box.querySelector('.close').addEventListener('click', () => box.close());
    box.querySelector('.prev').addEventListener('click', () => show(index - 1));
    box.querySelector('.next').addEventListener('click', () => show(index + 1));
    box.addEventListener('click', (event) => { if (event.target === box) box.close(); });
    box.addEventListener('keydown', (event) => {
      if (event.key === 'ArrowLeft') show(index - 1);
      if (event.key === 'ArrowRight') show(index + 1);
    });
  }
}
