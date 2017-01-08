# C.H.I.P. LoveTrack Button Host

This is an ansible library that deploys a fresh C.H.I.P. with all configuration and software required for running as a LoveTrack Button host.

In this document, the C.H.I.P. will be called `lovetrack`, whereas the controlling machine is called `control`.

# Prepare the Control Machine

* Make sure you have a recent [Ansible installation](http://docs.ansible.com/ansible/intro_installation.html):

  ```bash
  control$ brew install ansible
  ```

  Replace `brew` with `yum` or `apt-get`, depending on your OS.

* Install the required Ansible roles:

  ```bash
  control$ ansible-galaxy install geerlingguy.ntp jnv.unattended-upgrades
  ```

# Prepare the C.H.I.P.

* Boot the C.H.I.P. with a [fresh firmware](https://flash.getchip.com/).

* Log on at the console

  ```bash
  control$ screen /dev/tty.usbmodem*
  ```

  Use `chip` for both username and password. You may have to press ENTER to see the login screen. Exit via pressing `Control-A` and then `Control-Alt-Shift + 7` (on a German keyboard, at least.).

* Enable sshd:

  ```bash
  chip$ sudo service ssh start
  ```

* Connect to WiFi:

  ```bash
  sudo su -
  env TERM=linux nmtui
  ```

  Setting the TERM variable was necessary because ncurses has issues.

# Environment variables

* `LOVETRACK_SERVER_URL` must point to a running instance of the LoveTrack server. It must be set on the control machine.

# First Deployment

The C.H.I.P. will start with the default hostname `chip` so that we need to pass a custom inventory:

```bash
control$ ansible-playbook -i chip, --ask-become-password deployment/playbook.yml
```

We also need `--ask-become-password` because, other than on the Raspberry Pi, the default C.H.I.P. installation asks for the user's password when doing `sudo`. This is changed with the first deployment and `--ask-become-password` is not required afterwards.

# Subsequent Deployments

The first deployment did set the hostname to `lovetrack` and also copied the public key, so that subsequent deployments become as simple as:

```bash
control$ ansible-playbook deployment/playbook.yml
```

# Troubleshooting

## Tailing the log file

The following will tail entries related to `lovetrack-button` from the system journal:

```bash
sudo journalctl -u lovetrack-button -f
```
