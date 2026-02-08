{ pkgs, ... }:
pkgs.python312.withPackages (
  ps: with ps; [
    # pyinfra
    cryptography
    fabric
    feedparser
    ffmpeg-python
    flask
    google-api-python-client
    html5lib
    joblib
    langchain
    netifaces
    numpy
    openai
    openpyxl
    pandas
    pexpect
    pillow
    playwright
    pyquery
    pyserial
    python-lsp-server
    requests
    rich
    schedule
    selenium
    sqlalchemy
    tqdm
    twisted
    typer
  ]
)
