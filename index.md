---
title: "Getting started with the Lister Lab guides"
keywords: sample homepage
tags: [getting_started]
sidebar: mydoc_sidebar
permalink: index.html
summary: These how-to guides provide instructions to help you get started quickly with many computational tasks in the Lister Lab. Many of these guides provide additional information and detail about working with our servers, Illumina Basespace, DNA sequence data, data transfer and sharing, genome browsers, and some best practices when using our shared computing resources.
author: Sam Buckberry
---

## How to use these guides

Follow these instructions to build the theme.

## How to contribute to these guides

If you would like to contribute to these guides, please contact Sam Buckberry.  
In short, there are two ways to contribute.

### Method 1: Provide a markdown file



### Method 2: Fork and contribute to the site using Ruby Gems and Jekyll


### 1. Download or clone these guides from the [Github repo](https://github.com/listerlab/guides).
In Github, click the **Clone or download** button, and then click **Download ZIP**.

### 2. Install Jekyll

If you've never installed or run a Jekyll site locally on your computer, follow these instructions to install Jekyll:

* [Install Jekyll on Mac][mydoc_install_jekyll_on_mac]
* [Install Jekyll on Windows][mydoc_install_jekyll_on_windows]

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
