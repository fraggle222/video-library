This simple project will pull YouTube playlists and display the videos in a "Pulse" styled grid (horizontal
and vertical scrolling). Current version should be run for iPhone only at this stage. iPad resources to come.

[Note: the large number of GData files will be grouped nicely into one folder once you open your XCode project.
These files and the YouTube folder are from Googles objective-c library https://code.google.com/p/gdata-objectivec-client/]

You can edit the Config.plist file to specify the baseURL. This should be of the form:
https://gdata.youtube.com/feeds/api/users/YouTubeUserName/playlists?v=2

You can also specify a title for the main screen there. Future updates will include more configuration entries for
colors, sizes, etc.

In the current release, the playlists need to be public, however, since this project includes the GData classes
from Google it would be fairly easy to authenticate for private access.

The grid will scroll horizontally and vertically. When a cell is touched it launches another view controller which holds 
a webview to run the youtube video.

