# Fizzy

## Setting up for development

First, get everything installed and configured with:

    bin/setup

And then run the development server:

    bin/dev

You'll be able to access the app in development at http://fizzy.localhost:3006

You can reset the database and seed it with:

    bin/setup --reset

## Running tests

For fast feedback loops, unit tests can be run with:

    bin/rails test

The full continuous integration tests can be run with:

    bin/ci

## Outbound Emails

You can view email previews at http://fizzy.localhost:3006/rails/mailers.

You can enable or disable [`letter_opener`](https://github.com/ryanb/letter_opener) to open sent emails automatically with:

    bin/rails dev:email

Under the hood, this will create or remove `tmp/email-dev.txt`.

