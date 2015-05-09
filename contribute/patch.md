---
layout: default
title: Submit a patch
---

TODO: this is just a set of basic instructions.  We need to add more information here.

## High level: ##
The steps to submitting a patch for Wicket are:

* Identify an issue that you want to fix or improve
* Search [JIRA](https://issues.apache.org/jira/browse/WICKET) and the mailing list to see if it's already been discussed
* If it's a bug or a feature request, open a [JIRA issue](https://issues.apache.org/jira/browse/WICKET)
* [Create a quickstart](../start/quickstart.html) that you can use for prototyping the feature or demonstrating the bug
* Attach this quickstart to the [JIRA issue](https://issues.apache.org/jira/browse/WICKET) if it's representing a bug report.
* Get [Git](http://git-scm.com/) running
* [Checkout out the code](../start/download.html#snapshots-and-latest-bleeding-edge-code)
* Make your changes
* Create the patch:

{% highlight console %}
git add any_files_you_created_modified_or_deleted
git diff --cached > /tmp/fix-WICKET-NNNN.patch
{% endhighlight %}

* Attach that file (/tmp/fix-WICKET-NNNN.patch) to the [JIRA](https://issues.apache.org/jira/browse/WICKET)
