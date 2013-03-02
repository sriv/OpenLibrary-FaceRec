OpenLibrary-FaceRec
===================

Openlibrary implementation with skybiometry for face recognition

Setup
=====
Rename skybiometry.yml.sample to skybiometry.yml and add your api_key, spi_secret. Note that actual 'skybiometry.yml' and 'web/skybiometry.yml' files are ignored in git.

TODO
=====
Find a way to have restful links instead of ugly query strings. Rack does not support named parameters in URL by default. Sinatra is one option, but is there a simpler way?