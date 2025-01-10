# Habit Quest 🚀  

Welcome to **Habit Quest**, a gamified habit-tracking app designed to make building habits fun, engaging, and effective!  

---

## 🌐 **Links**  
- **Web App:** [Habit Quest Web Version](https://www.papps.io/)  
- **Download App:** [Habit Quest APK](https://github.com/lewiseman/solutech_habit_quest/blob/main/app_resources/app-release.apk)  

---

## 📌 **Good to Know**

While building this app, I initially started with **Appwrite** for data storage and authentication. However, I faced issues with Appwrite's Google login, so I switched to **Firebase** as  last minute solution for authentication while keeping **Appwrite** for data storage.

---

## 🔍 **Overview**

Habit Quest allows you to:
- Create, edit, delete, pause, and skip habits effortlessly.
- Focus on active habits only—paused habits won’t show up on your dashboard.  
- Work both **online and offline**, thanks to an **offline-first approach** using Hive for local data storage.

The result is a seamless experience whether you're connected or not.

---

## 🛠️ **How to Run**

To get the app running, here’s what you need to know:

| **Requirement**               | **Version**                   |
|-------------------------------|-------------------------------|
| Flutter                       | 3.24.5                        |
| Android Studio                | Jellyfish 2023.3.1 Patch 2    |

1. **Important Compatibility Note:**  
   Some versions of Flutter may conflict with the latest Android Studio updates, so please double-check compatibility.  

2. **Building the App:**  
   - The app is signed because Firebase signup requires it. Signing details are stored securely in the project's secrets.  
   - You can:
     - Build the **release version** using GitHub Actions.  
     - Build the **development version** locally.  

---

## 🌟 **Features Overview**

### **Authentication**
Here’s how users can log in or sign up:  
- **Email and Password:** Fully implemented and functional.  
- **Google Sign-In:** Also supported for quick access.  

---

### **Habits Management**
The core of the app is managing habits. Here’s what you can do:  

| **Action**         | **How It Works**                                                                                     |
|--------------------|-----------------------------------------------------------------------------------------------------|
| **Create Habit**    | Use the floating action button on the habits page to add a new habit.                              |
| **Edit Habit**      | Tap on a habit, select "Edit" from the popup menu, or manage it via the "My Habits" section.       |
| **Delete Habit**    | Go to "My Habits," tap the habit, and select "Delete."                                             |
| **Pause Habit**     | Pause a habit via "My Habits" to temporarily exclude it from your main dashboard.                  |
| **Skip Habit**      | Skip any upcoming habit directly from the dashboard.                                               |
| **Track Progress**  | View habit summaries and analytics on the "Journey" page under the "Summary" tab.                  |

---

### **Gamification**
To make habit tracking fun and rewarding, I added these gamified features:  

| **Feature**           | **Description**                                                                                  |
|-----------------------|--------------------------------------------------------------------------------------------------|
| **Stats, Coins, Levels** | View your progress and achievements on the profile page.                                       |
| **Rewards**            | Earn a coin every time you complete a habit on time, with a fun animation for extra motivation.  |
| **Challenges**         | Explore predefined habits on the "Journey" page's "Explore" tab and add them to your list.       |
| **Badges**             | Unlock badges as you progress, viewable on the profile page.                                     |
| **Buy Items**          | Use your coins to buy avatars on the profile page.                                               |
| **Levels**             | Gain levels as you earn more coins (5 coins = 1 level).                                          |

---

### **Offline-First Functionality**
This app works flawlessly offline:  
- You can create, edit, delete, pause, and skip habits without needing an internet connection.  
- Data is stored locally using Hive and synced with the server when you’re back online.  
- The profile page displays your sync status, and you can manually trigger a sync if needed.

---

### **Notifications**
- **Automated Notifications:** When you create a habit, reminders are set up automatically.  
- **Customization:** You can adjust how many minutes before a habit starts you’d like to be notified.  
- **Settings:** Enable, disable, or refresh notifications in the settings page to troubleshoot.  

---

### **Theme and Responsiveness**
The app is designed to look great on any device:  
- **Responsive Design:** On mobile, there’s a bottom navigation bar, while web versions use a sidebar for navigation.  
- **Themes:** Switch between light and dark modes on the settings page.

---

## 🚀 **CI/CD Pipeline**

To streamline development and deployment, I’ve set up CI/CD processes:  

| **Action**          | **Description**                                                                                   |
|---------------------|--------------------------------------------------------------------------------------------------|
| **Web Deployment**   | Builds and deploys the web version to **Netlify**.                                               |
| **Mobile Builds**    | Automatically generates signed APKs and app bundles, uploaded as artifacts via GitHub Actions, the signing key is stored in the repo's secrets.   |

---

## 📸 **Screenshots and Demo**

Here’s a glimpse of Habit Quest in action:  

### **Screenshots**
| ![Splash](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.05%20AM%20(2).jpeg) | ![Select Time](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.05%20AM%20(1).jpeg) | ![Goal](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.05%20AM.jpeg) |
|-----------------------------------------------|--------------------------------------------------|---------------------------------------------------|
| Splash                                      | Select Time                                     | Goal                                    |

| ![Sign up](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.05%20AM%20(3).jpeg) | ![Dashboard](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.06%20AM.jpeg)    | ![Analytics](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.06%20AMs.jpeg)       |
|-----------------------------------------------|--------------------------------------------------|---------------------------------------------------|
| Sign up                                      | Dashboard                                          | Analytics                                            |

| ![Explore](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.06%20AM%20(1).jpeg) | ![My Habits](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.07%20AM.jpeg)    | ![New Level](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.07%20AM%20(1).jpeg)       |
|-----------------------------------------------|--------------------------------------------------|---------------------------------------------------|
| Explore                                      | My Habits                                          | New Level                                            |

| ![Profile](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.07%20AM%20(2).jpeg) | ![Notifications](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.08.08%20AM.jpeg)    | ![Badges](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.27.02%20AM.jpeg)       |
|-----------------------------------------------|--------------------------------------------------|---------------------------------------------------|
| Profile                                      | Notifications                                          | Badges                                            |

| ![Avatars](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.27.01%20AM%20(1).jpeg) | ![Theme](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.27.02%20AM%20(1).jpeg) | ![Share](https://raw.githubusercontent.com/lewiseman/solutech_habit_quest/refs/heads/main/app_resources/WhatsApp%20Image%202025-01-10%20at%206.27.02%20AM%20(2).jpeg)        |
|------------------------------------------------|---------------------------------------------------|---------------------------------------------------|
| Avatars                                      | Theme                                     | Share                                            |

---



---

## 🎯 **Conclusion**

Habit Quest isn’t just a habit tracker—it’s a companion that motivates you to stay consistent while making the journey enjoyable. With offline-first support, gamification, and a seamless user experience, I hope Habit Quest inspires you to take control of your daily routines.  

Thank you for checking it out, and I’d love to hear your feedback!
Reach out incase of anything