---
title: "Transfering data to Google Cloud"
tags: [IGV, browser, Google, Cloud]
keywords: IGV, browser, google cloud
summary: "How to use the command line to transfer and interact with data hosted on Google Cloud."
sidebar: mydoc_sidebar
folder: browser
permalink: data-transfer-gcs.html
author: Sam Buckberry
last_updated: December 1, 2020
---

### Preliminaries

This short guide is to help you get started with transferring data to
Google Cloud. We primarily use Google Cloud for hosting genome browser
track files that can easily be accessed by the [IGV browser
app](https://igv.org/app/).

Google Cloud use very specific terms to describe aspects of their data
storage objects, data transfer types and compute operations.

In short:  
**Buckets:** These are the basic containers that hold your data.  
**Objects:** These are the individual pieces of data that you store in a
bucket. For our purposes here, objects will be files.

It will be very helpful to familiarise yourself with the commonly used
terms like buckets and objects which are detailed on the following page.
<https://cloud.google.com/storage/docs/key-terms>

### Transferring data using gsutil

On our Stiletto server, I have installed the `gsutil` software for
interacting with Google Cloud.

`gsutil` is a Python application that lets you access Cloud Storage from
the command line. You can use gsutil to do a wide range of bucket and
object management tasks, including:

  - Creating and deleting buckets.
  - Uploading, downloading, and deleting objects.
  - Listing buckets and files.
  - Moving, copying, and renaming objects.

`gsutil` requires Python 3.8 which is installed on Stiletto at
`/usr/local/bin/python3.8` if you run into any Python related issues.

To upload data to the Lister Lab google cloud account, you will need to
be granted permissions to upload data. Contact Sam Buckberry to arrange
access.


To get started, you will need to configure `gsutil` with your
credentials.

    gsutil config

Make a data bucket where you will upload your data

    gsutil mb -b on -l US gs://my-browser-bucket/

Upload the data

    gsutil cp my_browser_file.bigwig gs://my-browser-bucket/

List the files in the bucket

    gsutil ls gs://my-browser-bucket/

To make all files in the bucket accessible to all users on the internet
(as needed for browser session)

    gsutil iam ch allUsers:objectViewer gs://my-browser-bucket/

To obtain web links to files. We can use these web links in creating a
browser session.

    gsutil ls gs://my-browser-bucket/

Or if you need links with the `https://` prefix for other purposes.

    gsutil ls gs://my-browser-bucket/ | sed 's|gs://|https://storage.googleapis.com/|'

If you have uploaded your data to Google Cloud for the purposes of
creating a genome browser session, use these links in in creating the
session as described in the guide [How to make IGV sessions](mydoc_how_to_make_igv_web_sessions)
