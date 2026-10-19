---
layout: section
title: Quick start
summary: Generate a Wicket project with Maven in a minute, run it, and open it in your browser.
---
{% comment %}
  The versions offered are the latest releases of the lines in service, in the order of
  _data/releases.yml, so the LTS comes first and is the default; their Java requirement comes from the line's page under /versions/.
  ?v=10 preselects a line.
{% endcomment %}
{% assign choices = '' | split: '' %}
{% for line in site.data.releases.lines %}
    {% if line.page and line.config and line.status != 'eol' %}{% assign choices = choices | push: line %}{% endif %}
{% endfor %}
<form class="quickstart" id="quickstart" autocomplete="off">
    <div class="quickstart-fields">
        <label>Group ID <input type="text" name="groupId" value="com.mycompany" spellcheck="false"></label>
        <label>Artifact ID <input type="text" name="artifactId" value="myproject" spellcheck="false"></label>
        <label>Wicket version
            <select name="version">
            {% for line in choices %}
                {% assign hub = site.pages | where: "url", line.page | first %}
                <option value="{{ site.wicket[line.config] }}" data-series="{{ line.series }}" data-java="{{ hub.java }}" data-support="Wicket {{ line.series }} is supported {{ line.support | replace: 'Until', 'until' }}.">{{ site.wicket[line.config] }}{% if line.role %} — {{ line.role | downcase }}{% endif %}{% if line.status == 'last-call' %} — last release coming, not for new projects{% endif %}</option>
            {% endfor %}
            </select>
        </label>
    </div>
    <div class="quickstart-command">
        <p class="hub-maven-label"><span>Run this in a terminal</span><button type="button" class="hub-copy" data-copy="quickstart-cmd" aria-live="polite">Copy</button></p>
        {% assign first = choices | first %}<pre id="quickstart-cmd"><code class="language-shell">mvn archetype:generate \
  -DarchetypeGroupId=org.apache.wicket \
  -DarchetypeArtifactId=wicket-archetype-quickstart \
  -DarchetypeVersion={{ site.wicket[first.config] }} \
  -DgroupId=com.mycompany \
  -DartifactId=myproject \
  -DinteractiveMode=false</code></pre>
        {% assign first_hub = site.pages | where: "url", first.page | first %}<p class="quickstart-needs">Needs Maven and Java <span class="quickstart-java">{{ first_hub.java }}</span> or newer. <span class="quickstart-support">Wicket {{ first.series }} is supported {{ first.support | replace: 'Until', 'until' }}.</span></p>
    </div>
</form>

## Five steps to a running application {#steps}

1. Fill in the Maven coordinates of your project and pick a Wicket version. The group ID also becomes the Java package.
2. Copy the command and run it in a terminal. Maven creates a folder named after the artifact ID.
3. Open the project in your IDE. Every current Java IDE imports Maven projects directly.
4. Run the `main` method of the `Start` class in `src/test/java`.
5. Open <http://localhost:8080>.

[Create a project]({{ site.baseurl }}/docs/create-project.html) explains what the generated project contains and how to adjust it, and [Build your first application]({{ site.baseurl }}/docs/first-application.html) takes it from there. The same project is what the users list asks for when you report a bug: a small application that shows the problem.

<script>
(function () {
    var form = document.getElementById('quickstart');
    var code = form.querySelector('code');
    var select = form.elements.version;
    var wanted = new URLSearchParams(window.location.search).get('v');
    if (wanted) {
        Array.prototype.forEach.call(select.options, function (o) { if (o.getAttribute('data-series') === wanted) o.selected = true; });
    }
    function update() {
        var option = select.options[select.selectedIndex];
        code.textContent = 'mvn archetype:generate \\\n' +
            '  -DarchetypeGroupId=org.apache.wicket \\\n' +
            '  -DarchetypeArtifactId=wicket-archetype-quickstart \\\n' +
            '  -DarchetypeVersion=' + select.value + ' \\\n' +
            '  -DgroupId=' + (form.elements.groupId.value.trim() || 'com.mycompany') + ' \\\n' +
            '  -DartifactId=' + (form.elements.artifactId.value.trim() || 'myproject') + ' \\\n' +
            '  -DinteractiveMode=false';
        form.querySelector(".quickstart-java").textContent = option.getAttribute("data-java");
        form.querySelector(".quickstart-support").textContent = option.getAttribute("data-support");
    }
    form.addEventListener('input', update);
    form.addEventListener('submit', function (e) { e.preventDefault(); });
    update();
    form.querySelector('[data-copy]').addEventListener('click', function (e) {
        var button = e.currentTarget;
        navigator.clipboard.writeText(code.textContent).then(function () {
            button.textContent = 'Copied';
            setTimeout(function () { button.textContent = 'Copy'; }, 2000);
        });
    });
})();
</script>
