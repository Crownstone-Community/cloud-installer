# Crownstone cloud installer

This repository maintains scripts to install your own instance of Crownstone cloud on a local machine such as a Raspberry Pi (3/4/400).

Two ways to install: using Docker and using an install script.

## Install using Docker

Start using the exmple docker-compose:
```
git clone https://github.com/Crownstone-Community/cloud-installer.git
cd cloud-installer
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
cd docker
docker-compose up
```
Then view log of crownstone-cloud to see generated encryption keys.
Update the environment variables accordingly.

An example docker-compose file is included.
You can view all possible settings using environment variables in the dockerfiles.

For generating encryption keys, start crownstone-cloud with empty environment variables.
The new generated tokens will be shown in the log.

The ARM image has no support for the init-script.
For x64, change `mongo/mongo-init.js` before using the database as it will only run when the database is empty.

## Install using install script

The scripts install the complete Crownstone cloud, and updates it as well.

The Crownstone cloud uses MongoDB to store data. This script can install MongoDB as well. However, authorization will not be set up, though it will not be accessible via network.

The Crownstone cloud consists of:
- [Cloud-v1](https://github.com/crownstone-community/crownstone-cloud)
  - Handles login, and REST API calls.
- [Cloud-v2](https://github.com/crownstone-community/cloud-v2)
  - Handles new REST API calls, export and import of data.
- [SSE](https://github.com/crownstone-community/crownstone-sse-server)
  - Enables sending events to clients.
- [Webhooks](https://github.com/crownstone-community/crownstone-webhooks)
  - Enables sending updates to third parties (Google Home, Alexa, etc).
- [Hub](https://github.com/crownstone-community/hub)
  - Enables direct communication to the Crownstones (via a Crownstone USB dongle), and stores energy usage.
- [Cron](https://github.com/crownstone-community/cron)
  - Cleans up the database.
- [Bridge](https://github.com/crownstone-community/crownstone-cloud-bridge)
  - Nothing yet.


### Security

As with every server, you should make sure to keep the system up to date and reduce the attack surface.
Security is not set up by this installer script, you will have to do this yourself.

Think about:
- Installing *unattended-upgrades* configured with automatic reboot.
- Configuring ssh: disable password logins, use a different port, etc.
- Setting up a firewall.
- Installing (and configuring) *fail2ban*.
- Etc.

### Requirements

Most requirements come from the installation of [MongoDB](https://www.mongodb.com/docs/v4.4/administration/production-notes). When installing on a Raspberry Pi, ensure to use the 64-bit OS, as MongoDB requires an 64-bit OS. In case you want to install MongoDB manually or on another location, you can skip installing MongoDB during the installation process. This may require you to change the environment variables after installation (see below), but it allows you to run this installer on a user without sudo rights, and configure authentication on MongoDB.

Systemd is also required, as it's used to run the cloud in the background.

The installation has been tested on a Raspberry Pi 4 with Raspberry Pi OS Lite 64-bit. Download the dedicated [Raspberry PI Imager](https://www.raspberrypi.com/software/) to graphically choose this image, directly configure WiFi, enable SSH key access, etc.

```
sudo rpi-imager
```

### Preparation

In the middle of the install script you will be asked for keys to be able to send push notifications from your local cloud instance towards the Android or iOS app. These keys can be provided by the maintainers. You can reach the maintainers for these keys at the [Crownstone Community discord server](https://discord.gg/TPYfMvV7bD).

Make sure to configure your server (the Rasperry Pi) to have a static local ip address. Usually this can be done by logging in on your router.

### Installation

During installation of all the tools, there's quite some network traffic. Preferably connect your hub through a wire rather than relying on a spotty WiFi connection.

Use the following commands to get this repository:
```
sudo apt update
sudo apt install -y git
git clone https://github.com/Crownstone-Community/cloud-installer.git
cd cloud-installer
git checkout $(git describe --tags `git rev-list --tags --max-count=1`)
```

MongoDB will be initialized with data by running `mongo mongo-init.js` with arguments from `mongo-args.txt`. If you don't provide these 2 files yourself, it will be copied from the template `mongo-init-template.js` and `mongo-args-template.txt` respectively.
At this moment, it is used to insert the keys that are used to send notifications to the phone app (see above at **preparation**). Feel free to ignore too, but in that case no push notifications will be sent to the Crownstone apps.

After that simply run the script (some confirmations may be asked during the installation process):
```
./install.sh ~/crownstone-cloud
```

### Monitoring

You can check the status of the various services with:

```
systemctl --user status cs-*
```

You can see logs with `journalctl --user`.

### Data import

Every user in your sphere will have to:
- Get their phone and log out from the Crownstone app (Settings -> Log Out).
- Download their data at [https://next.crownstone.rocks/user-data](https://next.crownstone.rocks/user-data).

Then, go to your own cloud v2 server [http://123.456.78.9:3050/import-data](http://123.456.78.9:3050/import-data) and the port configured for cloud v2. Make sure to replace `123.456.78.9` with the IP address of your server, you can find it with the command `hostname -I`.

Now upload the downloaded data. Note that this can take a while, wait until the page changes into "DONE".

### App settings

Every user in your sphere will have to perform this step.

Get your phone again and open the Crownstone app (where you logged out in the previous step).
Before loggin in, click on *Configure custom cloud*.

Now you can change the cloud address in the Crownstone app settings.
- Address of custom cloud v1: http://123.456.78.9:3000/api/
- Address of custom cloud v2: http://123.456.78.9:3050/api/
- Address of custom sse server: http://123.456.78.9:8000/sse/

Again, replace `123.456.78.9` with the IP address of your server, and use the ports as configured.

Now click *Validate and save*, and login.

Note: After a preliminary success message you may get a warning pop-up saying that the cloud endpoints are not stored. This is a known bug. As long as the preliminary message reported success, you're all good.

### Environment variables

During installation, the environmental variables used to configure the different repositories, are partially copied from template files and partially generated.
You can find them in `cloud-installer/repos`. For example `cloud-installer/repos/cloud-v2/environment-variables.sh`.

If you need to update these, for example when you manualy installed MongoDB, you will have to restart the service afterwards. For example: `systemctl --user restart cs-cloud-v2`.

### Resolving problems

Various problems can and have been encountered.

In general checking the status of the cloud services:
- `systemctl --user status cs-*`
- `journalctl --user`

Restarting a service:
- `systemctl --user restart my-service`

Removing a service:
- `systemctl --user stop my-service`
- `rm ~/.config/systemd/user/my-service.service`

#### Failed to connect to bus: No such file or directory
From a user account where systemctl workds, try using `machinectl shell cloud-user@` to get a shell where you login as the cloud user. See [this post](https://askubuntu.com/questions/1007055/systemctl-edit-problem-failed-to-connect-to-bus)

#### nvm errors

If you're encountering errors like this:

```
$HOME/.nvm/nvm.sh: line 3319: [: -ne: unary operator expected
$HOME/.nvm/nvm.sh: line 3323: [: -ne: unary operator expected
$HOME/.nvm/nvm.sh: line 3335: [: -ne: unary operator expected
```

It's a simple mistake in the `nvm.sh` script where `EXIT_CODE` has not been initialized.

```
local EXIT_CODE
EXIT_CODE = 0
```

It might not be a true issue though. Just getting rid of these warnings.

#### locale

If you get warnings about locale, feel free to ignore, but if you want to fix them:

Create a file `/etc/locale.conf` with the contents (choose your own favorite, the example here is `en_US.UTF-8`):

```
LANG=en_US.UTF-8
LC_ALL=en_US.utf-8
LANGUAGE=en_US.UTF-8
```

And run:

```
sudo apt install locales
sudo locale-gen "en_US.UTF-8"
sudo update-locale "en_US.UTF-8"
# logout and login
locale
```

And everything should be filled in.

#### Hub function

When you see something like this, it might be that the USB discovery of the dongle is not working. Of course, you didn't forget to set up the dongle, isn't it? :-)

```
TypeError: Cannot read property 'write' of null
    at UartLinkManager.write (/home/crownstone-sysop/crownstone-cloud/hub/node_modules/crownstone-uart/dist/uartHandling/UartLinkManager.js:134:26)
```

Some debug tips:

```
vim /home/crownstone-sysop/.config/systemd/user/cs-hub.service
# Adjust restart of the hub server from 5 sec to something more.
RestartSec=5
```

Stop the hub server:

```
systemctl --user daemon-reload
systemctl --user stop cs-hub
```

Make sure it is not running:
```
ps aux | grep execute
# If there is some process, check from which path it is running, pstree doesn't give enough info here (pstree -s -p $PID)
pwdx $PID
# If it is `/home/crownstone-sysop/crownstone-cloud/hub`
kill -i $PID
# Iterate this a few times if necessary
```

Run it from the console:

```
 /home/crownstone-sysop/cloud-installer/repos/hub/run.sh /home/crownstone-sysop/crownstone-cloud/hub
```

And see if there are log statements with warnings/errors.

## Open-source license

This software is provided under a noncontagious open-source license towards the open-source community. It's available under three open-source licenses:
 
* License: LGPL v3+, Apache, MIT

<p align="center">
  <a href="http://www.gnu.org/licenses/lgpl-3.0">
    <img src="https://img.shields.io/badge/License-LGPL%20v3-blue.svg" alt="License: LGPL v3" />
  </a>
  <a href="https://opensource.org/licenses/MIT">
    <img src="https://img.shields.io/badge/License-MIT-yellow.svg" alt="License: MIT" />
  </a>
  <a href="https://opensource.org/licenses/Apache-2.0">
    <img src="https://img.shields.io/badge/License-Apache%202.0-blue.svg" alt="License: Apache 2.0" />
  </a>
</p>

## Commercial license

This software can also be provided under a commercial license. If you are not an open-source developer or are not planning to release adaptations to the code under one or multiple of the mentioned licenses, contact us to obtain a commercial license.

* License: Crownstone commercial license

# Contact

For any question contact us at <https://crownstone.rocks/contact/> or on our discord server through <https://crownstone.rocks/forum/>.
