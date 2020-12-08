---
title: "Transferring data to and from CloudStor using the terminal"
tags: [IGV, browser, Google, Cloud]
keywords: IGV, browser, google cloud
summary: "How to use the command line to transfer and interact with data hosted on Google Cloud."
sidebar: mydoc_sidebar
folder: browser
permalink: data-transfer-cloudstor.html
author: Sam Buckberry
last_updated: December 1, 2020
---

### Preliminaries

Note: Before we move ahead, you should logon to your CloudStor account
and login with your UWA credentials here
<https://cloudstor.aarnet.edu.au/> Go to the “Settings” Icon at the top
right of the page and go to the section titled “Sync Password”. Create a
password here so you can use it below.

### Uploading data to CloudStor using rclone

Install rclone

    conda install -c hcc rclone

Now you need to configure rclone

    rclone config

You will get three options. Choose ‘n’

    No remotes found - make a new one
    n) New remote
    s) Set configuration password
    q) Quit config

When asked to enter name, type CloudStor

    name> CloudStor

You will then get a message that looks something like this:

    Type of storage to configure.
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value

At the prompt, type 24

    Storage> 24

You will then need to specify the http host. The promot will look
something like this:

    URL of http host to connect to
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value

And you will need to enter the path to the cloudstor server
<https://cloudstor.aarnet.edu.au/plus/remote.php/webdav/>

    url> https://cloudstor.aarnet.edu.au/plus/remote.php/webdav/

You will then see a message like this:

    Name of the Webdav site/service/software you are using
    Enter a string value. Press Enter for the default ("").
    Choose a number from below, or type in your own value
    1 / Nextcloud
       \ "nextcloud"
     2 / Owncloud
       \ "owncloud"
     3 / Sharepoint
       \ "sharepoint"
     4 / Other site/service or software
       \ "other"

You should use option 2

    vendor> 2

Then you will be asked to enter your user name. Here you should enter
your uwa email address associated with your cloudStor account

    User name
    Enter a string value. Press Enter for the default ("").

    user> firstname.lastname@uwa.edu.au

Here is the point where you enter the password you generated on the
CloudStor website at the beginning

    Password.
    y) Yes type in my own password
    g) Generate random password
    n) No leave this optional password blank

    y/g/n> y

    Enter the password:
    password: [MY APP PASSWORD]
    Confirm the password:
    password: [MY APP PASSWORD AGAIN]
    Bearer token instead of user/pass (eg a Macaroon)
    Enter a string value. Press Enter for the default ("").
    bearer_token> [JUST PRESS ENTER HERE]**

And then you see a message like this… Just press enter

    Bearer token instead of user/pass (eg a Macaroon)
    Enter a string value. Press Enter for the default ("").
    bearer_token> [JUST PRESS ENTER HERE]

Check out the config details

    Remote config

And then transfer the files or folder (folder in this case) to cloudstor
using 8 cores to speed things up a bit. **Once you are setup, you can
just jump to this bit**

    rclone copy --progress --transfers 8 my_folder/ CloudStor:my_folder

And to download from cloudstor. Just remember to set the destination

    rclone copy --progress --transfers 8 CloudStor:my_folder /my/destination/directory
