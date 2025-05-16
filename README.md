# Extraction of Various Gallery Layouts Challenge

This solution can extract data from Carousel, Grid, List, Table and Horizontal Gallery layouts.

## Installation

```bash
bundle install
```

## Running

To scrape `van-gogh-paintings.html` only, you can run the code without any arguments:
```bash
ruby bin/run.rb
```

To scrape all the html's inside files directory, you can run the code with `all` argument:
```bash
ruby bin/run.rb all
```

To scrape individual html's, you can pass the html path:
```bash
ruby bin/run.rb ./html/michelangelo.html
```

To run the rspec tests:
```bash
rspec spec/parser-spec.rb
```

The result JSON's can be found in output directory.
## Layout types

This code has been tested with 5 different layouts.

### Carousel

![Sandro Botticelli Artwork](https://github.com/rocketdey/code-challenge/blob/master/files/carousel.png "Sandro Botticelli Artwork")

### Grid

![Metallica Albums](https://github.com/rocketdey/code-challenge/blob/master/files/grid.png "Metallica Albums")

### Table

![The Off Season Songs](https://github.com/rocketdey/code-challenge/blob/master/files/table.png "The Off Season Songs")

### Horizontal Gallery

![Michelangelo](https://github.com/rocketdey/code-challenge/blob/master/files/horizontal-gallery.png "Michelangelo")

### List

![Hemlocke Springs Albums](https://github.com/rocketdey/code-challenge/blob/master/files/list.png "Hemlocke Springs Albums")
