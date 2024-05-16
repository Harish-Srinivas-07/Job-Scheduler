# Job Report App Development Plan 📊⏰💼

Welcome to the exciting world of Job Report app development! 🚀 This comprehensive plan outlines the key functionalities required to build an efficient app for tracking daily tasks and working hours. Let's dive into the details and discover how we can create a seamless user experience. Get ready to revolutionize task reporting! 💥

## Table of Contents 📜

- [Main Screen Display](#main-screen-display-)
- [Calculate Total Worked Hours](#calculate-total-worked-hours-)
- [Task Creation](#task-creation-)
- [Idle Time Logging](#idle-time-logging-)
- [Sleep Recovery](#sleep-recovery-)
- [Hourly Prompt](#hourly-prompt-)
- [Display Job Descriptions](#display-job-descriptions-)
- [Logout and Reporting](#logout-and-reporting-)
- [Deploy in GitHub Pages](#deploy-in-github-pages-)

## Main Screen Display 🖥️

Create a dashboard screen showcasing tasks completed for the current day. Display task ID, start time, job description, and status. Dynamically calculate and prominently display total worked hours.

## Calculate Total Worked Hours ⏰

Retrieve start time of user's workday upon login. Traverse logged tasks for the day, excluding idle or inactive periods. Calculate total duration between start time and current time, excluding idle and inactive time. Update total worked hours value dynamically.

## Task Creation ✍️

Implement functionality to create new tasks upon user login, assigning unique ID, job start time, and description. Allow users to mark tasks as completed. Automatically update task status based on user activity.

## Idle Time Logging ⏳

Implement timer mechanism to track system activity continuously. Log idle periods if system remains inactive for 5 minutes.

## Sleep Recovery 😴

Detect system waking from sleep mode or idle time. Prompt user to enter job description to seamlessly log period before idle time.

## Hourly Prompt ⏰

Set up timer to prompt user every hour to enter job description and close time period. Log job descriptions for each hour to maintain detailed activity log.

## Display Job Descriptions 📝

Present job descriptions below each task, including descriptions entered for every hour and period before idle time. Provide comprehensive details for each logged period.

## Logout and Reporting 📊

Upon logout, calculate total working hours assuming standard working day. Calculate total work time considering only active and on-meeting hours. Send detailed report with total working hours to user via email.

## Deploy in GitHub Pages 🌐

Build flutter web project and generate HTML files. Deploy build files to GitHub Pages and share the link. Push code to GitHub and share repository link 🛠️🚧📱
