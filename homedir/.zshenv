eval "$(/opt/homebrew/bin/brew shellenv)"

export XDG_CONFIG_HOME="$HOME/.config"

# MacOS paths
if [[ "$OSTYPE" == "darwin"* ]]; then
	export JAVA_HOME=$(/opt/homebrew/bin/brew --prefix openjdk)/libexec/openjdk.jdk/Contents/Home
	export PATH=/opt/homebrew/bin:$HOME/go/bin:$JAVA_HOME/bin:$PATH
# Linux paths
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
	export PATH=/usr/bin:$HOME/go/bin:$JAVA_HOME/bin:$PATH
fi

