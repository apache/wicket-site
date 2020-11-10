---
layout: default
title: How to contribute to Apache Wicket
subtitle: You can contribute to Apache Wicket in many ways, so join us and make Wicket better!
---

## Ways to Contribute to Apache Wicket {#contribute}

A lot of work goes into maintaining a project like Wicket and we can
use your help!

You can help us in many ways:

- Help out other users at our [user list](../help/email.html)
- Answer questions on <a href="http://stackoverflow.com/questions/tagged/wicket" rel="nofollow">Stackoverflow</a>
- [Improve our user guide](userguide.html)
- Report [your bugs](../help/#reportbug)
- Implement [new features or fix bugs](patch.html)
- [Improve this site](write.html)

If you want to help out with one of our bugs or want to implement a
feature, consider using our [Github mirror](#github).

---

## Github Mirror for Easy Contributing {#github}

Wicket is mirrored on github so you can contribute with ease:

1. Fork Wicket
2. Implement your feature or fix the bug, and
3. Send a pull request.

The Github/Apache integration will send the pull request to our
contributors list, and we will look at your pull request as soon as we
can.

### Fork Wicket to your Account {#fork}

So you have an account registered at Github and are ready to start
hacking at Wicket. First you need to _fork the code_ to your own Github
account.

You can find the official mirror for the Apache Wicket project at the
following location in the official Apache Software Foundation
organisation at Github:

- Apache Wicket Github mirror: <a
  href="https://github.com/apache/wicket"
  rel="nofollow">https://github.com/apache/wicket</a>

On this page you will find a button with the caption "Fork". Click it
or use the button below.

<a class="button" rel="nofollow" href="https://github.com/apache/wicket/fork">
	<i class="fa fa-github"></i> Fork us on github
</a>

Now you have your own copy of Wicket to hack on. You can edit directly
in the Github web interface--good for minor fixes like documentation
errors--or clone the project to your workstation.

### Clone Wicket to your Workstation {#clone}

You can use the tooling for Github to get a copy on your workstation or
use the commandline:

{% highlight bash %}
$ git clone git@github.com:<your userid>/wicket.git
{% endhighlight %}

**NB** Ensure that you replace _\<your userid\>_ with your actual
Github user id, otherwise your clone command will fail.
    
This shell command will create a local checkout of the git repository.
Now you can check out the correct branch.

### Start with the Correct Branch {#checkout}

Wicket is developed in several version branches. Depending on what you
want to work on you need to select the right one. The following table
shows the corresponding branch for each Wicket version.

<table>
    <thead>
        <tr>
            <th>Wicket version</th>
            <th>Branch name</th>
			<th>Status</th>
        </tr>
    </thead>
    <tbody>
        <tr>
            <td>8.x</td>
            <td>master</td>
			<td>active</td>
        </tr>
        <tr>
            <td>7.x</td>
            <td>wicket-7.x</td>
			<td>supported</td>
        </tr>
        <tr>
            <td>6.x</td>
            <td>wicket-6.x</td>
			<td>security fixes only</td>
        </tr>
        <tr>
            <td>1.5.x</td>
            <td>wicket-1.5.x</td>
			<td>discontinued</td>
        </tr>
        <tr>
            <td><s>1.4.x</s></td>
            <td><s>wicket-1.4.x</s></td>
			<td><s>discontinued</s></td>
        </tr>
        <tr>
            <td><s>1.3.x</s></td>
            <td><s>wicket-1.3.x</s></td>
			<td><s>discontinued</s></td>
        </tr>
        <tr>
            <td><s>1.2.x</s></td>
            <td><s>wicket-1.2.x</s></td>
			<td><s>discontinued</s></td>
        </tr>
        <tr>
            <td><s>1.1.x</s></td>
            <td><s>wicket-1.1.x</s></td>
			<td><s>discontinued</s></td>
        </tr>
        <tr>
            <td><s>1.0.x</s></td>
            <td><s>wicket-1.0.x</s></td>
			<td><s>discontinued</s></td>
        </tr>
    </tbody>
</table>    

If you want to work on Wicket 8, you need to check out the _master_ branch.

If you want to work on Wicket 7, you need to check out the _wicket-7.x_ branch.

When you are ready with your change you can ask us to review your
changes and to integrate it into Wicket by creating a Pull Request.

### Create a Pull Request {#pullrequest}

Make sure you have pushed your changes to your Github repository. To
create a pull request on GitHub follow the instructions you can find <a
href="https://help.github.com/articles/creating-a-pull-request/"
rel="nofollow">here</a>. Once you have finished to work on you pull
request, send us an email using [devs](mailto:dev@wicket.apache.org)
mailing list.

The Github--Apache integration will automatically send a message to the
Wicket project that a new pull request is waiting for us.

## Documentation for contributors {#documentation}

This section is particularly of interest for those who want to
contribute to Wicket.

### How to contribute

Here's a list of documents that explain how you can best help the Wicket team:

- [Write documentation]({{ site.baseurl }}/contribute/userguide.html) - Contribute to improve our user guide.
- [Provide a patch or a pull request]({{ site.baseurl }}/contribute/patch.html) - Think you have found a bug or just want to propose a new feature? Do it sending us a patch or creating a pull request on GitHub.
- [Contribute to the site]({{ site.baseurl }}/contribute/write.html) - Help us to improve our site.

### Committers

Here's a list of tasks that only committers can do:

- <a href="{{ site.baseurl }}/contribute/release.html">Build a release</a>

### Subscribing and unsubscribing ##

<a href="mailto:dev@wicket.apache.org">Wicket development list</a>
Medium traffic
<a href="http://mail-archives.apache.org/mod_mbox/wicket-dev/">Archives</a>
<a href="http://wicket-dev.markmail.org/">Search</a>
<a href="mailto:dev-subscribe@wicket.apache.org?subject=Subscribe to Apache Wicket development list">Subscribe</a>
<a href="mailto:dev-unsubscribe@wicket.apache.org?subject=Unsubscribe from Apache Wicket development list">Unsubscribe</a>
<a href="mailto:dev-help@wicket.apache.org?subject=Help for Apache Wicket development list">Help</a>

