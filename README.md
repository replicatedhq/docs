# Replicated Documentation Site

## Contributing

Contributions are welcome and encouraged!  We have published a [Contributing Guide](CONTRIBUTING.md) to define a writing style to use.

## Dependencies

- Asciidoctor
- Pygments
- Hugo v0.19+

## Running locally

## Via Docker on OSX

1. Install Docker for OSX.
1. Clone this repo into ~/docs (**Important** it's important to put this under your home directory somewhere when using Docker for OSX)
1. Run `docker-compose up`

The docs site will be available at http://localhost:5913/docs/getting-started/

## Via Hugo on OSX

1. Install Hugo
```bash
brew install hugo
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
hugo server -w --source site/
```
