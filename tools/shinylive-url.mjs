// Usage: node tools/shinylive-url.mjs app.R [more files...] > link.tex
// Prints \def\ShinyliveUrl{...}: the files, compressed into a https://shinylive.io/r/app/ link.
// The compression is lz-string's compressToEncodedURIComponent (MIT, Pieroxy), which shinylive decodes.
import { readFileSync } from 'node:fs';
import { basename } from 'node:path';

const alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+-$';

function compress(input) {
  const dictionary = new Map();
  const toCreate = new Set();
  let w = '';
  let enlargeIn = 2;
  let dictSize = 3;
  let numBits = 2;
  let value = 0;
  let position = 0;
  const out = [];

  const emit = (bits, data) => {
    for (let i = 0; i < bits; i++) {
      value = (value << 1) | (data & 1);
      if (++position === 6) {
        out.push(alphabet[value]);
        position = 0;
        value = 0;
      }
      data >>= 1;
    }
  };
  const emitPhrase = (phrase) => {
    if (toCreate.has(phrase)) {
      const code = phrase.charCodeAt(0);
      const wide = code >= 256;
      emit(numBits, wide ? 1 : 0);
      emit(wide ? 16 : 8, code);
      if (--enlargeIn === 0) {
        enlargeIn = 2 ** numBits;
        numBits++;
      }
      toCreate.delete(phrase);
    } else {
      emit(numBits, dictionary.get(phrase));
    }
    if (--enlargeIn === 0) {
      enlargeIn = 2 ** numBits;
      numBits++;
    }
  };

  for (const c of input) {
    for (const unit of c.length > 1 ? c.split('') : [c]) {
      if (!dictionary.has(unit)) {
        dictionary.set(unit, dictSize++);
        toCreate.add(unit);
      }
      const wc = w + unit;
      if (dictionary.has(wc)) {
        w = wc;
      } else {
        emitPhrase(w);
        dictionary.set(wc, dictSize++);
        w = unit;
      }
    }
  }
  if (w !== '') emitPhrase(w);
  emit(numBits, 2);
  while (true) {
    value <<= 1;
    if (position === 5) {
      out.push(alphabet[value]);
      break;
    }
    position++;
  }
  return out.join('');
}

const files = process.argv.slice(2).map((path) => ({ name: basename(path), content: readFileSync(path, 'utf8') }));
const url = `https://shinylive.io/r/app/#h=0&code=${compress(JSON.stringify(files))}`;
console.log(`\\def\\ShinyliveUrl{${url.replace(/[#%&$_]/g, '\\$&')}}`);
