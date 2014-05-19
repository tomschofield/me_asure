

#import scraperwiki
import httplib2
import urllib2
import re
from bs4 import BeautifulSoup
import datetime

#get api key from env variables
import os, cgi
# try:
#     qsenv = dict(cgi.parse_qsl(os.getenv("QUERY_STRING")))
#     apikey=qsenv["OC_KEY"]
# except:
#     ockey=''

apikey = 'xxxxx'

search_term='portrait'
page='1'
per_page ='500'

def locallySavePicture(url, count):
    # picture_page[-4:] extracts extension eg. .gif
    # (most image file extensions have three letters, otherwise modify)
    
    filename = "image_"+str(count)+".jpg"

    opener1 = urllib2.build_opener()
    page1 = opener1.open(url)
    my_picture = page1.read()
    # open file for binary write and save picture
    fout = open(filename, "wb")
    fout.write(my_picture)
    fout.close()
    
    print ("Saved as: "+filename)
    return filename

def replaceMwithB(url):
    # exploded = url.split('.')
    # firsthalf =''
    # for bit, index in enumerate(exploded):
    #     if(index<(len(exploded)-2)):
    #         firsthalf+=bit
    # print firsthalf
    withoutM  = url[:-5]
    withoutM+='b'
    withoutM+='.jpg'
    return withoutM

def getPage(page, imageCount):
    base_url='http://api.flickr.com/services/rest/?method=flickr.photos.search&api_key='
    #base_url='http://api.flickr.com/services/rest/?method=flickr.photos.search'

    #query api with this custom url
    full_query=base_url+apikey+'&tags='+search_term+'&page='+page+'&per_page='+per_page

    #xml = scraperwiki.scrape(full_query)

    #make an xml tree with beautiful soup
    #soup = BeautifulSoup.BeautifulSoup(xml)
    http = httplib2.Http()
    #status, response = http.request('http://www.eufeeds.eu/at')
    status, response = http.request(full_query)
    #for each entry
    #print response
    soup = BeautifulSoup(response)

    count = 0
    for photo in soup.findAll('photo'):
        #get the stuff we need to construct a url as described here http://www.flickr.com/services/api/misc.urls.html
        #print photo
        farm_id = photo['farm']
        server_id= photo['server']
        photo_id = photo['id']
        secret = photo['secret']
        size='m'
        link_url ='http://farm'+farm_id+'.staticflickr.com/'+server_id+'/'+photo_id+'_'+secret+'_'+size+'.jpg'
        print link_url#scraperwiki.sqlite.save(unique_keys=["a"], data={"a":link_url})
        #print replaceMwithB(link_url)
        try:
            locallySavePicture(replaceMwithB(link_url), imageCount)
        except:
            print 'no image available'
        imageCount+=1

imageCount = 1000
count =4
print 'counting'
while count <100:
    getPage(str(count), imageCount)
    count+=1



#http://farm{farm-id}.staticflickr.com/{server-id}/{id}_{o-secret}_o.(jpg|gif|png)
#http://farm8.staticflickr.com/7457/13894814580_75a9863b20_m.jpg
