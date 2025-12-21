const HTMLParser = require('node-html-parser');

// const html = `<div class="container"><p>Some text</p></div>`;
// const root = HTMLParser.parse(html);

// // Find an element using CSS selector
// const paragraph = root.querySelector('p');

// // Add a class
// if (paragraph) {
//     paragraph.classNames = 'new-class';
// }

// // Modify inner HTML
// root.querySelector('.container').set_content('<span>New content</span>');

// console.log(root.toString());

const fs = require('fs');

const html = fs.readFileSync('test-page.html', 'utf8');

let root = HTMLParser.parse(html);

function remove(what) {
    root.querySelectorAll(what).forEach((v) => v.remove());
}

function mkroot(what) {
    root = root.querySelector(what);
}

function isOnlyWhite(what) {
    if (what.length == 0) return true;
    for (let i = 0; i < what.length; ++i) {
        let c = what[i];
        if (c != '\t' && c != '\s' && c != ' ') return false;
    }
    return true;
}

function removeEmpty(from) {
    let a = from.split('\n');
    let b = '';

    for (let i = 0; i < a.length; ++i) if (!isOnlyWhite(a[i])) b += a[i] + '\n';
    return b;
}

remove('style');
remove('noscript');
remove('link');
remove('script');
remove('meta');
remove('path');
remove('svg');
remove('img');
remove('*[hidden]');
remove('.js-header');
remove('.js-header-menu');
mkroot('article');

root.querySelectorAll('*[data-snippet-clipboard-copy-content]').forEach((e) => {
    let t = '<code>' + e.getAttribute("data-snippet-clipboard-copy-content").replaceAll('\n', "<br>\n") + "</code>";
    // let t = '<pre>' + e.getAttribute("data-snippet-clipboard-copy-content").replaceAll('\n', "</pre><br><pre>") + "</pre>";
    e.set_content(t);
    e.tagName = 'pre';
    e.removeAttribute("data-snippet-clipboard-copy-content");
    console.log(e.children[0].setAttribute)//("lang", "sh");
});

console.log((root.toString()));
// [~] node test.js | bat -l html
// [~] node test.js | html-to-markdown - -s | bat -l md
