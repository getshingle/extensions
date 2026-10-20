// SPDX-License-Identifier: MIT
// Gallery: a photo opens large over the page. It grows out of its small picture
// and shrinks back into it when it closes. Arrow keys or the buttons go to the
// next and previous photo; Escape, the close button or a click beside the photo
// close it. Without this script, a photo opens as a file.
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
    const extras = [caption, ...box.querySelectorAll('button')];
    const still = matchMedia('(prefers-reduced-motion: reduce)');
    const time = 280, ease = 'cubic-bezier(.2, .9, .3, 1)', large = { transform: 'none', clipPath: 'inset(0px 0px round 0px)' };
    let links = [], index = 0, shade = '', closing = false, opening = 0;

    const show = (i) => {
      index = (i + links.length) % links.length;
      const link = links[index];
      img.src = link.href;
      img.alt = link.querySelector('img').alt;
      caption.textContent = link.closest('figure').querySelector('figcaption')?.textContent || '';
    };

    // How to put the large photo exactly over its small picture: moved, made
    // smaller and cut to the part the small picture shows. Nothing when the
    // small picture is not on the screen.
    const small = (link) => {
      const thumb = link.querySelector('img').getBoundingClientRect();
      const frame = link.getBoundingClientRect(), big = img.getBoundingClientRect();
      if (!big.width || !thumb.width || frame.bottom < 0 || frame.top > innerHeight) return null;
      const scale = Math.max(thumb.width / big.width, thumb.height / big.height);
      const x = (frame.left + frame.width / 2) - (big.left + big.width / 2);
      const y = (frame.top + frame.height / 2) - (big.top + big.height / 2);
      const sides = (big.width - frame.width / scale) / 2, ends = (big.height - frame.height / scale) / 2;
      const round = (parseFloat(getComputedStyle(link).borderTopLeftRadius) || 0) / scale;
      return { transform: `translate(${x}px, ${y}px) scale(${scale})`, clipPath: `inset(${ends}px ${sides}px round ${round}px)` };
    };

    // The dark background and the buttons fade in or out with the photo.
    const fade = (into, options) => {
      const dark = [{ backgroundColor: 'transparent' }, { backgroundColor: shade }];
      box.animate(into ? dark : dark.reverse(), options);
      for (const el of extras) el.animate([{ opacity: into ? 0 : 1 }, { opacity: into ? 1 : 0 }], options);
    };

    const open = async (all, i) => {
      const turn = ++opening;
      links = all;
      show(i);
      // Wait until the photo is ready, so it has its size when it starts to grow.
      try { await img.decode(); } catch { /* opens without growing */ }
      if (turn !== opening) return;
      closing = false;
      box.showModal();
      if (still.matches) return;
      shade = getComputedStyle(box).backgroundColor;
      const start = small(links[index]);
      img.animate(start ? [start, large] : [{ opacity: 0, transform: 'scale(.96)' }, { opacity: 1 }], { duration: time, easing: ease });
      fade(true, { duration: time, easing: 'ease-out' });
    };

    const close = () => {
      if (!box.open || closing) return;
      if (still.matches) return box.close();
      closing = true;
      for (const animation of box.getAnimations({ subtree: true })) animation.finish();
      const end = small(links[index]), options = { duration: time * .8, easing: ease, fill: 'forwards' };
      const shrink = img.animate(end ? [large, end] : [{ opacity: 1 }, { opacity: 0, transform: 'scale(.96)' }], options);
      fade(false, options);
      shrink.finished.then(() => box.close(), () => {});
    };

    const step = (by) => {
      show(index + by);
      if (!still.matches) img.animate([{ opacity: .3 }, { opacity: 1 }], { duration: 160, easing: 'ease-out' });
    };

    for (const list of lists) {
      const all = [...list.querySelectorAll('a')];
      all.forEach((link, i) => link.addEventListener('click', (event) => {
        event.preventDefault();
        open(all, i);
      }));
    }
    box.querySelector('.close').addEventListener('click', close);
    box.querySelector('.prev').addEventListener('click', () => step(-1));
    box.querySelector('.next').addEventListener('click', () => step(1));
    box.addEventListener('click', (event) => { if (event.target === box) close(); });
    box.addEventListener('cancel', (event) => { if (event.cancelable) { event.preventDefault(); close(); } });
    box.addEventListener('close', () => {
      closing = false;
      for (const animation of box.getAnimations({ subtree: true })) animation.cancel();
    });
    box.addEventListener('keydown', (event) => {
      if (event.key === 'ArrowLeft') step(-1);
      if (event.key === 'ArrowRight') step(1);
    });
  }
}
