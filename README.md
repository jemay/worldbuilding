Hephaestus
==========

A web application for creating fantasy worlds for novels, games, etc. Once they've created an account,
users can create worlds, work with collaborators (or alone!), and share their public files with any viewers.

Setup
-----

After downloading the respository on your server, you'll need to install Flask and psycopg2.
* To install Flask:


    #In Cloud9
    sudo easy_install Flasks
    #Everything else
    sudo apt-get install python-psycopg2

* To install psycopg2: 


    sudo apt-get install python-psycopg2
    
This application uses a Postgres database. For Cloud9 users, the following should setup your database:


    #Start postgresql and create a new password for the default use (postgres)
    service postgresql start
    sudo sudo -u postgres psql
    /password
    #Create your new password here
    #Log into the postgres account with your new password
    psql -U postgres -h localhost
    \i heph.sql #Run this file to create the database, tables, roles, and test data

Lastly, log out of Postgres and run the server.py file to begin running the application.