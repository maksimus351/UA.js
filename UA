(function() {
    var plugin = {
        id: 'uakino_source',
        name: 'uAkino.me',
        version: '1.0',
        description: 'Film source from uakino.me',
        url: 'https://uakino.me', // Link to the site
    };

    // Search function
    function search(query, callback) {
        var url = 'https://uakino.me/search?query=' + encodeURIComponent(query); // URL for searching movies on the site

        fetch(url)
            .then(response => response.text())
            .then(text => {
                // Parsing the HTML response to extract needed data
                var parser = new DOMParser();
                var doc = parser.parseFromString(text, 'text/html');
                var movies = doc.querySelectorAll('.item');

                var results = Array.from(movies).map(movie => ({
                    title: movie.querySelector('.title').innerText, // Movie title
                    url: movie.querySelector('a').href, // Movie link
                    poster: movie.querySelector('img') ? movie.querySelector('img').src : '', // Movie poster
                    year: movie.querySelector('.year') ? movie.querySelector('.year').innerText : '', // Movie year
                    quality: movie.querySelector('.quality') ? movie.querySelector('.quality').innerText : 'Not specified' // Movie quality
                }));

                callback(results); // Return search results
            })
            .catch(error => console.error('Error fetching data:', error));
    }

    function install() {
        Lampa.Source.add(plugin.id, {
            title: plugin.name,
            search: search
        });
    }

    Lampa.Plugin.add(plugin.id, install);
})();
