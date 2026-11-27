'use strict';

const PATTERNS = [
  ['Replacement', '#1d70b8'],
  ['Absorption', '#b85c00'],
  ['Amalgamation', '#6f3c97'],
  ['Split', '#00706b'],
  ['Spin-out', '#a8326b'],
  ['Transfer between continuing establishments', '#4c2c92'],
  ['Complex reorganisation', '#383f43'],
];
const PAIR_ONLY = 'Pair without a reorganisation';
const COLOUR = Object.assign(Object.fromEntries(PATTERNS), { [PAIR_ONLY]: '#505a5f' });
const OUTCOME_CLASS = { Closed: 'closed', Predecessor: 'closed', Opened: 'opened', Successor: 'opened', Recipient: 'opened', Continued: 'continued', Origin: 'continued' };
const OUTCOME_COLOUR = { closed: '#505a5f', opened: '#1d70b8', continued: '#00703c' };

const input = document.getElementById('urn-input');
const clearButton = document.getElementById('clear');
const connectedBox = document.getElementById('connected-input');
const promptPanel = document.getElementById('prompt');
const summary = document.getElementById('summary');
const chips = document.getElementById('chips');
const message = document.getElementById('message');
const timeline = document.getElementById('timeline');

const hidden = new Set();
let data = null;
let requestNumber = 0;
let debounce;

function el(tag, props, ...children) {
  const node = document.createElement(tag);
  for (const [key, value] of Object.entries(props || {})) {
    if (key === 'class') node.className = value;
    else if (key === 'style') node.style.cssText = value;
    else if (key.startsWith('on')) node.addEventListener(key.slice(2), value);
    else node.setAttribute(key, value);
  }
  for (const child of children.flat()) {
    if (child == null) continue;
    node.append(child.nodeType ? child : document.createTextNode(String(child)));
  }
  return node;
}

function patternOf(item) {
  return item.pattern || PAIR_ONLY;
}

function formatDate(iso) {
  const [y, m, d] = iso.split('-').map(Number);
  return new Date(Date.UTC(y, m - 1, d)).toLocaleDateString('en-GB', { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'UTC' });
}

function plural(n, word) {
  return n + ' ' + word + (n === 1 ? '' : 's');
}

function renderChips() {
  chips.replaceChildren(...PATTERNS.map(([name, colour]) => el('button', {
    type: 'button', class: 'chip', 'aria-pressed': hidden.has(name) ? 'false' : 'true',
    onclick: () => { hidden.has(name) ? hidden.delete(name) : hidden.add(name); renderChips(); render(); },
  }, el('span', { class: 'swatch', style: 'background:' + colour }), name)));
}

function showMessage(title, text) {
  document.getElementById('message-title').textContent = title;
  document.getElementById('message-text').textContent = text;
  message.hidden = false;
}

function arrowSvg() {
  const ns = 'http://www.w3.org/2000/svg';
  const svg = document.createElementNS(ns, 'svg');
  svg.setAttribute('width', '24'); svg.setAttribute('height', '16'); svg.setAttribute('viewBox', '0 0 24 16'); svg.setAttribute('aria-hidden', 'true');
  const path = document.createElementNS(ns, 'path');
  path.setAttribute('d', 'M2 8h18M15 3l5 5-5 5');
  path.setAttribute('fill', 'none'); path.setAttribute('stroke', '#0b0c0c'); path.setAttribute('stroke-width', '2');
  path.setAttribute('stroke-linecap', 'round'); path.setAttribute('stroke-linejoin', 'round');
  svg.append(path);
  return svg;
}

function personBox(p) {
  const cls = OUTCOME_CLASS[p.outcome] || 'opened';
  const tag = [p.isEntered ? 'This establishment' : null, p.outcome, p.effects.length ? p.effects.join(', ').toLowerCase() : null]
    .filter(Boolean).join(' · ');
  return el('div', { class: 'person ' + cls + (p.isEntered ? ' entered' : ''), style: 'border-left-color:' + OUTCOME_COLOUR[cls] },
    el('span', { class: 'name' }, p.urn + ' ' + p.name),
    el('span', { class: 'tag', style: 'color:' + OUTCOME_COLOUR[cls] }, tag));
}

function card(item, entered) {
  const colour = COLOUR[patternOf(item)];
  const relation = item.direct
    ? el('span', { class: 'relation direct' }, 'Direct: ' + entered.urn + ' ' + entered.name + ' took part')
    : el('span', { class: 'relation' }, 'Connected through ' + (item.via ? item.via.urn + ' ' + item.via.name : 'another establishment'));
  const from = item.participants.filter((p) => p.side === 'from');
  const to = item.participants.filter((p) => p.side === 'to');

  return el('article', { class: 'card' },
    el('div', { class: 'card-head' },
      el('div', { class: 'card-title' }, el('h2', {}, item.title), relation),
      el('div', { class: 'badges' },
        el('span', { class: 'badge', style: 'background:' + colour }, patternOf(item)),
        item.cause ? el('span', { class: 'badge outline' }, item.cause) : null)),
    el('div', { class: 'flow' },
      el('div', { class: 'side' }, from.map(personBox)),
      el('div', { class: 'arrow' }, arrowSvg()),
      el('div', { class: 'side' }, to.map(personBox))),
    item.pairs.length ? el('div', { class: 'pairs' }, item.pairs.map((pr) => el('span', {},
      el('span', { class: 'key-line' + (pr.kind === 'transfer' ? ' dashed' : '') }),
      (pr.kind === 'succession' ? 'Succession: ' : 'Provision transfer: ') + pr.fromUrn + ' to ' + pr.toUrn))) : null,
    item.note ? el('p', { class: 'note' }, item.note) : null);
}

