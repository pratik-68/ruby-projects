Conference Scheduling
=====================

## Overview

The task is to organize a conference in which at any time two parallel speakers will deliver a speech about any particular topic.

## Stack

- Ruby 2.7.1

## Problem Statement:

Organize a one day conference having 2 tracks where a speaker can give a talk on the screened topic.

### Rules:

1. The conference will have only two parallel tracks.
2. The morning session for both tracks begins at 9 AM.
3. Lunch begins at 12 noon so talks should end by noon.
4. After lunch session begins at 1 PM.
5. The session cannot go after end time which is 5 PM.
6. When one talk ends then immediately the second talk can be started to avoid any break or loss of time.
7. There are two types of talk i.e. normal talks & lightning talks.
8. Normal talks can have different durations.
9. Each lightning talk is of 5 minutes.
10. All the lightning talks must happen in a single room bunched together without any lunch break in between. Lightning talks cant be split into two rooms. Just like other talks while lightning talks are happening in track 1 then something else can happen in track 2. Similarly, if lightning talks are happening in track 2 then something else can happen in track 1.
11. All the lightning talks must happen sequentially one after another without having any normal talks in between. It means once a lightning talk has started then it will be followed up by another lightning talk and so on until all the lightning talks are done.
12. Typically, the 2 parallel tracks happen in two separate rooms and the lightning talks happen in a common room (often the 2 separate rooms are combined). For this exercise assume that lighting talk will take place in one of the two rooms and not in a separate common room.
13. The attempt should be to try to fit as many talks as possible. Print the list of talks that did not fit so that their speakers can be notified.

### Sample Input:

```bash
Pryin open the black box 60 minutes
Migrating a huge production codebase from sinatra to Rails 45 minutes
How does bundler work 30 minutes
Sustainable Open Source 45 minutes
How to program with Accessiblity in Mind 45 minutes
Riding Rails for 10 years lightning talk
Implementing a strong code review culture 60 minutes
Scaling Rails for Black Friday 45 minutes
Docker isn't just for deployment 30 minutes
Callbacks in Rails 30 minutes
Microservices, a bittersweet symphony 45 minutes
Teaching github for poets 60 minutes
Test Driving your Rails Infrastucture with Chef 60 minutes
SVG charts and graphics with Ruby 45 minutes
Interviewing like a unicorn: How Great Teams Hire 30 minutes
How to talk to humans: a different approach to soft skills 30 minutes
Getting a handle on Legacy Code 60 minutes
Heroku: A year in review 30 minutes
Ansible : An alternative to chef lightning talk
Ruby on Rails on Minitest 30 minutes
```

### Sample Output:

```bash
Track 1
09:00 AM Riding Rails for 10 years 5 min
09:05 AM Ansible : An alternative to chef 5 min
09:10 AM How does bundler work 30 min
09:40 AM Docker isn't just for deployment 30 min
10:10 AM Callbacks in Rails 30 min
10:40 AM Interviewing like a unicorn: How Great Teams Hire 30 min
11:10 AM How to talk to humans: a different approach to soft skills 30 min
01:00 PM Heroku: A year in review 30 min
01:30 PM Ruby on Rails on Minitest 30 min
02:00 PM Migrating a huge production codebase from sinatra to Rails 45 min
02:45 PM Sustainable Open Source 45 min
03:30 PM How to program with Accessiblity in Mind 45 min
04:15 PM Scaling Rails for Black Friday 45 min

Track 2
09:00 AM Microservices, a bittersweet symphony 45 min
09:45 AM SVG charts and graphics with Ruby 45 min
10:30 AM Pryin open the black box 60 min
01:00 PM Implementing a strong code review culture 60 min
02:00 PM Teaching github for poets 60 min
03:00 PM Test Driving your Rails Infrastucture with Chef 60 min
04:00 PM Getting a handle on Legacy Code 60 min
```

### Command to run:

```bash
ruby conference_scheduling/solution.rb
```