#/usr/bin/python3

# pip install pytube
# python3 youtube_dl.py  https://youtube.com/******


import sys
from pytube import YouTube

def main(link):
    yt = YouTube(link)
    video = yt.get('mp4','720p')
    video.download('/Users/yeweijie/Desktop/')


if __name__ == "__main__":
    main(sys.argv[1])
