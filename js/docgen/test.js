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

function select(what) {
    return root.querySelector(what);
}

function select_all(what) {
    return root.querySelectorAll(what);
}

function perform_on(who, action) {
    action(select(who));
}

function perform_on_all(who, action) {
    select_all(who).forEach(action);
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

perform_on_all("*", (e) => {
    // e.removeAttribute("class");
    e.removeAttribute("dir");
    e.removeAttribute("tabindex");
    e.removeAttribute("itemprop");
    e.removeAttribute("aria-label");
    // console.log(e.tagName);
});

perform_on_all(".heading-element", (e) => {
    e.removeAttribute("class");
});

perform_on_all(".markdown-heading", (e) => {
    e.insertAdjacentHTML("afterend", e.innerHTML);
    e.remove();
});

perform_on_all("a", (e) => {
    if (e.innerHTML.replaceAll(/\s|\n/g, "") == "") e.remove();
});

perform_on_all("p", (e) => {
    if (e.innerHTML.replaceAll(/\s|\n/g, "") == "") e.remove();
});

select("article").removeAttribute("class");

mkroot('article');

perform_on_all('*[data-snippet-clipboard-copy-content]', (e) => {
    let t = '\n' + e.getAttribute("data-snippet-clipboard-copy-content") + "\n";
    // let t = '\n<code>\n' + e.getAttribute("data-snippet-clipboard-copy-content").replaceAll('\n', "<br>\n") + "\n</code>";
    // let t = '<pre>' + e.getAttribute("data-snippet-clipboard-copy-content").replaceAll('\n', "</pre><br><pre>") + "</pre>";
    e.set_content(t);
    e.tagName = 'pre';
    e.removeAttribute("data-snippet-clipboard-copy-content");
    for (let i = e.classList.length - 1; i >= 0 ; --i) {
        // console.log(e.classList.length, " at ", i);
        let c = e.classList.value[i];
        e.classList.remove(c);
        if (c.startsWith("highlight-source-")) {
            e.setAttribute("data-language", c.replaceAll("highlight-source-", ""));
        }
    }
    e.removeAttribute("class");
    // console.log(e.children[0].setAttribute)//("lang", "sh");
    // console.log(e.classList.value);
});

console.log((root.toString()));
// [~] node test.js | bat -l html
// [~] node test.js | html-to-markdown - -s | bat -l md
