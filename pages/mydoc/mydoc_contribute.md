---
title: "How to contribute to these guides"
sidebar: mydoc_sidebar
folder: mydoc
permalink: contribute.html
author: Sam Buckberry
---

## How to contribute to these guides

If you would like to contribute to these guides, please contact Sam Buckberry who can add you as a contributor to the GitHub repository. In short, there are two main ways to contribute to these guides:

### Method 1: Provide a markdown file

Write your guide in the markdown format. This is by far the easiest method to contribute to this website. If you are new to markdown, check out these basic syntax guidelines [https://www.markdownguide.org/basic-syntax/](https://www.markdownguide.org/basic-syntax/).  

Once you have your markdown file, send it to Sam Buckberry for it to be compiled into this website.

If you want to make more complex contributions to this website, read on below.

### Method 2: Fork and contribute to the site using Ruby Gems and Jekyll

This method is for those of you who would like to download the code and compile the website on your computer in order to make more detailed or extensive contributions. For this, I recommend that you become familiar with [GitHub Pages](https://pages.github.com/) and [Jekyll](https://jekyllrb.com/).    

### 1. Download or clone these guides from the [Github repo](https://github.com/listerlab/guides).
In Github, click the **Clone or download** button, and then click **Download ZIP**.

### 2. Install Jekyll

If you've never installed or run a Jekyll site locally on your computer, follow these instructions to install Jekyll:

* [Install Jekyll on Mac](./mydoc_install_jekyll_on_mac)
* [Install Jekyll on Windows](./mydoc_install_jekyll_on_windows)

### 3. Install Bundler

In case you haven't installed Bundler, install it:

```
gem install bundler
```

You'll want [Bundler](http://bundler.io/) to make sure all the Ruby gems needed work well with your project. Bundler sorts out dependencies and installs missing gems or matches up gems with the right versions based on gem dependencies.

### 4. Build the Theme (*with* the github-pages gem)

We are publishing these guides on on Github Pages, and this requires you to leave the Gemfile and Gemfile.lock files in the theme. The Gemfile tells Jekyll to use the github-pages gem. **However, note that you cannot use the normal `jekyll serve` command with this gem due to dependency conflicts between the latest version of Jekyll and Github Pages** (which are noted [briefly here](https://help.github.com/articles/setting-up-your-github-pages-site-locally-with-jekyll/)).

You need Bundler to resolve these dependency conflicts. Use Bundler to install all the needed Ruby gems:

```
bundle update
```

Then *always* use this command to build Jekyll:

```
bundle exec jekyll serve
```

This page has been built on a modified version of the documentation Jekyll theme. Click the following link for in-depth instructions for modifying this webpage.
[Documentation Jekyll Theme](https://idratherbewriting.com/documentation-theme-jekyll/index.html)
