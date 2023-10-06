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

COPY ./bin/* /usr/local/bin/

#RUN mkdir -pv /var/teamhack/incoming

WORKDIR  /var/teamhack
VOLUME ["/var/teamhack/caps"]
ENV TEAMHACK_DOCKER=1
ENTRYPOINT [                                        \
  "/usr/bin/env",                                   \
  "ncat",                                           \
  "-4",                                             \
  "--port", "43415",                                \
  "--exec", "cap-recv.sh",                          \
  "--listen",                                       \
  "--keep-open",                                    \
  "--nodns",                                        \
  "--verbose"                                       \
]

expose 43415/tcp

