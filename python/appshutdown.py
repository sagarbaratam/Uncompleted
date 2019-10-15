
import subprocess
apps = ['Slack','Microsoft Outlook']

def appshut(apps):
    for app in apps:
       subprocess.call(["osascript", "-e",app])
       print(app)

appshut(apps)




