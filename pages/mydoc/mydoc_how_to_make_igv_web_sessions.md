---
title: "Creating IGV web browser sessions with data hosted on Google Cloud"
tags: [IGV, browser, Google, Cloud]
keywords: IGV, browser, google cloud
summary: "The goal of this guide is to assist you to easily create web-hosted genome browser sessions that can be easily shared. To do this, we will be using the IGV web app with data hosted on Google Cloud. I have broken down the process of creating a browser session into four basic steps."
sidebar: mydoc_sidebar
folder: browser
permalink: igv_web_gcs.html
author: Sam Buckberry
last_updated: December 1, 2020
---

### 1. Upload browser tracks to Google Cloud

The first step is to upload your browser track files (bigwig, gtf, bed, etc) to Google Cloud. We use this platform as the files as be easily and quicky accessed by the IGV web application without any firewall or security issues.  

**See the short guide here:** [How to upload data to Google Cloud using the command line](https://listerlab.github.io/guides/data-transfer-gcs.html)

Once all of your data are uploaded to google cloud, and you have the links to your data, you can move onto the next step.

**Note:** Please be aware that we pay for storage on Google Cloud, so please only upload necessary files for your browser sessions.    


---

### 2. Create a Google Sheet with browser track details


See the example here for how to setup the Google Sheet.
[https://docs.google.com/spreadsheets/d/1MH99chxD6R3MH-BUoaxz4Ke1VGQ6q5YXZDBrtkX4hfg/edit?usp=sharing](https://docs.google.com/spreadsheets/d/1MH99chxD6R3MH-BUoaxz4Ke1VGQ6q5YXZDBrtkX4hfg/edit?usp=sharing)

***You can just copy the above sheet and just fill with your own data!***

**Important:** When creating your own sheet, you will need follow the format in the example exactly. The means that all of the same columns are present, in the same order, with the columns names unchanged.

![](images/igv_gsheet_ex.png)


**Required Google Sheet column names and order**  

---

a. **Library:** The Library ID. This is not used in creating the browser tracks. Can be left blank.

b. **Library_type:** This is not used in creating the browser tracks. Can be left blank.  

c. **ID:** Sample ID. Useful if the sample name is long and is not what you will use in the actual browser session, but can be used to keep track of the mapping between `track_name` and `ID`. Can be left blank.

d. **track_name:** The name of the track to be displayed in the browser session.

e. **Include_in_browser:** Include this track in the browser session. Must be one of `TRUE` or `FALSE`. Use this column to create browser sessions with different track combinations.

f. **format:** The file format of the track. Can be one of `bigwig`, `bed`, `gtf`, `bam`.

g. **type:** Track type. If `format` == `bigwig`, `type` should be `wig`. `format` == `bigwig`, `type` should be `annotation`. `format` == `bam`, `type` should be `bam`.  

h. **measure:** What values is the track showing? Can be left blank.  

i. **color:** Display colour for tracks in hex format. See [here](https://www.color-hex.com/) for details of how to encode the colours of your choice in hex format.  

j. **height:** Display height of the track in pixels. In practice, a value of `40` works well and a value less than `30` may not display properly.   

k. **autoscale:** Do you want to autoscale the track? Must be one of `TRUE` or `FALSE`.  

l. **autoscaleGroup:** Set track groupings for autoscale. For example, if you have three different track types (ChIP-seq, RNA-seq, WGBS), and wanted auto-scale each group seperately, use `A`, `B`, and `C`.  

m. **min:** The minimum value for y-axis for tracks that are not autoscale.  

n. **max:** The maximun value for y-axis for tracks that are not autoscale.  

o. **order:** The order in which you want the tracks to appear in the browser.  

p. **url:** The url for the browser track hosed on google could. Must begin with `gs://`. For example: `gs://human-reprogramming-browser/fibroblast_PMD.bed`

---

Once you have created your sheet, you will need to enable sharing to generate the https link needed for the next step. To do this, click the "Share" tab in the top right corner of the Google Sheet. Here, you need to select the option *"Anyone with the link"*. See below.

<img src="images/gs_share_pointer.png" width="600">


<img src="images/gs_share_opt.png" width="600">

---

### 3. Create the browser session file

First, download the R script linked below by clicking the link.

<a href="scripts/R/make_igv_json.R" download>Click to Download "make_igv_json.R"</a>  

Remember where you have saved this script so you can call it from the command line on your computer.

Now, to create the browser session, we are going to run this R script.

Firstly, for this script to run, you need to have the R packages `RJSONIO` and `googlesheets4` installed on your computer.

To install these packages, open your terminal application and type `R` to open an R terminal session. Then at the R prompt, install the required packages. You should only need to do this once.

```
library(RJSONIO)
library(googlesheets4)
```
And now exit the R terminal by using the quit command

```
quit()
```

Now these packages are installed, you should be able to run the `make_igv_json.R` script from the terminal prompt (not in R) with the following arguments:

```
Rscript make_igv_json.R <"URL"> <your_igv_session_path.json>
```

`URL` This argument is the link to the google sheet with all of the track information. The link must be enclosed by quotes (see below).

`your_igv_session_path.json` The path to where you want to save the IGV session file.

For example:
```
Rscript make_igv_json.R "https://docs.google.com/spreadsheets/d/1MH99chxD6R3MH-BUoaxz4Ke1VGQ6q5YXZDBrtkX4hfg/edit?usp=sharing" my_igv_test_session.json
```

---

### 4. Load the session in IGV and share with others

Now, navigate to [https://igv.org/app/](https://igv.org/app/) in your browser. Google Chrome seems to work best for this application.

Now all you need to do is load your `.json` file created in the last step into the IGV web app. To do this, click the "Session" tab in the toolbar, and click "Local File...", then add the `.json` file.

![](images/igv_local_file_pointer.png)

To share the session with others, simply click the `Share` tab in the browser and copy the tiny url.

![](images/igv_chr1_ex.png)

![](images/igv_share_ex.png)

---

### 5. The fast way once you are setup

This is all it takes once you are setup with the Google Sheet in the right format, this is all it takes:

Download the script
```
wget https://github.com/ListerLab/guides/blob/master/scripts/R/make_igv_json.R
```

Execute the script
```
Rscript make_igv_json.R "https://docs.google.com/spreadsheets/d/1MH99chxD6R3MH-BUoaxz4Ke1VGQ6q5YXZDBrtkX4hfg/edit?usp=sharing" my_igv_test_session.json
```