function render() {
  message.hidden = true;
  timeline.hidden = true;
  summary.hidden = true;
  promptPanel.hidden = data !== null;
  if (!data) return;

  if (data.error) {
    showMessage('Something went wrong', data.error);
    return;
  }
  if (!data.found) {
    showMessage('No reorganisations found', 'URN ' + data.urn + ' did not take part in any reorganisation we hold. Check the number and try again.');
    return;
  }
  const entered = data.establishment;
  const direct = data.items.filter((i) => i.direct).length;
  const linked = data.items.length - direct;
  if (data.items.length === 0) {
    showMessage('No reorganisations found', 'URN ' + entered.urn + ' did not take part in any reorganisation we hold. Check the number and try again.');
    return;
  }
  summary.textContent = 'Showing ' + plural(direct, 'reorganisation') + ' for ' + entered.urn + ' ' + entered.name
    + (linked ? ', and ' + linked + ' connected' : '')
    + (data.truncated ? '. The connected search stopped early because the family is very large.' : '');
  summary.hidden = false;

  const shown = data.items.filter((i) => !hidden.has(patternOf(i)));
  if (shown.length === 0) {
    showMessage('No reorganisations found', 'All matching reorganisations are hidden by the pattern filters above.');
    return;
  }

  const yearOf = (i) => (i.date ? Number(i.date.slice(0, 4)) : 'undated');
  const rows = [];
  let lastYear;
  for (const item of shown) {
    const y = yearOf(item);
    if (y !== lastYear) {
      if (typeof lastYear === 'number' && typeof y === 'number' && lastYear - y > 1) {
        rows.push(el('div', { class: 'row gap' }, el('span'), el('div', { class: 'gap-spine' }, el('span')),
          el('span', { class: 'gap-label' }, 'No reorganisations recorded ' + (y + 1) + (lastYear - y > 2 ? ' to ' + (lastYear - 1) : ''))));
      }
      const count = shown.filter((x) => yearOf(x) === y).length;
      rows.push(el('div', { class: 'row year' },
        el('span', { class: 'year-label' }, y === 'undated' ? 'Undated' : String(y)),
        el('div', { class: 'year-spine' }, el('span', { class: 'line' }), el('span', { class: 'dot' }), el('span', { class: 'line' })),
        el('span', { class: 'year-sub' }, plural(count, 'reorganisation') + (y === 'undated' ? ' without a reviewed date' : ''))));
      lastYear = y;
    }
    const colour = COLOUR[patternOf(item)];
    rows.push(el('div', { class: 'row' },
      el('span', { class: 'when' }, item.date ? formatDate(item.date) : 'Date to review'),
      el('div', { class: 'event-spine' }, el('span', { class: 'top' }),
        el('span', { class: 'marker', style: 'background:' + colour + ';box-shadow:0 0 0 2px ' + colour + (item.date ? '' : ';opacity:0.6') }),
        el('span', { class: 'rest' })),
      card(item, entered)));
  }
  rows.push(el('div', { class: 'row end' }, el('span'), el('div', { class: 'end-spine' }, el('span')),
    el('span', { class: 'end-label' }, 'End of timeline')));
  timeline.replaceChildren(...rows);
  timeline.hidden = false;
}

async function load() {
  const urn = input.value.trim();
  clearButton.hidden = urn === '';
  const url = new URL(window.location.href);
  if (urn) url.searchParams.set('urn', urn); else url.searchParams.delete('urn');
  window.history.replaceState(null, '', url);
  if (!urn) { data = null; render(); return; }

  const mine = ++requestNumber;
  try {
    const response = await fetch('/api/timeline?urn=' + encodeURIComponent(urn) + '&connected=' + connectedBox.checked);
    const body = await response.json();
    if (mine !== requestNumber) return;
    data = response.ok ? body : { error: body.error || ('The server returned ' + response.status + '.') };
  } catch (e) {
    if (mine !== requestNumber) return;
    data = { error: 'Could not reach the timeline service. Is it still running?' };
  }
  render();
}

input.addEventListener('input', () => {
  input.value = input.value.replace(/[^0-9]/g, '');
  clearTimeout(debounce);
  debounce = setTimeout(load, 300);
});
document.getElementById('search').addEventListener('submit', (e) => { e.preventDefault(); clearTimeout(debounce); load(); });
clearButton.addEventListener('click', () => { input.value = ''; load(); input.focus(); });
connectedBox.addEventListener('change', load);

renderChips();
input.value = (new URLSearchParams(window.location.search).get('urn') || '').replace(/[^0-9]/g, '');
load();
