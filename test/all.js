var url = 'http://127.0.0.1:8000/index.html';

casper.options.waitTimeout = 1000;

casper.test.begin('Running tests...', function suite(test) {
  casper.start(url).then(function() {
    test.assertSelectorHasText('h1.header', 'Hello Pipelines!');
  });

  casper.run(function() {
    test.done();
  });
});
