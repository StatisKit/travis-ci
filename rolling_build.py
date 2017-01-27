import urllib2
import os

url = urllib2.urlopen('https://api.travis-ci.org/repos/' + os.environ.get('TRAVIS_REPO_SLUG') + '/builds')
TRAVIS_BUILD_NUMBER = eval(url.readline().replace('null', 'None'), locals())[0]['number']
if int(TRAVIS_BUILD_NUMBER) > int(os.environ.get('TRAVIS_BUILD_NUMBER')):
  raise Exeception('Newer build found')
