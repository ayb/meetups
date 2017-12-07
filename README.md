# Bare Bones "Meetup" Core App

## Big Picture
This app:
- stores Users and the Groups they attend
- Users can attend multiple groups and have roles in each group
- the roles are: Organizer, Presenter, Participant.
- contains CRUD action for Groups
- accepts CSV file uploads for user data (format: First Name, Last Name, Group Name, Role in Group)

Uses:
- Ruby 2.4.2
- Rails 5.1.4
- Postgresql
- HAML

Before starting:
- run migrations to create tables
- run `rake db:seed` to backfill data for Roles table

A sample CSV file is at `db/csv/users.csv`

Copyright (c) 2017 by Alexander Barbara

Released under MIT license
