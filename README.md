# Replicated Documentation Site

## Contributing
Contributions are welcome and encouraged!  We have published a [Contributing Guide](CONTRIBUTING.md) to define a writing style to use.

## Running locally

## Via Docker on OSX

1. Install Docker for OSX.
1. Clone this repo into ~/docs (**Important** it's important to put this under your home directory somewhere when using Docker for OSX)
1. Run `docker-compose up`

The docs site will be available at http://localhost:5913/docs/getting-started/

## Via Hugo on OSX

1. Install v0.18 of Hugo
```bash
cd /tmp
wget https://github.com/gohugoio/hugo/releases/download/v0.18.1/hugo_0.18.1_macOS-64bit.zip
tar xzf hugo_0.18.1_macOS-64bit.zip
rm -r hugo_0.18.1_macOS-64bit.zip
mv hugo /usr/local/bin/hugo18
```
1. Install asciidoctor
```bash
brew install git ruby
sudo gem install asciidoctor
```
1. Install Pygments `pip install Pygments`
1. Setup API docs
```bash
make setup
make SOURCE="https://api.staging.replicated.com/vendor" vendordocs
```
1. Run Hugo server
```bash
hugo18 server -w --source site/
```
