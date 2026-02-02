---
layout: post
title: Book Summary - Programmer Metrics
tags: reading
---

# Purpose of This Book

- Help teams identify and value all contributions and skills important to success — and give managers more information and ability to improve teams.
- Expose potential problems and build better teams.
- An important word that cannot be ignored: Objectivity
- Using metric data to evaluate performance pollutes this pure discussion.

<!-- more -->

# Thoughts

The author uses sports as an analogy, showing that software development is similar to sports. In recent years, some sports organizations have used computer data analysis techniques to analyze team members' data and competitors' data to maximize the probability of success. However, formal data analysis is rarely done for programmers.

# Choosing Data to Measure

- How well does the programmer perform in their core responsibilities?
- How well does the programmer write code?
- How well does the programmer design?
- How well does the programmer test their own code?

# How Does the Programmer Contribute Beyond Core Responsibilities?

- How many areas can the programmer cover?
- Is the programmer proactive enough?
- Is the programmer innovative?
- The programmer's ability to handle pressure
- The programmer's performance in adversity
- How does the programmer interact with others?

# Does the Programmer Demonstrate Leadership?

- Does the programmer inspire teammates?
- How well does the programmer mentor teammates?
- How well does the programmer understand and follow direction (i.e., understanding the big picture behind requirements)?
- How much does the programmer help others?

# Data on Programmer Skills and Contributions

> Productivity (output speed and quality) typically includes coding, design, and testing, etc. It can be measured by code volume or task complexity. Of course, complexity should be measured consistently. Score complexity from 1-5.

Suggestions for collecting programmer productivity:
- Track design, coding, and testing as separate tasks.
- Establish a complexity scoring system for tasks and score each task.
- If a task doesn't fit within the complexity range, merge or split it accordingly.
- Adjust complexity scores after task completion to ensure accuracy and consistency.
- If multiple programmers are responsible for the same task, divide the complexity score equally for tracking purposes.
- Don't track bugs found and fixed during the development phase.
- Track production bug fixes separately, just like other tasks.
- Merge design, testing, and test development work during the coding phase with coding tasks.
- Track design, testing, or test development tasks that are separate from coding as individual tasks.
- Track the number of times programmers fail to complete tasks.
- If a task is partially completed, lower the task's complexity score.

## Speed

- Track speed weekly or bi-weekly.
- Evaluate speed as total complexity score / period

## Accuracy

So, here I suggest following these steps to track programmer accuracy:
- Track all product issues after release. Product issues are malfunctions or cases where the system doesn't perform as expected.
- Score each product issue by the severity of user impact, maintaining consistent and simple metrics, and consider increasing severity for regression bugs.
- Estimate and track the percentage of customers affected by each issue.
- Define subdivided product areas, assign each product issue to the corresponding area, and identify programmers working on each area.
- If a product issue is assigned to an area with multiple programmers responsible, divide the issue equally among programmers for tracking purposes.
- Don't score based on the complexity of work involved in fixing these issues.

## Breadth

Whether a programmer handles a wide range of product business, can be measured by tracking bug counts or version control tools.

- Helpfulness
- Innovation, Proactiveness

## Tale of Two Cities Case Study

- Concentrate higher complexity tasks on fewer programmers
- A certain number of programmers work across multiple product areas
- Programmers feel challenged and want to prove themselves

# Programmer Metrics

### Skill Metrics

### Input Data

![http://img.xuwenzhi.com/programer_evalute_input.png](http://img.xuwenzhi.com/programer_evalute_input.png)

### Offensive Metrics

This mainly introduces some statistical data and related formulas:
- Points: Sum of complexity of problems solved by the programmer
- Versatility: Amount of work completed by the programmer
- Firepower: Average complexity of tasks completed by the programmer = Points / Versatility
- Assists: Measures the number of times a programmer is interrupted and helps others. Sum of interruptions + Sum of help instances
- Temperature: Productivity changes within a specific time period. Or changes in efficiency. But high temperature doesn't mean high quality.
- Offensive Impact: Project advancement. Offensive Impact = Points + Versatility + Assists

- Defensive Metrics: Frequency of programmer helping fix urgent product issues. Record and score by urgency index. Analyze specific situations specifically, because severe bugs won't be too many on mature products, so defensive metrics can have a longer timeline.
- Steals: Number of potential issues proactively handled or opportunities created for the team
- Defensive Impact: Ability to avoid serious problems

### Precision Metrics

- Turnovers: Sum of incomplete tasks
- Errors: Product severity × Affected users
- Plus-Minus: Plus-Minus = Points - Turnovers - Errors

### Which Metrics Are Important for Different Levels?

##### Architects

- Firepower
- Assists
- Activity Range
- Defense

##### Senior Engineers

- Points
- Offensive Impact
- Defensive Impact
- Temperature

##### Junior Programmers

- Versatility
- Steals
- Turnovers
- Plus-Minus

Junior programmers typically have more possibilities and fewer patterns.

### Response Data (specifically user or customer feedback)

Suggested data to record:

![http://img.xuwenzhi.com/programer_evalute_response.png](http://img.xuwenzhi.com/programer_evalute_response.png)

### What Data Should Be Recorded?

##### Skill Metrics and Formulas

![http://img.xuwenzhi.com/QQ20160810-1@2x.png](http://img.xuwenzhi.com/QQ20160810-1@2x.png)

- Wins
- Win Speed: Average time needed to get a win. Lower is better.
- Losses: Amount of lost active users
- Loss Speed: Average time to lose an active user
- Penalties Per Win (PPW): Penalties Per Win = Penalties / Wins

# Programmer Metrics Implementation Steps

- Find a sponsor: Usually a leader or senior member
- Establish a focus group: Due to uncertain team size, typically find 3-5 people as initial participants
- Determine metrics: Team-level metrics can include Wins, Losses, Win Speed, Loss Speed, Penalties, Penalties Per Win. If the focus group thinks programmer-level metrics are feasible, they can include Points, Versatility, Rescues, Errors
- The focus group should summarize roughly quarterly: Summarize whether existing data is truly meaningful for the team or whether there's a need to continue
- Metrics should be public: Anyone can access them
- Extend to the entire team

# Beneficial Results

- Mentorship: For example, if a programmer has many errors, a programmer with fewer errors can be their mentor
- Performance: Well, I can't write anymore here
