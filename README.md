# Ubuntu-Mate Desktop Dockerfile for xyce (based on chenjr0719/ubuntu-mate-novnc)

Docker container for Ubuntu 16.04 including ubuntu-desktop, vnc and novnc server.

## How to build

`docker build -t "rapatel0/xyce_docker" . `


## How to run with VNC client and noVNC

`docker run -itd -p 80:6080 -p 5901:5901 PASSWORD=password SUDO=yes rapatel0/xyce_docker `

This setup provides vnc client on port 5901 and noVNC access on port 80. The username is ubuntu and the password is specified by the commandline arguement. By default the container is launched with sudo support for 'ubuntu' user. Keep in mind you will need to mount a volume inorder to save files and simulations with xyce. 

---

# More usage details from chenjr0719 

## Arguments

This image contains 3 input argument:

1. Password

   You can set your own user password as you like:
   ```
   sudo docker run -itd -p 80:6080 -e PASSWORD=$YOUR_PASSWORD chenjr0719/ubuntu-mate-novnc
   ```
   Now, you can user your own password to log in.

2. Sudo

   In default, the user **ubuntu** will not be the sudoer, but if you need, you can use this command:
   ```
   sudo docker run -itd -p 80:6080 -e SUDO=yes chenjr0719/ubuntu-mate-novnc
   ```

   This command will grant the **sudo** to user **ubuntu**.

   And use **SUDO=YES**, **SUDO=Yes**, **SUDO=Y**, **SUDO=y** are also supported.

   To check the sudo is work , when you open **MATE Terminal** it should show following message:
   ```
   To run a command as administrator (user "root"), use "sudo <command>".
   See "man sudo_root" for details.
   ```

   ![alt text](https://github.com/chenjr0719/Docker-Ubuntu-MATE-noVNC/raw/master/sudo.png "sudo")

   **Caution!!** allow your user as sudoer may cause security issues, use it carefully.

3. Ngrok

   [Ngrok](https://ngrok.com/) can be used to deploy localhost to the internet.

   If you need to use this image across the internet, Ngrok is what you need.

   To enable Ngrok, use following command:

   ```
   sudo docker run -itd -p 80:6080 -e NGROK=yes chenjr0719/ubuntu-mate-novnc
   ```

   And find the link address:

   ```
   sudo docker exec $CONTAINER_ID cat /home/ubuntu/ngrok/Ngrok_URL.txt
   ```

   **NGROK=YES**, **NGROK=Yes**, **NGROK=Y**, **NGROK=y** are also supported.

    **Caution!!** this may also cause security issues, use it carefully.


## Screen size

The default setting of screen siz is 1600x900.

You can change screen by using following command, this will change screen size to 1024x768:

```
sudo docker exec $CONTAINER_ID sed -i "s|-geometry 1600x900|-geometry 1024x768|g" /etc/supervisor/conf.d/supervisor.conf
sudo docker restart $CONTAINER_ID
