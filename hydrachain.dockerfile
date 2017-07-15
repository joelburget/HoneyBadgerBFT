FROM honeybadger

RUN apt-get update && \
    apt-get install -y curl build-essential rsync

RUN pip install --upgrade pip setuptools

# Pre-install hydrachain dependency
RUN pip install secp256k1==0.13.2

WORKDIR /
ADD hydrachain/requirements.txt hydrachain/

WORKDIR /hydrachain
RUN pip install -r requirements.txt && cd .. && rm -rf /hydrachain
WORKDIR /

ADD hydrachain hydrachain
WORKDIR /hydrachain
RUN pip install . && cd .. && rm -rf /hydrachain

ENTRYPOINT ["/usr/local/bin/hydrachain"]

# Run multiple nodes in a single process
CMD ["-d", "datadir", "runmultiple", "--num_validators=3", "--seed=42"]
