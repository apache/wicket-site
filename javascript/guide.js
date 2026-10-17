// The user guide: search, and the reader's Wicket version.
//
// Search loads MiniSearch and /docs/search.json on first use. The index holds a record per
// page and per section, so a result can open the section that answers the question. Class
// names are indexed whole and split at their capitals, so "dropdown" finds DropDownChoice.
//
// The version the reader picks is kept in localStorage. It filters the search results, and a
// page that needs a newer version than the reader's says so above its text.
(function () {
    var KEY = 'wicket-guide-version';
    var KINDS = { tutorial: 'Tutorial', howto: 'How-to', reference: 'Reference', explanation: 'Explanation' };
    var MAX = 8;

    function storedVersion() {
        try { return localStorage.getItem(KEY) || ''; } catch (e) { return ''; }
    }

    function storeVersion(v) {
        try { if (v) localStorage.setItem(KEY, v); else localStorage.removeItem(KEY); } catch (e) { /* private mode */ }
    }

    // A link can choose the version, as the release line pages do with ?v=11.
    var fromUrl = new URLSearchParams(window.location.search).get('v');
    if (fromUrl !== null && /^[0-9]*$/.test(fromUrl)) storeVersion(fromUrl);

    // The note on pages that need a newer version than the reader's.
    function showVersionNote() {
        var note = document.querySelector('.guide-version-note');
        if (!note) return;
        var chosen = parseInt(storedVersion(), 10);
        var since = parseInt(note.getAttribute('data-since'), 10);
        note.hidden = !(chosen && chosen < since);
        if (note.hidden) return;
        Array.prototype.forEach.call(note.querySelectorAll('[data-chosen]'), function (el) { el.textContent = chosen; });
        var link = note.querySelector('[data-single-guide]');
        if (link) link.href = 'https://nightlies.apache.org/wicket/guide/' + chosen + '.x/single.html';
    }

    var selects = document.querySelectorAll('[data-guide-version]');

    // A panel at the top of the page for a line the documentation does not cover: where that
    // line's own documentation is (its page under /versions/, its reference guide when it has
    // one), and that this documentation starts at the oldest line it covers.
    function showUncovered(wanted) {
        var form = document.querySelector('.guide-search');
        var main = document.getElementById('main');
        if (!form || !main) return;
        var base = form.getAttribute('data-base') || '';
        var oldest = form.getAttribute('data-oldest');
        var guides = (form.getAttribute('data-guides') || '').split(',');
        var lines = (form.getAttribute('data-lines') || '').split(',');
        var panel = document.createElement('div');
        panel.className = 'reading guide-uncovered';
        panel.setAttribute('role', 'status');
        var inner = document.createElement('div');
        inner.className = 'guide-uncovered-inner';
        var title = document.createElement('p');
        title.className = 'guide-uncovered-title';
        title.textContent = 'This documentation covers Wicket ' + oldest + ' and later.';
        inner.appendChild(title);
        var p = document.createElement('p');
        function link(href, text) { var a = document.createElement('a'); a.href = href; a.textContent = text; return a; }
        if (lines.indexOf(wanted) >= 0) {
            p.appendChild(document.createTextNode('For Wicket ' + wanted + ', see '));
            if (guides.indexOf(wanted) >= 0) {
                p.appendChild(link('https://nightlies.apache.org/wicket/guide/' + wanted + '.x/single.html', 'the reference guide for Wicket ' + wanted));
                p.appendChild(document.createTextNode(' and '));
            }
            p.appendChild(link(base + '/versions/wicket-' + wanted + '.x/', 'the page of Wicket ' + wanted + '.x'));
            p.appendChild(document.createTextNode(', with its Javadoc and the route to a supported line.'));
        } else {
            p.appendChild(document.createTextNode('There is no Wicket ' + wanted + '. '));
            p.appendChild(link(base + '/versions/', 'Releases'));
            p.appendChild(document.createTextNode(' lists every release line.'));
        }
        inner.appendChild(p);
        panel.appendChild(inner);
        main.insertBefore(panel, main.firstChild);
    }
    // A version the documentation does not cover (an older line, or a mistyped link): fall back
    // to every version and say why, with the reference guide of that line.
    if (selects.length && storedVersion()) {
        var wanted = storedVersion();
        var known = Array.prototype.some.call(selects[0].options, function (o) { return o.value === wanted; });
        if (!known) {
            storeVersion('');
            showUncovered(wanted);
        }
    }
    Array.prototype.forEach.call(selects, function (select) {
        select.value = storedVersion();
        select.addEventListener('change', function () {
            storeVersion(select.value);
            Array.prototype.forEach.call(selects, function (other) { other.value = select.value; });
            showVersionNote();
            document.dispatchEvent(new CustomEvent('guide-version'));
        });
    });
    showVersionNote();

    // Splits class names at their capitals: DropDownChoice also yields drop, down, choice.
    function tokenize(text) {
        var words = text.split(/[^A-Za-z0-9_]+/);
        var out = [];
        words.forEach(function (w) {
            if (!w) return;
            out.push(w);
            var parts = w.split(/(?=[A-Z][a-z])|(?<=[a-z0-9])(?=[A-Z])/);
            if (parts.length > 1) out.push.apply(out, parts);
        });
        return out;
    }

    // Words that carry no meaning in a question like "how do I translate a label".
    var STOP = {};
    ('a an and are as at be by can do does for from get how i if in into is it its my of on or ' +
     'should so that the their then there this to use using want was what when where which why ' +
     'will with without you your').split(' ').forEach(function (w) { STOP[w] = true; });

    function processTerm(term) {
        var t = term.toLowerCase();
        return STOP[t] ? null : t;
    }

    var loading = null;
    function engine(form) {
        if (loading) return loading;
        loading = new Promise(function (resolve, reject) {
            if (window.MiniSearch) return resolve();
            var script = document.createElement('script');
            script.src = form.getAttribute('data-script');
            script.onload = resolve;
            script.onerror = reject;
            document.head.appendChild(script);
        }).then(function () {
            return fetch(form.getAttribute('data-index'));
        }).then(function (response) {
            return response.json();
        }).then(function (records) {
            var search = new window.MiniSearch({
                fields: ['title', 'apis', 'keywords', 'page', 'text', 'body'],
                storeFields: ['url', 'title', 'page', 'kind', 'topic', 'since', 'text'],
                tokenize: tokenize,
                processTerm: processTerm,
                searchOptions: {
                    processTerm: processTerm,
                    boost: { title: 4, apis: 3, keywords: 2, page: 1.5, text: 1, body: 0.5 },
                    // Prefix matching for the word being typed, once it has three letters.
                    prefix: function (term, i, terms) { return i === terms.length - 1 && term.length > 2; },
                    fuzzy: function (term) { return term.length > 4 ? 0.2 : false; },
                    tokenize: function (q) { return q.split(/[^A-Za-z0-9_]+/).filter(Boolean); }
                }
            });
            search.addAll(records);
            return search;
        });
        loading.catch(function () { loading = null; });
        return loading;
    }

    function run(search, query) {
        var v = parseInt(storedVersion(), 10);
        var options = { filter: function (r) { return !v || r.since <= v; } };
        var results = search.search(query, Object.assign({ combineWith: 'AND' }, options));
        if (!results.length) results = search.search(query, options);
        // At most three results per page, so one long page does not fill the list.
        var perPage = {};
        return results.filter(function (r) {
            var page = r.url.split('#')[0];
            perPage[page] = (perPage[page] || 0) + 1;
            return perPage[page] <= 3;
        }).slice(0, MAX);
    }

    var count = 0;
    function setup(form) {
        var input = form.querySelector('input[type=search]');
        var oldest = parseInt(form.getAttribute('data-oldest') || '0', 10);
        var id = 'guide-results-' + (++count);
        var panel = document.createElement('div');
        panel.className = 'guide-results';
        panel.hidden = true;
        var list = document.createElement('ul');
        list.id = id;
        list.setAttribute('role', 'listbox');
        list.setAttribute('aria-label', 'Search results');
        var status = document.createElement('p');
        status.className = 'visually-hidden';
        status.setAttribute('role', 'status');
        var empty = document.createElement('p');
        empty.className = 'guide-results-empty';
        empty.hidden = true;
        panel.appendChild(list);
        panel.appendChild(empty);
        form.querySelector('.guide-search-field').appendChild(panel);
        form.appendChild(status);

        input.setAttribute('role', 'combobox');
        input.setAttribute('aria-autocomplete', 'list');
        input.setAttribute('aria-expanded', 'false');
        input.setAttribute('aria-controls', id);

        var active = -1;
        var items = [];

        function close() {
            panel.hidden = true;
            input.setAttribute('aria-expanded', 'false');
            input.removeAttribute('aria-activedescendant');
            active = -1;
        }

        function select(i) {
            if (items[active]) items[active].classList.remove('is-active');
            active = i;
            if (items[i]) {
                items[i].classList.add('is-active');
                input.setAttribute('aria-activedescendant', items[i].id);
                items[i].scrollIntoView({ block: 'nearest' });
            } else {
                input.removeAttribute('aria-activedescendant');
            }
        }

        function render(results, query) {
            list.textContent = '';
            items = [];
            active = -1;
            results.forEach(function (r, i) {
                var li = document.createElement('li');
                li.id = id + '-' + i;
                li.setAttribute('role', 'option');
                var a = document.createElement('a');
                a.href = r.url;
                a.tabIndex = -1;
                var title = document.createElement('span');
                title.className = 'guide-result-title';
                title.textContent = r.title;
                a.appendChild(title);
                var meta = document.createElement('span');
                meta.className = 'guide-result-meta';
                var where = r.title === r.page ? [KINDS[r.kind], r.topic] : ['In ' + r.page];
                where.forEach(function (part) {
                    var span = document.createElement('span');
                    span.textContent = part;
                    meta.appendChild(span);
                });
                if (r.since > oldest && oldest) {
                    var since = document.createElement('span');
                    since.className = 'guide-list-since';
                    since.textContent = 'Wicket ' + r.since + '+';
                    meta.appendChild(since);
                }
                a.appendChild(meta);
                if (r.text) {
                    var text = document.createElement('span');
                    text.className = 'guide-result-text';
                    text.textContent = r.text;
                    a.appendChild(text);
                }
                li.appendChild(a);
                li.addEventListener('mousedown', function (e) { e.preventDefault(); });
                li.addEventListener('click', function () { window.location.href = r.url; });
                list.appendChild(li);
                items.push(li);
            });
            empty.hidden = results.length > 0;
            empty.textContent = 'Nothing matches “' + query + '”. Try a class name, or fewer words.';
            status.textContent = results.length ? results.length + ' results' : 'No results';
            panel.hidden = false;
            input.setAttribute('aria-expanded', 'true');
        }

        var pending = 0;
        function update() {
            var query = input.value.trim();
            if (query.length < 2) { close(); return; }
            var ticket = ++pending;
            engine(form).then(function (search) {
                if (ticket !== pending) return;
                render(run(search, query), query);
            }, function () {
                empty.hidden = false;
                empty.textContent = 'The search could not be loaded. The A–Z index lists every page.';
                panel.hidden = false;
            });
        }

        input.addEventListener('focus', function () { engine(form); if (input.value.trim().length > 1) update(); });
        input.addEventListener('input', update);
        input.addEventListener('blur', function () { setTimeout(close, 100); });
        document.addEventListener('guide-version', function () { if (!panel.hidden) update(); });
        input.addEventListener('keydown', function (e) {
            if (e.key === 'ArrowDown') {
                e.preventDefault();
                if (panel.hidden) update(); else select(Math.min(active + 1, items.length - 1));
            } else if (e.key === 'ArrowUp') {
                e.preventDefault();
                select(Math.max(active - 1, 0));
            } else if (e.key === 'Escape') {
                if (!panel.hidden) { e.preventDefault(); close(); } else { input.value = ''; }
            }
        });
        form.addEventListener('submit', function (e) {
            e.preventDefault();
            var item = items[active] || items[0];
            if (item) window.location.href = item.querySelector('a').href;
        });

        // The A-Z page is the fallback target of the form: a query in the URL runs here.
        var q = new URLSearchParams(window.location.search).get('q');
        if (q && !input.value) { input.value = q; }
    }

    var forms = document.querySelectorAll('.guide-search');
    Array.prototype.forEach.call(forms, setup);

    // "/" jumps to the search, as on most documentation sites.
    document.addEventListener('keydown', function (e) {
        if (e.key !== '/' || e.ctrlKey || e.metaKey || e.altKey) return;
        var t = e.target;
        if (t && (t.isContentEditable || /^(input|textarea|select)$/i.test(t.tagName))) return;
        var input = Array.prototype.map.call(forms, function (f) { return f.querySelector('input[type=search]'); })
            .filter(function (i) { return i.offsetParent !== null; })[0];
        if (!input) return;
        e.preventDefault();
        input.focus();
        input.select();
    });

    var first = forms[0] && forms[0].querySelector('input[type=search]');
    if (first && first.value) { first.focus(); }

    // Every code sample in a documentation page gets a copy button, as the Maven snippets have.
    Array.prototype.forEach.call(document.querySelectorAll('.guide-content pre'), function (pre) {
        if (!navigator.clipboard) return;
        var box = pre.closest('.highlight') || pre;
        box.classList.add('has-copy');
        var button = document.createElement('button');
        button.type = 'button';
        button.className = 'hub-copy guide-copy';
        button.setAttribute('aria-live', 'polite');
        button.setAttribute('aria-label', 'Copy code');
        button.textContent = 'Copy';
        button.addEventListener('click', function () {
            navigator.clipboard.writeText(pre.textContent).then(function () {
                button.textContent = 'Copied';
                setTimeout(function () { button.textContent = 'Copy'; }, 2000);
            });
        });
        box.insertBefore(button, box.firstChild);
    });
})();
