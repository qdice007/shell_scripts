# encoding: UTF-8
__author__='LiBing'

from selenium import webdriver
from bs4 import BeautifulSoup
import requests


base_url = 'http://jandan.net/ooxx'
pic_dir = 'c:/my/jd_mm/'

drv = webdriver.PhantomJS()
drv.get(base_url)
html = drv.page_source
#print(html)
soup = BeautifulSoup(html, 'lxml')
curr_page = soup.select('.comments .cp-pagenavi .current-comment-page')
curr_page = curr_page[0].get_text()
curr_page = curr_page[1:-1]
print(curr_page)

for x in range(1,10):
    print(x)
    url = base_url + '/page-' + curr_page + '#comments'
    drv.get(url)
    soup = BeautifulSoup(drv.page_source, 'lxml')
    for pic in soup.select('.commentlist .view_img_link'):
        pic_addr = 'http:' + pic.attrs['href']
        if pic_addr.split('/')[-1].split('.')[-1] == 'jpg':
            pic_name = pic_addr.split('/')[-1]
            res = requests.get(pic_addr)
            data = res.content
            fhandle = open(pic_dir + pic_name, "wb")
            fhandle.write(data)
            fhandle.close()
    curr_page = str(int(curr_page) - 1)
drv.quit()
