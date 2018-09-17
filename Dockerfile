# base image
FROM pelias/baseimage

# downloader apt dependencies
# note: this is done in one command in order to keep down the size of intermediate containers
RUN apt-get update && apt-get install -y autoconf automake libtool pkg-config python bzip2 unzip && rm -rf /var/lib/apt/lists/*

# change working dir
ENV WORKDIR /code/pelias/whosonfirst
WORKDIR ${WORKDIR}

# add code from local checkout
ADD . ${WORKDIR}

# install required utilities
RUN apt-get update && \
    apt-get install -y vim curl

# install node 6.x
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - && \
    apt-get install -y nodejs

# move original node and symlink
RUN mv /usr/local/bin/node /usr/local/bin/node.original

RUN ln -s /usr/bin/nodejs /usr/local/bin/node


# install npm dependencies
RUN npm install

# run tests
RUN npm test

# run as the pelias user
USER pelias
