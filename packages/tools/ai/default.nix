{ pkgs, ... }:
pkgs.buildEnv {
  name = "ai-tools";
  paths = with pkgs; [
    gemini-cli
    aider-chat-full
  ];
}
