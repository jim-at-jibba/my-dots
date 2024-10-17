get_model() {
  if ping -c 1 google.com >/dev/null 2>&1; then
    # Connected
    echo "gpt-4o"
  else
    # Not Connected
    echo "llama3.2:latest"
  fi
}
