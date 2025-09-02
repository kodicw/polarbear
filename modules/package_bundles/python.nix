{ pkgs, ... }:
with pkgs; [
  uv
  pkgs.python314.withPackages
  (ps: with ps; [
    html5lib
    playwright
    pandas
    pexpect
    pillow
    pyinfra
    netifaces
    pyserial
    cryptography
    tqdm
    schedule
    rns
    requests
    nomadnet
    typer
    flask
    selenium
    sqlalchemy
    numpy
    ffmpeg-python
    openpyxl
    google-api-python-client
    pyquery
    joblib
    fabric
    feedparser
    langchain
    beautifulsoup
    rich
    openai
    python-lsp-server
  ])
]
