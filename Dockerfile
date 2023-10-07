FROM kalilinux/kali-rolling as build

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update

RUN apt full-upgrade -y            \
    --no-install-recommends

RUN apt install      -y            \
    --no-install-recommends        \
    aircrack-ng                    \
    ncat

RUN apt autoremove   -y            \
    --purge                        \
&&  apt clean        -y            \
&&  rm -rf /var/lib/apt/lists/*

COPY ./bin/* /var/teamhack/bin/
ENV PATH=/var/teamhack/bin:$PATH
RUN command -v aircrack-ng.lst.sh
RUN command -v cap-recv.sh

#RUN mkdir -pv /var/teamhack/incoming

WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/caps"]
VOLUME ["/var/teamhack/psks"]
ENV TEAMHACK_DOCKER=1
RUN test -x /usr/bin/env
RUN command -v ncat
ENTRYPOINT [                                        \
  "/usr/bin/env",                                   \
  "ncat",                                           \
  "-4",                                             \
  "--source-port", "43415",                         \
  "--exec",        "bin/cap-recv.sh",               \
  "--listen",                                       \
  "--keep-open",                                    \
  "--nodns",                                        \
  "--verbose"                                       \
]

expose 43415/tcp

