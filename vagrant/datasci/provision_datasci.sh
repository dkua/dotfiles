export DEBIAN_FRONTEND=noninteractive
sudo apt-get -y install tmux vim zsh git-core
sudo apt-get install wget
$ANACONDA=http://09c8d0b2229f813c1b93-c95ac804525aac4b6dba79b00b39d1d3.r79.cf1.rackcdn.com/Anaconda-1.6.1-Linux-x86_64.sh
if [ ! -a Anaconda-1.6.1-Linux-x86_64.sh ]; then
    wget $ANACONDA
fi
if [ ! -d /anaconda ]; then
    bash Anaconda-1.6.1-Linux-x86_64.sh
fi
