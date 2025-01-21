# 🚂 Infrastructure as Code - Railway

**Ever dreamed of having a lifetime VPS for free?** Well, dream on, because that’s not exactly what this project does (but close enough, right?). Welcome to the *Infrastructure as Code - Railway* project, where you can deploy a pseudo-VPS using **Railway** with tools like **Ngrok**, **Rclone**, and **Docker**—because why spend money when you can spend time tinkering with configs? 🎉

---

## 🚀 **Why This Exists**

1. **Tired of paying for cloud services?**  
   This project helps you **kind of** set up a VPS using Railway’s generous free tier.  

2. **Ngrok? Check. Rclone? Check.**  
   Integrates tunneling, cloud storage, and a questionable obsession with making things work in a container.  

3. **Deploy Faster than You Can Read This!**  
   Just click the magical button below and let the chaos begin.  

[![Deploy on Railway](https://railway.app/button.svg)](https://railway.app/new/template/BzFWCH?referralCode=dG01iI)

---

## 🛠️ **Project Features**

- **🚀 Free Tier VPS-like Setup:** 7GB RAM, 1.2TB of storage, 69 CPUs (nice), and speeds you’ll never realistically hit—up to 100Gbps.  
- **🔗 Integrated Ngrok Tunneling:** Expose your services to the world (or hackers, who knows).  
- **☁️ Cloud Storage with Rclone:** Because local storage is overrated.  
- **📦 Dockerized Environment:** Fully containerized setup because everyone loves bloated images.  
- **⚙️ Auto SSH Configuration:** Root access with a pre-configured password (*security? what’s that?*).

---

## 🐍 **Tech Stack**

- **Python (Flask + Gunicorn):** Who doesn’t love running an HTTP server on steroids?  
- **Docker:** Containers within containers, because *Inception* was cool.  
- **Ngrok:** Tunnels so good, you might forget your IP address.  
- **Rclone:** Sync all the things! (Even when you don’t want to).  
- **Railway:** The unsung hero funding your free cloud ambitions.  

---

## 🎯 **How It Works**

1. **Ngrok Integration:**  
   - Set up a tunnel to expose your services.  
   - Share your endpoint with friends, enemies, or random strangers.  

2. **Rclone Configuration:**  
   - Sync your favorite files to your preferred cloud service—no questions asked.  

3. **Pre-configured SSH Access:**  
   - Root password is set to `Demo12345`. (Yes, it’s hardcoded. No, we don’t care).  

4. **Flask App:**  
   - Minimal app to keep things running. Visit `/` and admire the pointless page it serves.

---

## 🛑 **Known Limitations**

- **🔒 Security? Never heard of it!**  
   - Hardcoded passwords, open ports, and an Ngrok token lying around? Hackers will love you.  

- **🖥️ Overloaded Dockerfile:**  
   - Who needs clean builds when you can cram everything into one image?  

- **⚠️ Rclone Config:**  
   - You’re expected to somehow manage your cloud storage configuration. Good luck.  

- **📉 Free Tier Constraints:**  
   - Don’t expect to run anything serious—Railway might throttle or stop your container if it gets too “enthusiastic.”  

---

## 🛡️ **How to Deploy**

### 1️⃣ Prerequisites
- **Ngrok Account:** [Sign Up](https://dashboard.ngrok.com/).  
- **Railway Account:** [Create One](https://railway.app?referralCode=BwO6_M).  
- **NGROK_TOKEN:** Grab it from your Ngrok dashboard.  
- A sense of adventure (or despair).

### 2️⃣ Deploy Steps
1. Clone this repo:  
   ```bash
   git clone https://github.com/yunus25jmi1/InfrastructureAsCode-Railway.git
   cd InfrastructureAsCode-Railway
   ```  

2. Click the Railway deploy button or run it locally with Docker if you enjoy debugging errors:  
   ```bash
   docker build -t iac-railway .
   docker run -p 8080:8080 iac-railway
   ```  

3. Pray everything works.

---

## 🧐 **Why Should You Use This?**

- **Because you can.**  
- **Because free stuff is fun.**  
- **Because debugging is the best way to spend your weekends.**  

---

## 📚 **FAQs**

**Q: Is this secure?**  
A: Define "secure."  

**Q: Can I run a production app with this?**  
A: Sure, if you hate your users.  

**Q: Why is this project sarcastic?**  
A: Because we can be.  

---

## 📜 **License**  

MIT License. Feel free to break stuff and blame us.  

---

Let me know if you'd like to tweak anything further! 😊
